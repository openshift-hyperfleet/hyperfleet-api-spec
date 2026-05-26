# HyperFleet API Spec - AI Agent Context

This repository generates the HyperFleet core OpenAPI specification from TypeSpec definitions. The GCP-specific contract lives in [hyperfleet-api-spec-gcp](https://github.com/openshift-hyperfleet/hyperfleet-api-spec-gcp), which imports shared models from this repo as the `hyperfleet` npm package.

## Quick Reference

**Build commands:**
```bash
npm run build                # Generate core OpenAPI spec
./build-schema.sh            # Same, via script directly
```

**Validation workflow:**
```bash
npm install                              # Install dependencies
./build-schema.sh                        # Build core OpenAPI 3.0
ls -l schemas/core/openapi.yaml          # Confirm output exists
```

## Key Concepts

### Repository Layout

```
shared/          # Cross-provider models and services (published as the `hyperfleet` npm package)
core/            # Core-only models and internal services
main.tsp         # Entry point — imports shared + core
schemas/core/    # Generated output (committed)
```

**When adding new models:**
- Cross-provider models → `shared/models/`
- Core-only models → `core/models/`
- GCP-specific → separate repo (`hyperfleet-api-spec-gcp`)

### Public vs Internal APIs

Status endpoints are split:
- `shared/services/statuses.tsp` - GET operations (external clients)
- `core/services/statuses-internal.tsp` - PUT operations (internal adapters only) and resource force-delete

The split allows generating different API contracts per audience. Only `statuses.tsp` is imported by default.

## Code Style

### TypeSpec Conventions

**Imports first, namespace second** (applies to service and model files; example `const` files do not declare a namespace):
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
shared/models/{resource}/
  ├── model.tsp          # Shared model definitions
  └── interfaces.tsp     # Optional: shared interfaces

shared/services/
  └── {resource}.tsp     # Shared service endpoints

core/models/{resource}/
  └── model.tsp          # Core-specific models

core/services/
  └── {resource}-internal.tsp  # Internal-only endpoints
```

## Boundaries

**DO NOT:**
- Modify generated files in `schemas/` or `tsp-output-core/` directly
- Add dependencies without checking TypeSpec version compatibility
- Auto-generate documentation - it degrades agent performance per research
- Commit `node_modules/` or build artifacts

**DO:**
- Run `./build-schema.sh` and commit `schemas/core/openapi.yaml` with your changes
- Keep TypeSpec files focused (one resource per service file)
- Use semantic versioning for releases (automated on merge to main)

## Common Tasks

### Add a new endpoint to existing service

```typescript
// shared/services/clusters.tsp
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
// shared/models/health/model.tsp
import "@typespec/http";

model HealthStatus {
  id: string;
  state: "healthy" | "degraded" | "critical";
  lastChecked: utcDateTime;
}
```

2. Create service:
```typescript
// shared/services/health.tsp
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
import "./shared/services/health.tsp";
```

4. Build: `npm run build`

### Add provider-specific fields

Provider-specific models live in the provider's own repository (e.g., `hyperfleet-api-spec-gcp`). See that repo for examples of how to extend core shared models.

## Version Bump and Changelog

When bumping the version in `main.tsp`, always update `CHANGELOG.md`:

1. Keep `## [Unreleased]` at the top, then add a new version section as `## [X.Y.Z] - YYYY-MM-DD`
2. List changes under appropriate headings (`Added`, `Changed`, `Fixed`, `Removed`)
3. Update the comparison links at the bottom of the file
4. Follow [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format

## Validation Checklist

Before submitting changes:

- [ ] Dependencies installed: `npm install`
- [ ] Core schema builds: `./build-schema.sh`
- [ ] Schema file generated: `ls schemas/core/openapi.yaml`
- [ ] No TypeSpec compilation errors (check output)
- [ ] Schema passes linting: `spectral lint schemas/core/openapi.yaml`
- [ ] Changes committed including schema update
- [ ] PR description references related issue

## Build System Details

**The build-schema.sh script:**
1. Extracts the version from `main.tsp` and syncs it into `package.json`
2. Runs `node_modules/.bin/tsp compile main.tsp --output-dir tsp-output-core`
3. Moves output to `schemas/core/openapi.yaml`

**Output locations:**
- TypeSpec temp: `tsp-output-core/schema/openapi.yaml` (auto-deleted)
- Final: `schemas/core/openapi.yaml` (committed)

**Version sync:** `package.json` version is kept in lockstep with `main.tsp` automatically on every build. The CI consistency check (`git diff --exit-code`) enforces that both are committed together.

## VS Code Extension Notes

The TypeSpec extension may show false errors for models resolved only at compile time. Both the CLI and "Emit from TypeSpec" command work correctly.

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

Releases are **fully automated** via GitHub Actions (`.github/workflows/release.yml`).

On every push to `main`, the release workflow:
1. Extracts the version from the `@info` decorator in `main.tsp`
2. Skips if a tag for that version already exists
3. Builds the core OpenAPI schema
4. Creates an annotated Git tag (`vX.Y.Z`)
5. Publishes a GitHub Release with `core-openapi.yaml` attached

The CI workflow (`.github/workflows/ci.yml`) enforces that the version in `main.tsp` is bumped from the latest release tag before a PR can be merged.

To release a new version, simply bump the version in `main.tsp` and merge to `main`.

## Architecture Context

This repository is part of the HyperFleet project. For broader context:
- Architecture repo: https://github.com/openshift-hyperfleet/architecture
- Main API implementation: https://github.com/openshift-hyperfleet/hyperfleet-api

The API implementation consumes the generated OpenAPI specs for validation and documentation.
