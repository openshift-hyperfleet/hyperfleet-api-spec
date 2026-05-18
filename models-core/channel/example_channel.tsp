import "./model.tsp";
import "../../models/channels/model.tsp";
import "../../models/common/model.tsp";

const exampleChannel: Channel = #{
  kind: "Channel",
  id: "019466a2-1234-7abc-9def-0123456789ab",
  href: "https://api.hyperfleet.com/v1/channels/019466a2-1234-7abc-9def-0123456789ab",
  name: "stable",
  labels: #{ tier: "production" },
  spec: #{
    is_default: true,
    enabled_regex: "^4\\.\\d+\\.\\d+$",
  },
  generation: 1,
  created_time: "2021-01-01T00:00:00Z",
  updated_time: "2021-01-01T10:02:00Z",
  created_by: "user-123@example.com",
  updated_by: "user-123@example.com",
};

const exampleDeletedChannel: Channel = #{
  kind: "Channel",
  id: "019466a2-1234-7abc-9def-0123456789ab",
  href: "https://api.hyperfleet.com/v1/channels/019466a2-1234-7abc-9def-0123456789ab",
  name: "stable",
  labels: #{ tier: "production" },
  spec: #{
    is_default: true,
    enabled_regex: "^4\\.\\d+\\.\\d+$",
  },
  generation: 2,
  created_time: "2021-01-01T00:00:00Z",
  updated_time: "2021-01-01T10:02:00Z",
  deleted_time: "2021-01-01T10:05:00Z",
  created_by: "user-123@example.com",
  updated_by: "user-123@example.com",
  deleted_by: "user-123@example.com",
};
