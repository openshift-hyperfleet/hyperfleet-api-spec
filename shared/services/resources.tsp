import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/resource/model.tsp";
import "../models/common/model.tsp";
import "../models/statuses/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

@tag("Resources")
@route("/resources")
@useAuth(HyperFleet.BearerAuth)
interface Resources {
  /**
   * Returns a paginated list of all resources, optionally filtered by kind, labels, or TSL query.
   */
  @get
  @route("")
  @summary("List resources")
  @operationId("getResources")
  getResources(...QueryParams): Body<ResourceList>
    | Error
    | BadRequestResponse;

  /**
   * Returns a single resource by its ID.
   */
  @route("/{resource_id}")
  @get
  @summary("Get resource by ID")
  @operationId("getResourceById")
  getResourceById(
    ...SearchParams,
    @path resource_id: string,
  ): Resource
    | Error
    | NotFoundResponse
    | BadRequestResponse;

  /**
   * Create a new resource. Only top-level entity types (no parent) can be created
   * via this endpoint. Child entities must use the nested route under their parent.
   */
  @route("")
  @post
  @summary("Create resource")
  @operationId("postResource")
  postResource(@body body: ResourceCreateRequest): {
    @statusCode statusCode: 201;
    @body resource: Resource;
  } | Error
    | BadRequestResponse;

  /**
   * Patch a resource by ID. Supports partial updates to spec, labels, and references.
   */
  @route("/{resource_id}")
  @patch
  @summary("Patch resource by ID")
  @operationId("patchResourceById")
  patchResourceById(
    @path resource_id: string,
    @body body: ResourcePatchRequest,
  ): Resource
    | Error
    | NotFoundResponse
    | BadRequestResponse
    | ConflictResponse;

  /**
   * Marks the resource for deletion. Child resources are handled per their
   * OnParentDelete policy (cascade or restrict). Returns 409 if a restrict-policy
   * child exists or if another resource holds a reference to this one.
   */
  @route("/{resource_id}")
  @delete
  @summary("Request resource deletion")
  @operationId("deleteResourceById")
  deleteResourceById(
    @path resource_id: string,
  ): {
    @statusCode statusCode: 202;
    @body resource: Resource;
  } | NotFoundResponse
    | ConflictResponse
    | Error
    | BadRequestResponse;

}
