model ChannelSpec {
  /** Whether this is the default channel */
  is_default: boolean;

  /** Regex pattern for matching enabled versions */
  enabled_regex: string;
}
