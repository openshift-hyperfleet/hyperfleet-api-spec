import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/statuses/model.tsp";
import "../models/common/model.tsp";
import "../models/nodepools/model.tsp";
import "../models/resource/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

@route("/clusters/{cluster_id}/statuses")
@useAuth(HyperFleet.BearerAuth)
@tag("Cluster statuses")
interface ClusterStatusesInternal {
  @route("")
  @put
  @summary("Adapter creates or updates cluster status")
  @operationId("putClusterStatuses")
  @doc("Adapters call this endpoint to report the status for a cluster after each evaluation. The adapter's status entry is created if it doesn't exist, or updated if it does (upserted by adapter name). This allows HyperFleet to aggregate multiple adapter perspectives into a unified cluster status.")
  putClusterStatuses(
    /**
     * Cluster ID
     */
    @path cluster_id: string,

    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | BadRequestResponse
    | NotFoundResponse
    | ConflictResponse;
}

@tag("NodePool statuses")
@route("/clusters/{cluster_id}/nodepools/{nodepool_id}/statuses")
@useAuth(HyperFleet.BearerAuth)
interface NodePoolStatusesInternal {
  @route("")
  @put
  @summary("Adapter creates or updates nodepool status")
  @operationId("putNodePoolStatuses")
  @doc("Adapters call this endpoint to report the status for a nodepool after each evaluation. The adapter's status entry is created if it doesn't exist, or updated if it does (upserted by adapter name). This allows HyperFleet to aggregate multiple adapter perspectives into a unified nodepool status.")
  putNodePoolStatuses(
    /**
     * Cluster ID
     */
    @path cluster_id: string,

    /**
     * NodePool ID
     */
    @path nodepool_id: string,

    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | BadRequestResponse
    | NotFoundResponse
    | ConflictResponse;
}

@tag("Resource statuses")
@route("/resources/{resource_id}/statuses")
@useAuth(HyperFleet.BearerAuth)
interface ResourceStatusesInternal {
  /**
   * Returns adapter statuses for a resource.
   */
  @route("")
  @get
  @summary("List resource statuses")
  @operationId("getResourceStatuses")
  getResourceStatuses(
    @path resource_id: string,
    ...QueryParams,
  ): Body<AdapterStatusList>
    | Error
    | NotFoundResponse
    | BadRequestResponse;

  @route("")
  @put
  @summary("Adapter creates or updates resource status")
  @operationId("putResourceStatuses")
  @doc("Adapters call this endpoint to report status for a resource after each evaluation. The adapter's status entry is created if it doesn't exist, or updated if it does (upserted by adapter name).")
  putResourceStatuses(
    @path resource_id: string,
    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | BadRequestResponse
    | NotFoundResponse
    | ConflictResponse;
}

@tag("Resources")
@route("/resources")
@useAuth(HyperFleet.BearerAuth)
interface ResourcesForceDelete {
  /**
   * Permanently removes the resource record from the database for a resource stuck in Finalizing state.
   * This is a database-only operation. Requires a reason for audit purposes.
   */
  @route("/{resource_id}/force-delete")
  @post
  @summary("Force-delete a resource")
  @operationId("forceDeleteResource")
  forceDeleteResource(
    @path resource_id: string,
    @body body: ForceDeleteRequest,
  ): {
    @statusCode statusCode: 204;
  } | Error
    | NotFoundResponse
    | BadRequestResponse
    | ConflictResponse;
}

