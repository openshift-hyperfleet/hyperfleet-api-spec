# Release Process

This document describes the automated release process for the HyperFleet API specification.

## Overview

Releases are **fully automated** via GitHub Actions. When a PR is merged to `main`, the release workflow (`.github/workflows/release.yml`) automatically creates a versioned GitHub Release with all schema artifacts attached.

**Manual tagging or asset uploads are no longer required.**

## Versioning Strategy

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version: Incompatible API changes (breaking changes)
- **MINOR** version: Backward-compatible functionality additions
- **PATCH** version: Backward-compatible bug fixes

Examples:
- Breaking change (removed endpoint, changed required field): `v1.0.0` -> `v2.0.0`
- New endpoint added: `v1.0.0` -> `v1.1.0`
- Documentation fix, typo correction: `v1.0.0` -> `v1.0.1`

## How to Release

1. Bump the version in `main.tsp` (the `@info` decorator's `version` field)
2. Update `CHANGELOG.md` with the new version and changes
3. Build all schemas: `npm run build:all`
4. Commit the version bump, changelog, and regenerated schemas
5. Open a PR and merge to `main`

The CI workflow enforces that the version in `main.tsp` has been bumped from the latest release tag. If the version is unchanged, CI will fail and block the merge.

## What the Automation Does

On every push to `main`, the release workflow:

1. **Extracts** the version from `main.tsp`
2. **Skips** if a Git tag for that version already exists (idempotent)
3. **Builds** all four schema variants from TypeSpec sources
4. **Creates** an annotated Git tag (`vX.Y.Z`)
5. **Publishes** a GitHub Release with auto-generated release notes and four artifacts:
   - `core-openapi.yaml` (OpenAPI 3.0)
   - `core-swagger.yaml` (OpenAPI 2.0)
   - `gcp-openapi.yaml` (OpenAPI 3.0)
   - `gcp-swagger.yaml` (OpenAPI 2.0)

## CI Validation

The CI workflow (`.github/workflows/ci.yml`) runs on every PR and push to `main`:

1. **Schema consistency** - Rebuilds all schemas and verifies they match committed files
2. **OpenAPI linting** - Runs `spectral lint` against the `spectral:oas` ruleset
3. **Version bump check** - Compares the version in `main.tsp` against the latest release tag

## Consuming Schemas

### Go Module

Downstream Go consumers can import schemas directly:

```go
import specschemas "github.com/openshift-hyperfleet/hyperfleet-api-spec/schemas"

data, err := specschemas.FS.ReadFile("gcp/openapi.yaml")
```

### Download URLs

**Latest release (always points to newest):**
- Core: `https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/core-openapi.yaml`
- GCP: `https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/gcp-openapi.yaml`

**Specific version:**
- Core: `https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/download/vX.Y.Z/core-openapi.yaml`
- GCP: `https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/download/vX.Y.Z/gcp-openapi.yaml`

## Troubleshooting

### CI fails with "Version matches latest release tag"

Bump the version in `main.tsp` before merging. The CI requires each merge to `main` to carry a new version number.

### Release not created after merge

Check that the version in `main.tsp` is new (no existing Git tag). The workflow is idempotent and skips if the tag already exists. Verify with:

```bash
git ls-remote --tags origin | grep vX.Y.Z
```

### "latest" URL returns older version

GitHub determines "latest" by semantic versioning, not chronological order. Ensure the new version number is higher than all existing tags and the release is not marked as a pre-release.

## Security Best Practices

1. **Versioning discipline**: Never delete or modify published releases
2. **Pre-releases**: Use pre-release tags for testing (`v1.0.0-rc1`, `v1.0.0-beta.1`)
3. **Review before merge**: Schema changes affect downstream consumers; review generated output carefully
