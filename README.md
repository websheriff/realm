# NixOS Configuration
Declarative and reproducible infrastructure.Made possible with:
NixOS, SOPS, K3s, Helm, NetBird

## Directory Layout

## Hosts

Hostnames follow Pokemon naming convention. See "Hostnames" for structure.

| Host | Hardware| Description |
|------|---------|-------------|
| `sevii01` | Lenovo Thinkcentre Tiny x920 | K3s cluser server |
| `kanto` | HP Z440 | General Purpose. LLM and game servers |
| `charizard` | AMD 5800x, RX 9070XT | Gaming desktop |

### K3s

Services are deployed mainly in Nix with `autoDeployCharts` and some kubernetes manifests.

| Services | Role | Status |
|----------|------|--------|
| `Traefik` | Ingress | Active |
| `MetalLB` | Load balancer | Active |
| `Cert-Manager` | SSL certs with Lets Encrypt | Active |
| `Forgejo` | Git | Active |
| `ArgoCD` | GitOps | Inactive |
| `Authentik` | Authentication | Inactive |
| `Grafana` | Metrics | Inactive |
| `Vaultwarden` | Password manager | Inactive |
| `Karakeep` | Bookmark manager | Inactive |
| `Jellyfin` | Media steaming | Inactive |
| `Seerr` | Media requests | Inactive |
