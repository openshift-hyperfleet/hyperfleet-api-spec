import "./model.tsp";
import "../common/model.tsp";

const exampleResource: Resource = #{
  kind: "MyResource",
  id: "019466a0-8f8e-7abc-9def-0123456789ab",
  href: "/api/hyperfleet/v1/resources/019466a0-8f8e-7abc-9def-0123456789ab",
  name: "my-resource-1",
  labels: #{ environment: "production", team: "platform" },
  spec: #{},
  generation: 1,
  status: #{
    conditions: #[],
  },
  created_time: "2025-06-01T00:00:00Z",
  updated_time: "2025-06-01T10:02:00Z",
  created_by: "user-123@example.com",
  updated_by: "user-123@example.com",
};
