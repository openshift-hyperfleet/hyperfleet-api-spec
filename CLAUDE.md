# HyperFleet API Spec - AI Agent Context

This repository generates OpenAPI specifications from TypeSpec definitions. It supports multiple provider variants (core, GCP) using a shared codebase with provider-specific type aliases.

## Quick Reference

**Build commands:**
```bash
npm run build:core           # Generate core OpenAPI spec
npm run build:gcp           # Generate GCP OpenAPI spec
npm run build:all           # Generate all variants with Swagger
```

**Validation workflow:**
```bash
npm install                              # Install dependencies
./build-schema.sh gcp                   # Build GCP OpenAPI 3.0
./build-schema.sh gcp --swagger         # Build GCP OpenAPI 2.0 (Swagger)
./build-schema.sh core                  # Build core OpenAPI 3.0
./build-schema.sh core --swagger        # Build core OpenAPI 2.0 (Swagger)
ls -l schemas/*/openapi.yaml            # Confirm outputs exist
```

## Key Concepts

### Provider Variants via Aliases

The repo uses a single `main.tsp` but generates different specs per provider:

```typescript
// aliases-core.tsp
alias ClusterSpec = Record<unknown>;  // Generic

// aliases-gcp.tsp
alias ClusterSpec = GCPClusterSpec;   // Provider-specific
```

The `aliases.tsp` symlink determines which provider types are active. The `build-schema.sh` script automatically re-links this during builds.

**When adding new models:**
- Shared models → `models/`
- Provider-specific → `models-{provider}/`
- Always update alias files if you introduce provider-specific types

### Public vs Internal APIs

Status endpoints are split:
- `services/statuses.tsp` - GET operations (external clients)
- `services/statuses-internal.tsp` - POST operations (internal adapters only)

The split allows generating different API contracts per audience. Only `statuses.tsp` is imported by default.

## Code Style

### TypeSpec Conventions

**Imports first, namespace second:**
```typescript
import "@typespec/http";
import "../models/common/model.tsp";

namespace HyperFleet;
```

**Use decorators for HTTP semantics:**
```typescript
@route("/clusters")
interface Clusters {
  @get list(): Cluster[] | Error;
  @post create(@body cluster: ClusterInput): Cluster | Error;
}
```

**Model naming:**
- Resources: `Cluster`, `NodePool` (singular)
- Inputs: `ClusterInput`, `NodePoolInput`
- Provider-specific: `GCPClusterSpec`, `AWSClusterSpec`

### File Organization

```
models/{resource}/
  ├── model.tsp          # Shared model definitions
  └── interfaces.tsp     # Optional: shared interfaces

models-{provider}/{resource}/
  └── model.tsp          # Provider-specific models

services/
  └── {resource}.tsp     # Service endpoints
```

## Boundaries

**DO NOT:**
- Modify generated files in `schemas/` or `tsp-output/` directly
- Add dependencies without checking TypeSpec version compatibility
- Auto-generate documentation - it degrades agent performance per research
- Use `--swagger` flag unless you need OpenAPI 2.0 for legacy tools
- Commit `node_modules/` or build artifacts

**DO:**
- Run builds in this order before committing schema changes:
  1. `./build-schema.sh gcp`
  2. `./build-schema.sh gcp --swagger`
  3. `./build-schema.sh core`
  4. `./build-schema.sh core --swagger`
- Test both provider variants when modifying shared models
- Keep TypeSpec files focused (one resource per service file)
- Use semantic versioning for releases (see RELEASING.md)

## Common Tasks

### Add a new endpoint to existing service

```typescript
// services/clusters.tsp
namespace HyperFleet;

@route("/clusters")
interface Clusters {
  // ... existing endpoints ...

  @get
  @route("/{id}/health")
  getHealth(@path id: string): HealthStatus | Error;
}
```

### Add a new resource

