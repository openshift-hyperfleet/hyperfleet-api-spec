# Contributing to HyperFleet API Spec

Thank you for your interest in contributing to the HyperFleet API specification! This document provides guidelines for contributing to the project.

## Development Setup

### Prerequisites

- Node.js 20.x or later
- npm 11.6.2 or later (included in package.json packageManager)
- Git
- (Optional) Visual Studio Code with the TypeSpec extension

### Initial Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/openshift-hyperfleet/hyperfleet-api-spec.git
   cd hyperfleet-api-spec
   ```

2. Install TypeSpec compiler globally:
   ```bash
   npm install -g @typespec/compiler
   ```

3. Install project dependencies:
   ```bash
   npm install
   ```

4. Verify your setup by building the schemas:
   ```bash
   npm run build:core
   npm run build:gcp
   ```

## Repository Structure

```
hyperfleet-api-spec/
├── main.tsp                  # Main TypeSpec entry point
├── aliases.tsp              # Active provider aliases (symlink)
├── aliases-core.tsp         # Core provider aliases
├── aliases-gcp.tsp          # GCP provider aliases
├── tspconfig.yaml           # TypeSpec compiler configuration
├── build-schema.sh          # Build script for OpenAPI generation
├── models/                  # Shared models for all providers
│   ├── clusters/           # Cluster resource definitions
│   ├── nodepools/          # NodePool resource definitions
│   ├── statuses/           # Status resource definitions
│   └── common/             # Common types and models
├── models-core/            # Core provider-specific models
├── models-gcp/             # GCP provider-specific models
├── services/               # Service definitions
│   ├── clusters.tsp        # Cluster endpoints
│   ├── nodepools.tsp       # NodePool endpoints
│   ├── statuses.tsp        # Status read endpoints (public)
│   └── statuses-internal.tsp  # Status write endpoints (internal)
└── schemas/                # Generated OpenAPI outputs
    ├── core/
    └── gcp/
```

## Testing

### Building Schemas

Test your changes by building the OpenAPI schemas:

```bash
# Build individual variants
npm run build:core
npm run build:gcp

# Build with Swagger (OpenAPI 2.0) output
npm run build:core:swagger
npm run build:gcp:swagger

# Build all variants
npm run build:all
```

### Validating Output

After building, verify the generated schemas:

```bash
# Check that files were generated
ls -l schemas/core/openapi.yaml
ls -l schemas/gcp/openapi.yaml

# Review the generated OpenAPI for your changes
cat schemas/core/openapi.yaml
```

### Visual Studio Code Extension

If using VS Code with the TypeSpec extension:
- The extension may show errors for non-active provider types (this is expected)
- Use "Emit from TypeSpec" command to compile
- The `build-schema.sh` script always works regardless of extension errors

## Common Tasks

### Adding a New Model

1. Create the model file in the appropriate directory:
   ```typescript
   // models/newresource/model.tsp
   import "@typespec/http";
   import "../common/model.tsp";

   model NewResource {
     id: string;
     name: string;
   }
   ```

2. Import in `main.tsp` if needed
3. Build and verify: `npm run build:core`

### Adding a New Service Endpoint

1. Create or edit a service file in `services/`:
   ```typescript
   // services/newservice.tsp
   import "@typespec/http";
   import "@typespec/openapi";
   import "../models/common/model.tsp";

   namespace HyperFleet;

   @route("/new-resource")
   interface NewService {
     @get list(): NewResource[] | Error;
   }
   ```

2. Import in `main.tsp`:
   ```typescript
   import "./services/newservice.tsp";
   ```

3. Build and verify: `npm run build:all`

### Adding a New Provider

1. Create provider model directory:
   ```bash
   mkdir -p models-aws/cluster
   ```

2. Define provider-specific models:
   ```typescript
   // models-aws/cluster/model.tsp
   model AWSClusterSpec {
     awsProperty1: string;
     awsProperty2: string;
   }
   ```

3. Create provider aliases file:
   ```typescript
   // aliases-aws.tsp
   import "./models-aws/cluster/model.tsp";
   alias ClusterSpec = AWSClusterSpec;
   ```

4. Update `build-schema.sh` to support the new provider (it auto-detects)
5. Build: `./build-schema.sh aws`

### Switching Between Providers in VS Code

The `aliases.tsp` symlink controls which provider is active:

```bash
# Work on Core API
ln -sf aliases-core.tsp aliases.tsp

# Work on GCP API
ln -sf aliases-gcp.tsp aliases.tsp
```

The VS Code extension uses whichever provider `aliases.tsp` points to.

## Commit Standards

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - New feature or endpoint
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring without functionality change
- `test:` - Adding or updating tests
- `chore:` - Build process or tooling changes

**Examples:**
```
feat: add NodePool autoscaling fields to GCP spec
fix: correct required fields in ClusterStatus model
docs: update README with new provider examples
refactor: consolidate common status fields
```

## Release Process

See [RELEASING.md](RELEASING.md) for detailed release instructions.

**Quick summary:**
1. Build schemas: `npm run build:all`
2. Commit changes
3. Create tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
4. Push tag: `git push upstream vX.Y.Z`
5. Create GitHub Release with `core-openapi.yaml` and `gcp-openapi.yaml` assets

## Pull Request Process

1. Create a feature branch: `git checkout -b feature/my-feature`
2. Make your changes
3. Build and test: `npm run build:all`
4. Commit with conventional commit message
5. Push to your fork
6. Create a Pull Request
7. Address review feedback
8. Wait for approval and merge

### PR Guidelines

- Keep PRs focused on a single change
- Include schema outputs in commits when they change
- Update documentation if you change functionality
- Reference related issues in PR description

## Architecture and Documentation

For broader HyperFleet architecture context and documentation standards, see the [HyperFleet Architecture Repository](https://github.com/openshift-hyperfleet/architecture).

## Getting Help

- Open an issue for bugs or feature requests
- Check existing issues before creating new ones
- Tag issues appropriately (bug, enhancement, documentation, etc.)

## Code of Conduct

Be respectful and constructive in all interactions. We aim to foster an inclusive and welcoming community.
