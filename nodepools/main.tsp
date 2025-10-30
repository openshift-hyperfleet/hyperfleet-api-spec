import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./model.tsp";
import "../common/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

@tag("NodePools")
interface Nodepools {
    /**
     * Returns the list of all nodepools
     */
    @route("/nodepools")
    @get
    @summary("List all nodepools for cluster")
    get_all_nodepools(
        ...QueryParams
    ): Body<Page<Nodepool>>;

    /**
     * Returns specific nodepool
     */
    @route("/nodepools/{nodepool_id}")
    @get
    @summary("Get nodepool by ID")
    get_nodepool(
        /**
         * Nodepool ID
         */
        @format("uuid") @path nodepool_id: Identifier,
    ): Nodepool | NotFoundResponse;

    /**
     * Returns the list of all nodepools for a cluster
     */
    @route("/{cluster_id}/nodepools")
    @get
    @summary("List all nodepools for cluster")
    get_nodepools_by_cluster_id(
        /** Cluster ID */
        @format("uuid") @path cluster_id: Identifier,
        ...QueryParams
    ): Body<Page<Nodepool>>;

    /**
     * Create a NodePool for a cluster
     */
    @route("/{cluster_id}/nodepools")
    @post
    @summary("Create nodepool")
    create_nodepool(
        /** Cluster ID */
        @format("uuid") @path cluster_id: string,
        @body body: NodepoolCreateRequest,
    ):
        | (CreatedResponse & NodepoolCreateResponse)
        | BadRequestResponse
        | NotFoundResponse
        | ConflictResponse;

}
