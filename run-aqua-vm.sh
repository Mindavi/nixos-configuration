#!/usr/bin/env bash

set -euxo pipefail

# Note: make sure firewall is setup properly.

vm=$(nix build .\#nixosConfigurations.aqua.config.system.build.vm --json --no-link | jq -r .[0].outputs.out )
echo using vm path $vm
QEMU_NET_OPTS="hostfwd=tcp::8123-:8123,hostfwd=tcp::8000-:8000,hostfwd=tcp::3001-:3001" "$vm/bin/run-aqua-vm"

