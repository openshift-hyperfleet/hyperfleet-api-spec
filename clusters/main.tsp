import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./model.tsp";

import "../statuses/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;
@route("/")
@tag("Clusters")
interface Clusters {
  @get
  @summary("List clusters")
  get_clusters(...QueryParams): Body<Page<Cluster>>;

  @route("/{cluster_id}")
  @get
  @summary("Get cluster by ID")
  get_cluster_by_id(
    @format("uuid") @path cluster_id: string,
  ): Cluster | NotFoundResponse;

  /**
   * Create a new cluster resource.
   *
   * **Note**: The `status` object in the response is read-only and computed by the service.
   * It is NOT part of the request body. Initially, status.phase will be "Pending" and
   * status.adapters will be empty until adapters POST their status.
   *
   */
  @route("/")
  @post
  @summary("Create cluster")
  post_cluster(@body body: ClusterCreateRequest): (CreatedResponse &
    Cluster) | BadRequestResponse;

}
