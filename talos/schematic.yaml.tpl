---
{{ if eq .Node.Data.type "rpi" }}
overlay:
  image: siderolabs/sbc-raspberrypi
  name: rpi_generic
{{ else if eq .Node.Data.type "rock" }}
overlay:
  image: siderolabs/sbc-rockchip
  name: rock5b
{{ end }}
customization:
  extraKernelArgs:
    - -init_on_alloc # Less security, faster puter
    - -init_on_free # Less security, faster puter
    - -selinux # Less security, faster puter
    - apparmor=0 # Less security, faster puter
    - i915.enable_guc=3 # Meteor Lake CPU & Intel iGPU
    - init_on_alloc=0 # Less security, faster puter
    - init_on_free=0 # Less security, faster puter
    - intel_iommu=on # PCI Passthrough
    - iommu=pt # PCI Passthrough
    - mitigations=off # Less security, faster puter
    - security=none # Less security, faster puter
    - sysctl.kernel.kexec_load_disabled=1 # Meteor Lake CPU & Intel iGPU
    - talos.auditd.disabled=1 # Less security, faster puter
    - cpufreq.default_governor=performance # Default is powersave
    - iommu.passthrough=1 # Less security, faster puter
    {{ if or (eq .Node.Host "53-hygiea") (eq .Node.Host "54-eris") }}
    - pci=nommconf # Apparently required: https://unix.stackexchange.com/questions/327730/what-causes-this-pcieport-00000003-0-pcie-bus-error-aer-bad-tlp#369090
    {{ end }}
  systemExtensions:
    officialExtensions:
      - siderolabs/i915
      - siderolabs/intel-ucode
      - siderolabs/nfsd
      - siderolabs/nfsrahead
      - siderolabs/util-linux-tools
      - siderolabs/nvme-cli
      - siderolabs/iscsi-tools
      - siderolabs/realtek-firmware
