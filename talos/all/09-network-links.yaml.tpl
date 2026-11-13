# Node networking as Talos 1.13+ typed network documents. The MAC-matched
#  link is enslaved to a single-link active-backup bond so every consumer
#  (Cilium devices, VLANs, the VIP, metrics) sees a stable interface name,
#  bond0, regardless of kernel NIC naming; a second NIC can join the bond
#  later without renaming anything. The bond name is also referenced by
#  `devices` in the cilium HelmRelease.
---
apiVersion: v1alpha1
kind: LinkAliasConfig
name: ethSel0
selector:
  match: glob("{{ .Node.Data.macAddr }}", mac(link.hardware_addr))
---
apiVersion: v1alpha1
kind: LinkConfig
name: ethSel0
mtu: {{ .Node.Data.mtu }}
addresses:
  - address: "{{ .Node.IP }}/24"
routes:
  - gateway: "10.20.20.1"
---
apiVersion: v1alpha1
kind: VLANConfig
name: ethSel0.50
vlanID: 50
parent: ethSel0
addresses:
  - address: "{{ .Node.Data.vlanIP }}/24"
routes:
  - destination: 10.20.50.0/24
    gateway: 10.20.50.1
{{ if eq .Node.Role "control-plane" }}
---
apiVersion: v1alpha1
kind: Layer2VIPConfig
link: ethSel0
name: "10.20.20.100"
{{ end }}
