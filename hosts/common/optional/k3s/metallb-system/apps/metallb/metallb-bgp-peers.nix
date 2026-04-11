{ config, ... }: {

  sops.templates."metallb/bpg-peers.yaml" = {
    content = ''
      apiVersion: metallb.io/v1beta1
      kind: BGPPeer
      metadata:
        name: internal-route
        namespace: metallb-system
      spec:
        myASN: ${config.sops.placeholder."metallb/asn"}
        peerASN: ${config.sops.placeholder."opnsense/asn"}
        peerAddress: ${config.sops.placeholder."opnsense/ip"}
        sourceAddress: ${config.sops.placeholder."hosts/sevii01/ip"}
    '';

    path = "/var/lib/rancher/k3s/server/manifests/metallb-bpg-peers.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
