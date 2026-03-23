import "../common/model.tsp";
import "../statuses/model.tsp";
import "../../aliases.tsp";

model ClusterBase {
  ...APIResource;

  /**
   * RFC4122 UUID identifier for the cluster (immutable, assigned at creation).
   * This provides a stable, standards-compliant identifier for platform integrations
   * that require UUID format (e.g., Hypershift spec.clusterID).
   */
  @format("uuid")
  @example("550e8400-e29b-41d4-a716-446655440000")
  uuid?: string;

  /**
   * Cluster name (unique)
   */
  @minLength(3)
  @maxLength(53)
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  name: string;

  spec: ClusterSpec;
}

/**
 * Cluster status computed from all status conditions.
 *
 * This object is computed by the service and CANNOT be modified directly.
 * It is aggregated from condition updates posted to `/clusters/{id}/statuses`.
 *
 * Provides quick overview of all reported conditions.
 */
model ClusterStatus {

  /**
   * List of status conditions for the cluster.
   * 
   * **Mandatory conditions**: 
   * - `type: "Ready"`: Whether all adapters report successfully at the current generation.
   * - `type: "Available"`: Aggregated adapter result for a common observed_generation.   
   * 
   * These conditions are present immediately upon resource creation.
   */
  @minItems(2)
  conditions: ResourceCondition[];
}

@example(exampleCluster)
model Cluster {
  ...ClusterBase;
  ...APICreatedResource;

  /**
   * Generation field is updated on customer updates, reflecting the version of the "intent" of the customer
   */
  @minValue(1)
  generation: int32;

  status: ClusterStatus;
}

@example(exampleClusterCreateRequest)
model ClusterCreateRequest  {
    ...ClusterBase;
}

model ClusterList {
  ...List<Cluster>;
}
