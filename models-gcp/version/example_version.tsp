import "../../aliases-gcp.tsp";
import "../../models/versions/model.tsp";
import "../../models/common/model.tsp";

const exampleVersion: Version = #{
  kind: "Version",
  id: "019466a3-5678-7abc-9def-0123456789ab",
  href: "https://api.hyperfleet.com/v1/channels/019466a2-1234-7abc-9def-0123456789ab/versions/019466a3-5678-7abc-9def-0123456789ab",
  name: "4.17.12",
  labels: #{},
  spec: #{
    raw_version: "4.17.12",
    enabled: true,
    default: true,
    release_image: "quay.io/openshift-release-dev/ocp-release:4.17.12-multi",
  },
  generation: 1,
  owner_references: #{
    id: "019466a2-1234-7abc-9def-0123456789ab",
    kind: "Channel",
    href: "https://api.hyperfleet.com/v1/channels/019466a2-1234-7abc-9def-0123456789ab",
  },
  created_time: "2021-01-01T00:00:00Z",
  updated_time: "2021-01-01T10:02:00Z",
  created_by: "user-123@example.com",
  updated_by: "user-123@example.com",
};

const exampleDeletedVersion: Version = #{
  kind: "Version",
  id: "019466a3-5678-7abc-9def-0123456789ab",
  href: "https://api.hyperfleet.com/v1/channels/019466a2-1234-7abc-9def-0123456789ab/versions/019466a3-5678-7abc-9def-0123456789ab",
  name: "4.17.12",
  labels: #{},
  spec: #{
    raw_version: "4.17.12",
    enabled: true,
    default: true,
    release_image: "quay.io/openshift-release-dev/ocp-release:4.17.12-multi",
  },
  generation: 2,
  owner_references: #{
    id: "019466a2-1234-7abc-9def-0123456789ab",
    kind: "Channel",
    href: "https://api.hyperfleet.com/v1/channels/019466a2-1234-7abc-9def-0123456789ab",
  },
  created_time: "2021-01-01T00:00:00Z",
  updated_time: "2021-01-01T10:02:00Z",
  deleted_time: "2021-01-01T10:05:00Z",
  created_by: "user-123@example.com",
  updated_by: "user-123@example.com",
  deleted_by: "user-123@example.com",
};
