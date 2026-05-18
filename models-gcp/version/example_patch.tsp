import "../../aliases-gcp.tsp";
import "../../models/versions/model.tsp";

const exampleVersionPatchRequest: VersionPatchRequest = #{
  spec: #{
    raw_version: "4.17.12",
    enabled: false,
    default: false,
    release_image: "quay.io/openshift-release-dev/ocp-release:4.17.12-multi",
  },
  labels: #{ deprecated: "true" },
};
