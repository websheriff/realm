{ ... }: {

  sops.templates."metallb/bgp-advertisements.yaml" = {
    content = ''
      apiVersion: metallb.io/v1beta1
      kind: BGPAdvertisement
      metadata:
        name: internal-advertisement
        namespace: metallb-system
      spec:
        ipAddressPools:
        - internal-pool
      ---
      apiVersion: metallb.io/v1beta1
      kind: BGPAdvertisement
      metadata:
        name: external-advertisement
        namespace: metallb-system
      spec:
        ipAddressPools:
        - external-pool
    '';

    path = "/var/lib/rancher/k3s/server/manifests/metallb-bgp-advertisements.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
