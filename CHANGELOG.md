# Changelog

All notable changes to the HyperFleet API specification will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CONTRIBUTING.md with development guidelines and workflow
- CHANGELOG.md following Keep a Changelog format
- CLAUDE.md with AI agent context and validation workflow

### Changed
- Improved README.md structure to align with HyperFleet documentation standards

## [1.0.2] - 2026-01-13

### Added
- GitHub Actions workflow for automated releases
- Standard schema component naming convention for provider schemas
- Generation field to NodePool models

### Changed
- Standardized TypeSpec schema definitions with enums and validation enhancements
- Refactored to support oapi-codegen compatibility
- Updated OWNERS file to not block approval by bot

### Fixed
- Release GitHub Action to install tsp compiler

## [1.0.0] - 2025-11-25

First official stable release of the HyperFleet API specification.

### Added
- Complete CRUD operations for clusters, nodepools, and statuses
- Status tracking and reporting with comprehensive history management
- Core API variant with generic cluster spec
- GCP API variant with GCP-specific cluster spec
- Kubernetes-style timestamp conventions
- List-based pagination for resource collections
- Separate public and internal status endpoints
- Interactive API documentation

### Architecture
- Simple CRUD operations only (no business logic)
- Separation of concerns: API layer focuses on data persistence; orchestration logic handled by external components

<!-- Links -->
[Unreleased]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.2...HEAD
[1.0.2]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.0...v1.0.2
[1.0.0]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/tag/v1.0.0