1. Create model:
```typescript
// models/health/model.tsp
import "@typespec/http";

model HealthStatus {
  id: string;
  state: "healthy" | "degraded" | "critical";
  lastChecked: utcDateTime;
}
```

2. Create service:
```typescript
// services/health.tsp
import "@typespec/http";
import "../models/health/model.tsp";
import "../models/common/model.tsp";

namespace HyperFleet;

@route("/health")
interface Health {
  @get check(): HealthStatus | Error;
}
```

3. Import in `main.tsp`:
```typescript
import "./services/health.tsp";
```

4. Build: `npm run build:core`

### Add provider-specific fields

```typescript
// models-gcp/cluster/model.tsp
model GCPClusterSpec {
  projectId: string;
  region: string;
  network?: GCPNetwork;
}

model GCPNetwork {
  vpcId: string;
  subnetId: string;
}
```

Update alias:
```typescript
// aliases-gcp.tsp
import "./models-gcp/cluster/model.tsp";
alias ClusterSpec = GCPClusterSpec;
```

Build: `npm run build:gcp`

## Validation Checklist

Before submitting changes:

- [ ] Dependencies installed: `npm install`
- [ ] GCP variant builds: `./build-schema.sh gcp`
- [ ] GCP Swagger builds: `./build-schema.sh gcp --swagger`
- [ ] Core variant builds: `./build-schema.sh core`
- [ ] Core Swagger builds: `./build-schema.sh core --swagger`
- [ ] Schema files generated: `ls schemas/*/openapi.yaml`
- [ ] No TypeSpec compilation errors (check output)
- [ ] Changes committed including schema updates
- [ ] PR description references related issue

## Build System Details

**The build-schema.sh script:**
1. Validates provider parameter (core, gcp, etc.)
2. Re-links `aliases.tsp` → `aliases-{provider}.tsp`
3. Runs `tsp compile main.tsp`
4. Copies output to `schemas/{provider}/openapi.yaml`
5. (Optional) Converts to OpenAPI 2.0 with `--swagger` flag

**Output locations:**
- TypeSpec: `tsp-output/schema/openapi.yaml` (temporary)
- Final: `schemas/{provider}/openapi.yaml` (committed)

## VS Code Extension Notes

The TypeSpec extension may show false errors:
- Non-active provider models appear undefined (expected)
- Duplicate type warnings from multiple alias files (expected)

Both the CLI and "Emit from TypeSpec" command work correctly despite warnings.

## Dependencies

All TypeSpec libraries use version `^1.6.0` for consistency:
- `@typespec/compiler` - Core compiler
- `@typespec/http` - HTTP semantics
- `@typespec/openapi` - OpenAPI decorators
- `@typespec/openapi3` - OpenAPI 3.0 emitter
- `@typespec/rest` - REST conventions
- `@typespec/versioning` - API versioning support

**Adding new TypeSpec libraries:**
```bash
npm install --save-dev @typespec/library-name@^1.6.0
```

Match the version range to existing dependencies.

## Release Process

Quick reference (see RELEASING.md for details):

```bash
# 1. Build schemas
npm run build:all

# 2. Commit and tag
git add schemas/
git commit -m "chore: update schemas for vX.Y.Z"
git tag -a vX.Y.Z -m "Release vX.Y.Z"

# 3. Push tag
git push upstream vX.Y.Z

# 4. Create GitHub Release with schema assets
gh release create vX.Y.Z \
  --repo openshift-hyperfleet/hyperfleet-api-spec \
  --title "vX.Y.Z" \
  schemas/core/openapi.yaml#core-openapi.yaml \
  schemas/gcp/openapi.yaml#gcp-openapi.yaml
```

## Architecture Context

This repository is part of the HyperFleet project. For broader context:
- Architecture repo: https://github.com/openshift-hyperfleet/architecture
- Main API implementation: https://github.com/openshift-hyperfleet/hyperfleet-api

The API implementation consumes the generated OpenAPI specs for validation and documentation.
