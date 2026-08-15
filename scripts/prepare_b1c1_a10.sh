#!/usr/bin/env bash
# Normalize the existing B1C1 defconfig toward the Google Android 10
# Pixel 3-era 4.9 baseline without replacing any B1C1 hardware settings.
#
# LTO is intentionally left disabled for the first successful CI baseline.
# The current kernel_build_action toolchain invokes ld.gold and this tree's
# LTO path requires LLVMgold.so to be wired into that linker. LTO will be
# re-enabled only after the non-LTO B1C1 kernel builds cleanly.
set -euo pipefail

CONFIG="arch/arm64/configs/b1c1_defconfig"
test -f "$CONFIG"

grep -q '^CONFIG_BOARD_B1C1=y$' "$CONFIG"

# Keep CFI/SCS and explicitly disable LTO for the build-validation baseline.
sed -i \
  -e 's/^CONFIG_LTO_CLANG=y$/# CONFIG_LTO_CLANG is not set/' \
  -e 's/^CONFIG_LTO_CLANG_THIN=y$/# CONFIG_LTO_CLANG_THIN is not set/' \
  "$CONFIG"

grep -q '^CONFIG_CFI_CLANG=y$' "$CONFIG"
grep -q '^# CONFIG_LTO_CLANG is not set$' "$CONFIG"
grep -q '^CONFIG_SHADOW_CALL_STACK=y$' "$CONFIG"

grep -q '^CONFIG_BUILD_ARM64_DT_OVERLAY=y$' "$CONFIG"
grep -q '^CONFIG_BPF_JIT=y$' "$CONFIG"

echo 'Prepared B1C1 Android 10 build-validation defconfig:'
grep -E '^(CONFIG_(BOARD_B1C1|CFI_CLANG|SHADOW_CALL_STACK|BUILD_ARM64_DT_OVERLAY|BPF_JIT)=|# CONFIG_LTO_CLANG is not set$)' "$CONFIG"
