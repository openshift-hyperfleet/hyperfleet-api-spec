import "@typespec/openapi";
import "@typespec/http";
import "../../models/common/model.tsp";
import "../../models/statuses/model.tsp";
import "../../models/resource/model.tsp";

using OpenAPI;
using Http;

alias KindVersion = "Version";

model VersionSpec {
  /** Raw version string (e.g., "4.17.12") */
  raw_version: string;

  /** Whether this version is enabled for provisioning */
  enabled: boolean;

  /** Whether this is the default version for its channel */
  is_default: boolean;

  /** Container image reference for the release */
  release_image: string;

  /** When this version reaches end of life */
  @format("date-time") end_of_life_time?: string;
}

model VersionBase {
  ...APIResource;

  @minLength(1)
  @maxLength(63)
  name: string;

  spec: VersionSpec;
}

@example(exampleVersion)
model Version {
  ...VersionBase;
  ...APIMetadata;

  @minValue(1)
  generation: int32;

  owner_references: ObjectReference;

  status: ResourceStatus;
}

@example(exampleVersionCreateRequest)
model VersionCreateRequest {
  ...VersionBase;
}

@extension("minProperties", 1)
@extension("additionalProperties", false)
@example(exampleVersionPatchRequest)
model VersionPatchRequest {
  spec?: VersionSpec;
  labels?: Record<string>;
}

model VersionList {
  ...List<Version>;
}
