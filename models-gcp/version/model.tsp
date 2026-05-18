import "@typespec/http";

using Http;

model VersionSpec {
  /** Raw version string (e.g., "4.17.12") */
  raw_version: string;

  /** Whether this version is enabled for provisioning */
  enabled: boolean;

  /** Whether this is the default version for its channel */
  default: boolean;

  /** Container image reference for the release */
  release_image: string;

  /** When this version reaches end of life */
  @format("date-time") end_of_life_time?: string;
}
