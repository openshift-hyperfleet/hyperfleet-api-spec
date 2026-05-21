import "./model.tsp";

const exampleResourceCreateRequest: ResourceCreateRequest = #{
  kind: "MyResource",
  name: "my-resource-1",
  spec: #{},
  labels: #{ environment: "production", team: "platform" },
};
