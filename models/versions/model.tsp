import "@typespec/openapi";
import "../common/model.tsp";
import "../../aliases.tsp";

using OpenAPI;

model VersionBase {
  ...APIResource;

  /**
   * Version name (unique within a channel, e.g., "4.17.12")
   */
  @minLength(1)
  @maxLength(63)
  name: string;

  spec: VersionSpec;
}

@example(exampleVersion)
model Version {
  ...VersionBase;
  ...APIMetadata;

  /**
   * Generation field is updated on customer updates, reflecting the version of the "intent" of the customer
   */
  @minValue(1)
  generation: int32;

  owner_references: ObjectReference;
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
