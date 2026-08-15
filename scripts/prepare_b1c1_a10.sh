#!/usr/bin/env bash
# Normalize the existing B1C1 defconfig toward the Google Android 10
# Pixel 3-era 4.9 baseline without replacing any B1C1 hardware settings.
set -euo pipefail

CONFIG="arch/arm64/configs/b1c1_defconfig"
test -f "$CONFIG"

grep -q '^CONFIG_BOARD_B1C1=y$' "$CONFIG"

# Google enabled LTO+CFI on the B1C1 4.9 kernel. Keep CFI and enable LTO.
sed -i \
  -e 's/^# CONFIG_LTO_CLANG is not set$/CONFIG_LTO_CLANG=y/' \
  "$CONFIG"

# Shadow Call Stack is present in the Google B1C1 4.9 lineage and is kept.
grep -q '^CONFIG_CFI_CLANG=y$' "$CONFIG"
grep -q '^CONFIG_LTO_CLANG=y$' "$CONFIG"
grep -q '^CONFIG_SHADOW_CALL_STACK=y$' "$CONFIG"

# These are important B1C1/A10-era kernel settings already present in the tree.
grep -q '^CONFIG_BUILD_ARM64_DT_OVERLAY=y$' "$CONFIG"
grep -q '^CONFIG_BPF_JIT=y$' "$CONFIG"

echo 'Prepared B1C1 Android 10-compatible defconfig:'
grep -E '^(CONFIG_(BOARD_B1C1|LTO_CLANG|CFI_CLANG|SHADOW_CALL_STACK|BUILD_ARM64_DT_OVERLAY|BPF_JIT)=)' "$CONFIG"
