import "@typespec/http";
using Http;

alias Identifier = string;

alias KindCluster = "Cluster";
alias KindClusterStatus = "ClusterStatus";
alias KindNodePoolStatus = "NodePoolStatus";
alias KindNodePool = "NodePool";


model ID {
    /** Resource identifier */
    id: Identifier;
}
model APIResourceReference<Kind> {
    ...ID;

    /** Resource kind */
    kind: Kind;

    /** Resource URI */
    href: string;

    @format("date-time") created_at: string;
    @format("date-time") updated_at: string;
}

model Error<Kind> {
    ...APIResourceReference<Kind>;

}
model APIResource<Kind> {
    ...APIResourceReference<Kind>;

    /** labels for the API resource as pairs of name:value strings */
    labels: Record<string>;
}

model Page<Kind> {
    page: int32;
    size: int32;
    total: int32;
    items: Kind[];
}

model QueryParams {
    @query
    search?: string;

    @query
    page?: int32 = 1;

    @query
    pageSize?: int32 = 20;

    @query
    orderBy?: string = "created_at";
}
