import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/channels/model.tsp";
import "../models/common/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;
@tag("Channels")
@route("/channels")
@useAuth(HyperFleet.BearerAuth)
interface Channels {
  @get
  @route("")
  @summary("List channels")
  @operationId("getChannels")
  @doc("Returns a list of all channels.")
  getChannels(...QueryParams): Body<ChannelList>
    | Error
    | BadRequestResponse;

  @route("/{channel_id}")
  @get
  @summary("Get channel by ID")
  @operationId("getChannelById")
  @doc("Returns a single channel by its ID.")
  getChannelById(
    ...SearchParams,
    @path channel_id: string,
  ): Channel
    | Error
    | NotFoundResponse
    | BadRequestResponse;

  /**
   * Create a new channel resource.
   */
  @route("")
  @post
  @summary("Create channel")
  @operationId("postChannel")
  postChannel(@body body: ChannelCreateRequest):
  {
    @statusCode statusCode: 201;
    @body channel: Channel;
  } | Error
    | BadRequestResponse;

  /**
   * Patch a specific channel by ID
   */
  @route("/{channel_id}")
  @patch(#{implicitOptionality: true})
  @summary("Patch channel by ID")
  @operationId("patchChannelById")
  patchChannelById(
    /** Channel ID */
    @path channel_id: string,
    @body body: ChannelPatchRequest,
  ): Channel
    | Error
    | NotFoundResponse
    | BadRequestResponse
    | ConflictResponse;

  /**
   * Marks the channel for deletion by setting deleted_time to the current time, cascades to its versions.
   * The channel remains in the database until it is fully deleted.
   * Returns the updated channel with generation incremented.
   */
  @opExample(#{ returnType: #{ statusCode: 202, channel: exampleDeletedChannel } })
  @route("/{channel_id}")
  @delete
  @summary("Request channel deletion")
  @operationId("deleteChannelById")
  deleteChannelById(
    @path channel_id: string,
  ): {
    @statusCode statusCode: 202;
    @body channel: Channel;
  } | NotFoundResponse
    | Error
    | BadRequestResponse;

}
