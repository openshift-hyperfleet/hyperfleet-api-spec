import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./model.tsp";
import "../common/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

@tag("NodePools")
interface NodePools {
    /**
     * Returns the list of all nodepools
     */
    @route("/nodepools")
    @get
    @summary("List all nodepools for cluster")
    @operationId("getNodePools")
    getNodePools(...QueryParams): Body<Page<NodePool>>;

    /**
     * Returns specific nodepool
     */
    @route("/nodepools/{nodepool_id}")
    @get
    @summary("Get nodepool by ID")
    @operationId("getNodePoolById")
    getNodePoolById(
        /**
         * NodePool ID
         */
        @path nodepool_id: Identifier,
    ): NodePool | NotFoundResponse;

    /**
     * Returns the list of all nodepools for a cluster
     */
    @route("/{cluster_id}/nodepools")
    @get
    @summary("List all nodepools for cluster")
    @operationId("getNodePoolsByClusterId")
    getNodePoolsByClusterId(
        /** Cluster ID */
         @path cluster_id: Identifier,

        ...QueryParams,
    ): Body<Page<NodePool>>;

    /**
     * Create a NodePool for a cluster
     */
    @route("/{cluster_id}/nodepools")
    @post
    @summary("Create nodepool")
    @operationId("createNodePool")
    createNodePool(
        /** Cluster ID */
         @path cluster_id: string,

        @body body: NodePoollCreateRequest,
    ):
        | (CreatedResponse & NodePoolCreateResponse)
        | BadRequestResponse
        | NotFoundResponse
        | ConflictResponse;
}
