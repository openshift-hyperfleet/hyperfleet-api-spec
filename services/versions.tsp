import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/versions/model.tsp";
import "../models/common/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

@tag("Versions")
@route("/channels/{channel_id}/versions")
@useAuth(HyperFleet.BearerAuth)
interface Versions {
    /**
     * Returns the list of all versions for a channel
     */
    @route("")
    @get
    @summary("List all versions for channel")
    @operationId("getVersionsByChannelId")
    getVersionsByChannelId(
        /** Channel ID */
        @path channel_id: Identifier,

        ...QueryParams,
    ): Body<VersionList>
      | Error
      | BadRequestResponse;

    /**
     * Create a Version for a channel
     */
    @route("")
    @post
    @summary("Create version")
    @operationId("createVersion")
    createVersion(
        /** Channel ID */
        @path channel_id: string,

        @body body: VersionCreateRequest,
    ):
         {
           @statusCode statusCode: 201;
           @body version: Version;
         }
         | Error
         | BadRequestResponse
         | ConflictResponse;

    /**
     * Returns specific version
     */
    @route("/{version_id}")
    @get
    @summary("Get version by ID")
    @operationId("getVersionById")
    getVersionById(
        /** Channel ID */
        @path channel_id: string,
        /** Version ID */
        @path version_id: string,
    ): Version
      | Error
      | NotFoundResponse
      | BadRequestResponse;

    /**
     * Marks the version for deletion by setting deleted_time and deleted_by.
     * Returns the updated version with generation incremented.
     */
    @opExample(#{ returnType: #{ statusCode: 202, version: exampleDeletedVersion } })
    @route("/{version_id}")
    @delete
    @summary("Request version deletion")
    @operationId("deleteVersionById")
    deleteVersionById(
        /** Channel ID */
        @path channel_id: string,
        /** Version ID */
        @path version_id: string,
    ): {
      @statusCode statusCode: 202;
      @body version: Version;
    } | NotFoundResponse
      | Error
      | BadRequestResponse;

    /**
     * Patch a specific version within a channel
     */
    @route("/{version_id}")
    @patch(#{implicitOptionality: true})
    @summary("Patch version by ID")
    @operationId("patchVersionById")
    patchVersionById(
        /** Channel ID */
        @path channel_id: string,
        /** Version ID */
        @path version_id: string,
        @body body: VersionPatchRequest,
    ): Version
      | Error
      | NotFoundResponse
      | BadRequestResponse
      | ConflictResponse;
}
