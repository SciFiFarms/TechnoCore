vault_i() {
    docker exec $containerId vault "$@"
}