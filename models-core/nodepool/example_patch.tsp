import "../../aliases-core.tsp";
import "../../models/nodepools/model.tsp";

const exampleNodePoolPatchRequest: NodePoolPatchRequest = #{
  spec: #{},
  labels: #{ env: "staging" },
};
