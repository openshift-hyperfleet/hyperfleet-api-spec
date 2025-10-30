import "../common/model.tsp";
import "../statuses/model.tsp";
model NodePoolSpec {
    provider: string;
}

model ProviderNodePoolSpec {
    schema: string;
    data: unknown;
}

model Nodepool {
    ...APIResource<KindNodePool>;
    owner_references: APIResourceReference<KindCluster>;

    /** Name of the nodepool */
    name: string;

    /** NodePool specification */
    spec: Record<unknown>;

    status: {
        /**
         * Current NodePool phase (native database column).
         * Updated when adapters report status.
         * Note: status.phase provides aggregated view from all adapter conditions.
         */
        phase: "Pending" | "Ready" | "Failed";

        /**
         * Last generation processed by adapters
         * Updated when adapters report status.
         * This will be the lowest value of each adapter's observed_generation values
         * The phase value is based on this generation
         */
        observed_generation: integer;

        /**
         * When NodePool last transitioned (updated by adapters, used by Sentinel for backoff)
         */
        @format("date-time") last_transition_time: string;

        /** Time of the last complete report from adapters
         * Updated when adapters report status.
         * Oldest `updated_at` from the adapter conditions
         */
        @format("date-time") updated_at: string;

        adapters: ConditionAvailable[];
    };
}

model NodepoolCreateRequest {}

model NodepoolCreateResponse {}

model NodepoolUpdateRequest {}
