# NixOS Configuration
Declarative and reproducible infrastructure.Made possible with:
NixOS, SOPS, K3s, Helm, NetBird

**Work in Progress**

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
| [Traefik](https://traefik.io) | Ingress | Active |
| [MetalLB](https://metallb.io) | Load balancer | Active |
| [Cert-Manager](https://cert-manager.io) | SSL certs with Lets Encrypt | Active |
| [CloudNativePG](https://cloudnative-pg.io) | PostgreSQL Kubernetes operator | Active |
| [Forgejo](https://forgejo.org) | Git | Active |
| [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) | GitOps | Inactive |
| [Authentik](https://goauthentik.io) | Authentication | WIP |
| `Grafana` | Metrics | Inactive |
| `Vaultwarden` | Password manager | Inactive |
| `Karakeep` | Bookmark manager | Inactive |
| `Jellyfin` | Media steaming | Inactive |
| `Seerr` | Media requests | Inactive |
