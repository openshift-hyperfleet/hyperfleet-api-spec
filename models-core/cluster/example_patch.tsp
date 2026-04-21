import "../../aliases-core.tsp";
import "../../models/clusters/model.tsp";

const exampleClusterPatchRequest: ClusterPatchRequest = #{
  spec: #{},
  labels: #{ env: "staging" },
};
