import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./model.tsp";

import "../statuses/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;
//@tag("Clusters")
@route("/clusters")
interface Clusters {
  @get
  @route("")
  @summary("List clusters")
  @operationId("getClusters")
  getClusters(...QueryParams): Body<ClusterList>;

  @route("/{cluster_id}")
  @get
  @summary("Get cluster by ID")
  @operationId("getClusterById")
  getClusterById(
    @path cluster_id: string,
  ): Cluster | Error;

  /**
   * Create a new cluster resource.
   *
   * **Note**: The `status` object in the response is read-only and computed by the service.
   * It is NOT part of the request body. Initially, status.phase will be "NotReady" and
   * status.adapters will be empty until adapters POST their status.
   *
   */
  @route("")
  @post
  @summary("Create cluster")
  @operationId("postCluster")
  postCluster(@body body: ClusterCreateRequest): (CreatedResponse &
    Cluster) | Error;

}
