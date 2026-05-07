// Package schemas exposes the generated HyperFleet OpenAPI schema files as an embedded filesystem.
// Consumers can import this package to access versioned schema content without vendoring local copies.
//
// Usage:
//
//	import specschemas "github.com/openshift-hyperfleet/hyperfleet-api-spec/schemas"
//
//	data, err := specschemas.FS.ReadFile("gcp/openapi.yaml")
package schemas

import "embed"

//go:embed core/openapi.yaml core/swagger.yaml gcp/openapi.yaml gcp/swagger.yaml
var FS embed.FS
