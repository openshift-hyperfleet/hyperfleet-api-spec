import "@typespec/openapi";
import "../common/model.tsp";
import "../../aliases.tsp";

using OpenAPI;

model ChannelBase {
  ...APIResource;

  /**
   * Channel name (unique)
   */
  @minLength(3)
  @maxLength(53)
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  name: string;

  spec: ChannelSpec;
}

@example(exampleChannel)
model Channel {
  ...ChannelBase;
  ...APIMetadata;

  /**
   * Generation field is updated on customer updates, reflecting the version of the "intent" of the customer
   */
  @minValue(1)
  generation: int32;
}

@example(exampleChannelCreateRequest)
model ChannelCreateRequest {
  ...ChannelBase;
}

@extension("minProperties", 1)
@extension("additionalProperties", false)
@example(exampleChannelPatchRequest)
model ChannelPatchRequest {
  spec?: ChannelSpec;
  labels?: Record<string>;
}

model ChannelList {
  ...List<Channel>;
}
