# Kernel patches: purpose and behavior

Patch guide for shim-review #589. This guide covers all 144 patch files in
`linux-patches.tar.gz`; paths are relative to its `linux-patches/` directory.
It is a navigation aid, not a security assessment or a restriction of review
scope. No patch is excluded from review by its purpose or source.

## Context and upstream position

IGEL carries patches for customer hardware support and product behavior;
HP support is also driven by the HP partnership. IGEL has not yet assessed or
decided which IGEL-authored fixes, if any, to submit upstream. Candidates would
require review and possible rework. External work must retain its attribution.

The descriptions below were prepared from all 144 full archived diffs,
including removed lines and context. Each entry explains the code change,
its compile-time and runtime scope, and the stated reason or specific limits
of what the archive shows. These are code-reading descriptions, not tested
hardware results or confirmation of the submitted kernel's configuration.

Source labels and references are retained from the patch preambles. They are
declared provenance, not independently checked upstream merge status or proof
of authorship. An IGEL folder or config name alone does not establish authorship.
Inline attribution is noted where it adds information or conflicts with a
preamble.

Several files repeat hunks covering multiple independently guarded options.
Some also open conditional blocks without showing their closing additions.
These observations concern the complete archived members, not a verified
failure of the final combined source tree: preparation, application order,
companion files and the actual build configuration have not been inspected.
Likewise, a missing consumer in one member does not prove it is absent from
the final kernel. The guide calls out these dependencies rather than assuming
that a patch filename describes its full effect.

Read related entries together. For example, the
[`USE_VERSION_SIGNATURE` build rule](#patch-107) and
[`VERSION_SIGNATURE` implementation](#patch-122) are complementary.
The [i915 platform-identification entry](#patch-026) supplies context for
the [H830C connector-order change](#patch-070); the
[Radeon platform-identification entry](#patch-085) similarly supports
the M340C and Samsung connector entries. A per-entry statement that a
definition or caller is not shown refers to that archive member unless
explicitly stated otherwise.

Observations about conditional boundaries, missing definitions, or apparent
implementation problems describe the individual archived diffs. They are not
confirmed defects in the combined kernel source or a tested build.

## Patch index

| # | Archive path |
|---|---|
| 1 | [`AMD/CONFIG_IGEL_AMD_WORKAROUND_XHCI_S3_ISSUES.diff`](#patch-001) |
| 2 | [`AMD/CONFIG_IGEL_FAKE_DUAL_CHANNEL_ON_AMD_STONEY.diff`](#patch-002) |
| 3 | [`Debian/CONFIG_IGEL_DISABLE_AUTOLOADING_OF_NON_SECURE_NET_MODULES.diff`](#patch-003) |
| 4 | [`Debian/CONFIG_IGEL_DISABLE_SND_PCSP_AUTOLOAD.diff`](#patch-004) |
| 5 | [`Debian/CONFIG_IGEL_MORE_VERBOSE_FIRMWARE_LOADING.diff`](#patch-005) |
| 6 | [`Debian/CONFIG_IGEL_SYSCTL_PROTECT_SYMLINKS_AND_HARDLINKS.diff`](#patch-006) |
| 7 | [`External/CONFIG_IGEL_ADD_SUPPORT_FOR_MEDIATEK_MT7902.diff`](#patch-007) |
| 8 | [`External/CONFIG_IGEL_ADD_SUPPORT_FOR_MEDIATEK_MT7927.diff`](#patch-008) |
| 9 | [`External/CONFIG_IGEL_ADD_SUPPORT_FOR_MT6639.diff`](#patch-009) |
| 10 | [`External/CONFIG_IGEL_APPLE_ACPI.diff`](#patch-010) |
| 11 | [`External/CONFIG_IGEL_APPLE_GMUX.diff`](#patch-011) |
| 12 | [`External/CONFIG_IGEL_APPLE_HID_CHANGES.diff`](#patch-012) |
| 13 | [`External/CONFIG_IGEL_APPLE_TRACKPAD.diff`](#patch-013) |
| 14 | [`External/CONFIG_IGEL_MEDIATEK_MT7925_WIFI_DRIVER_FIX.diff`](#patch-014) |
| 15 | [`External/CONFIG_IGEL_USE_PATCHED_APPLESMC.diff`](#patch-015) |
| 16 | [`IGEL-downgraded/CONFIG_IGEL_HP_T640_EMMC_FIX.diff`](#patch-016) |
| 17 | [`IGEL-downgraded/CONFIG_IGEL_MMC_QUIRK_FOR_SAMSUNG_TC2.diff`](#patch-017) |
| 18 | [`IGEL-downgraded/CONFIG_IGEL_NO_SIMPLEFB_PREVENT_VM_SEGFAULT.diff`](#patch-018) |
| 19 | [`IGEL-downgraded/CONFIG_IGEL_XHCI_THINKCENTRE_M73_REBOOT_QUIRK.diff`](#patch-019) |
| 20 | [`IGEL-lore.kernel/CONFIG_IGEL_NFS_QNAP_WORKAROUND.diff`](#patch-020) |
| 21 | [`IGEL/CONFIG_IGEL_3DCONNEXION_BATTERY_QUIRK.diff`](#patch-021) |
| 22 | [`IGEL/CONFIG_IGEL_4_SCREENS_BEST_MODE_ISSUE.diff`](#patch-022) |
| 23 | [`IGEL/CONFIG_IGEL_ACPI_EC_LG_FIX.diff`](#patch-023) |
| 24 | [`IGEL/CONFIG_IGEL_ADD_GENERIC_USB_DEVICE_IDS.diff`](#patch-024) |
| 25 | [`IGEL/CONFIG_IGEL_ADD_HW_RFKILL_TO_IDEAPAD.diff`](#patch-025) |
| 26 | [`IGEL/CONFIG_IGEL_ADD_I915_HW_DETECTION.diff`](#patch-026) |
| 27 | [`IGEL/CONFIG_IGEL_ADD_KABA_B_Net_9107_RFID_READER.diff`](#patch-027) |
| 28 | [`IGEL/CONFIG_IGEL_ALLOW_ENERGY_POLICY.diff`](#patch-028) |
| 29 | [`IGEL/CONFIG_IGEL_ALLOW_HP_LNXBCU_IOPL.diff`](#patch-029) |
| 30 | [`IGEL/CONFIG_IGEL_ALLOW_RYZENADJ.diff`](#patch-030) |
| 31 | [`IGEL/CONFIG_IGEL_AMDGPU_ADD_DISABLE_MST_SUPPORT_MOD_OPTION.diff`](#patch-031) |
| 32 | [`IGEL/CONFIG_IGEL_AMDGPU_ADD_PREFER_VRAM_MOD_OPTION.diff`](#patch-032) |
| 33 | [`IGEL/CONFIG_IGEL_AMDGPU_ADD_USE_FBC_MOD_OPTION.diff`](#patch-033) |
| 34 | [`IGEL/CONFIG_IGEL_AMDGPU_CALL_DP_CEC_FUNCS_ONLY_FOR_DP.diff`](#patch-034) |
| 35 | [`IGEL/CONFIG_IGEL_AMDGPU_CHANGE_DEFAULT_NORETRY_OPTION.diff`](#patch-035) |
| 36 | [`IGEL/CONFIG_IGEL_AMDGPU_FIX_EDP_NOT_WAKING_UP_AFTER_SUSPEND.diff`](#patch-036) |
| 37 | [`IGEL/CONFIG_IGEL_AMD_USB2_CHERRY_KEYBOARD_WORKAROUND.diff`](#patch-037) |
| 38 | [`IGEL/CONFIG_IGEL_BCMA_PREFER_BROADCOM_STA.diff`](#patch-038) |
| 39 | [`IGEL/CONFIG_IGEL_CHANGE_OSS_DEVICE_NAMES.diff`](#patch-039) |
| 40 | [`IGEL/CONFIG_IGEL_CLIENTRON_SD_CARD_QUIRK.diff`](#patch-040) |
| 41 | [`IGEL/CONFIG_IGEL_DISABLE_RTL8XXXU_USB_IDS_HANDLED_BY_8192EU.diff`](#patch-041) |
| 42 | [`IGEL/CONFIG_IGEL_DISBALE_EFI_COMPLETE_WITH_NOEFI_PARAM.diff`](#patch-042) |
| 43 | [`IGEL/CONFIG_IGEL_DO_NOT_LIMIT_MAX_MODE_SIZE_TO_CURRENT_FB.diff`](#patch-043) |
| 44 | [`IGEL/CONFIG_IGEL_DO_NOT_WRITE_EFI_PCR9_REGISTER.diff`](#patch-044) |
| 45 | [`IGEL/CONFIG_IGEL_DRM_I915_SAVE_RESTORE_SDVO.diff`](#patch-045) |
| 46 | [`IGEL/CONFIG_IGEL_E1000E_OPTIPLEX_WORKAROUND.diff`](#patch-046) |
| 47 | [`IGEL/CONFIG_IGEL_EDID_DETECTION_SECOND_TRY_QUIRK.diff`](#patch-047) |
| 48 | [`IGEL/CONFIG_IGEL_FIX_DELL_HARDWARE_BUTTONS.diff`](#patch-048) |
| 49 | [`IGEL/CONFIG_IGEL_FIX_MT183_WIFI_ISSUE.diff`](#patch-049) |
| 50 | [`IGEL/CONFIG_IGEL_FIX_OLD_BIOS_CPU_STEPPING.diff`](#patch-050) |
| 51 | [`IGEL/CONFIG_IGEL_FIX_R8169_WOL.diff`](#patch-051) |
| 52 | [`IGEL/CONFIG_IGEL_FIX_RADEON_3_SCREENS_BEST_MODE_ISSUE.diff`](#patch-052) |
| 53 | [`IGEL/CONFIG_IGEL_FIX_WWAN_RFKILL_FOR_THINKPAD_L480.diff`](#patch-053) |
| 54 | [`IGEL/CONFIG_IGEL_FUJITSU_DVI_VGA_SPLIT_QUIRKS.diff`](#patch-054) |
| 55 | [`IGEL/CONFIG_IGEL_GENERATE_UUID_FOR_SQUASHFS.diff`](#patch-055) |
| 56 | [`IGEL/CONFIG_IGEL_HP_RFKILL_MT645_G7_FIX.diff`](#patch-056) |
| 57 | [`IGEL/CONFIG_IGEL_HP_T240_SOUND_FIXES.diff`](#patch-057) |
| 58 | [`IGEL/CONFIG_IGEL_HP_T640_SOUND_FIXES.diff`](#patch-058) |
| 59 | [`IGEL/CONFIG_IGEL_I915_ADD_DISABLE_DP_AUDIO_OPTION.diff`](#patch-059) |
| 60 | [`IGEL/CONFIG_IGEL_I915_ADD_DISABLE_HDMI_AUDIO_OPTION.diff`](#patch-060) |
| 61 | [`IGEL/CONFIG_IGEL_I915_ADD_LIMIT_DP_RATE_OPTION.diff`](#patch-061) |
| 62 | [`IGEL/CONFIG_IGEL_I915_ADD_M250C_NO_LIMITED_COLOR_RANGE_OPTION.diff`](#patch-062) |
| 63 | [`IGEL/CONFIG_IGEL_I915_ADD_OPTION_TO_CHANGE_CONNECTOR_ENUM_ORDER.diff`](#patch-063) |
| 64 | [`IGEL/CONFIG_IGEL_I915_CHANGE_DEFAULT_POWER_WELL_OPTION.diff`](#patch-064) |
| 65 | [`IGEL/CONFIG_IGEL_I915_DISABLE_LVDS_MODULE_OPTION.diff`](#patch-065) |
| 66 | [`IGEL/CONFIG_IGEL_I915_DISABLE_TV_MODULE_OPTION.diff`](#patch-066) |
| 67 | [`IGEL/CONFIG_IGEL_I915_DP_DETECT_WORKAROUND.diff`](#patch-067) |
| 68 | [`IGEL/CONFIG_IGEL_I915_DP_RETRY_LINK_TRAINING.diff`](#patch-068) |
| 69 | [`IGEL/CONFIG_IGEL_I915_EDP_IS_DP_MODULE_OPTION.diff`](#patch-069) |
| 70 | [`IGEL/CONFIG_IGEL_I915_H830_CHANGE_CONNECTOR_ORDER.diff`](#patch-070) |
| 71 | [`IGEL/CONFIG_IGEL_I915_WYSE_3040_DP_QUIRK.diff`](#patch-071) |
| 72 | [`IGEL/CONFIG_IGEL_KEYCODES.diff`](#patch-072) |
| 73 | [`IGEL/CONFIG_IGEL_KYOCERA_USB_SET_INTF_QUIRK.diff`](#patch-073) |
| 74 | [`IGEL/CONFIG_IGEL_LENOVO_M600_SOUND_FIXES.diff`](#patch-074) |
| 75 | [`IGEL/CONFIG_IGEL_LG_AIO_MIC_FIXES.diff`](#patch-075) |
| 76 | [`IGEL/CONFIG_IGEL_LG_LIMIT_VOLUME.diff`](#patch-076) |
| 77 | [`IGEL/CONFIG_IGEL_LIMIT_BAYTRAIL_C_STATES.diff`](#patch-077) |
| 78 | [`IGEL/CONFIG_IGEL_LVDS_CONNECTED_ON_TC215.diff`](#patch-078) |
| 79 | [`IGEL/CONFIG_IGEL_M340C_DVI_VGA_SPLIT_QUIRKS.diff`](#patch-079) |
| 80 | [`IGEL/CONFIG_IGEL_MARK_MMC_SD_CARD_REMOVEABLE.diff`](#patch-080) |
| 81 | [`IGEL/CONFIG_IGEL_MICROTOUCH_USB_RESUME_QUIRK.diff`](#patch-081) |
| 82 | [`IGEL/CONFIG_IGEL_NO_TIMESTAMP_WARNING.diff`](#patch-082) |
| 83 | [`IGEL/CONFIG_IGEL_OWN_DEVICE_SOUND_FIXES.diff`](#patch-083) |
| 84 | [`IGEL/CONFIG_IGEL_PCIEAER_DISABLE.diff`](#patch-084) |
| 85 | [`IGEL/CONFIG_IGEL_RADEON_DETECTION.diff`](#patch-085) |
| 86 | [`IGEL/CONFIG_IGEL_RADEON_DP_DVI_ADAPTER_PROBE_WORKAROUND.diff`](#patch-086) |
| 87 | [`IGEL/CONFIG_IGEL_RADEON_FIX_CONNECTOR_STATUS.diff`](#patch-087) |
| 88 | [`IGEL/CONFIG_IGEL_RADEON_FIX_CURSOR_DISAPPEAR.diff`](#patch-088) |
| 89 | [`IGEL/CONFIG_IGEL_RADEON_LVDS_SWITCH.diff`](#patch-089) |
| 90 | [`IGEL/CONFIG_IGEL_RADEON_SINK_POWER_ON_QUIRK.diff`](#patch-090) |
| 91 | [`IGEL/CONFIG_IGEL_RADEON_SPLIT_DVII.diff`](#patch-091) |
| 92 | [`IGEL/CONFIG_IGEL_RALINK_ONE_ANTENNA_QUIRK.diff`](#patch-092) |
| 93 | [`IGEL/CONFIG_IGEL_REPLACE_UNKNOWN_BATTERY_STATE_WITH_NOT_CHARGING.diff`](#patch-093) |
| 94 | [`IGEL/CONFIG_IGEL_SAMSUNG_TC2_DVI_VGA_QUIRK.diff`](#patch-094) |
| 95 | [`IGEL/CONFIG_IGEL_SPLASH_FIX.diff`](#patch-095) |
| 96 | [`IGEL/CONFIG_IGEL_SSB_B43_PCI_PREFER_BROADCOM_STA.diff`](#patch-096) |
| 97 | [`IGEL/CONFIG_IGEL_TC236_TOUCH_QUIRK.diff`](#patch-097) |
| 98 | [`IGEL/CONFIG_IGEL_THINKPAD_RFKILL_MODULE_PARAM.diff`](#patch-098) |
| 99 | [`IGEL/CONFIG_IGEL_TI_TUSB73X0_XHCI_QUIRK.diff`](#patch-099) |
| 100 | [`IGEL/CONFIG_IGEL_TOUCHSCREEN_EGALAX_REPT2.diff`](#patch-100) |
| 101 | [`IGEL/CONFIG_IGEL_UNGPL_VMA_START_WRITE.diff`](#patch-101) |
| 102 | [`IGEL/CONFIG_IGEL_USB_DISABLE_DISCONNECT.diff`](#patch-102) |
| 103 | [`IGEL/CONFIG_IGEL_USB_SERIAL_SUPPORT_HP_LDM350_DEVICES.diff`](#patch-103) |
| 104 | [`IGEL/CONFIG_IGEL_USB_SOUND_PLANTRONICS_QUIRKS.diff`](#patch-104) |
| 105 | [`IGEL/CONFIG_IGEL_USB_SOUND_SENNHEISER_QUIRKS.diff`](#patch-105) |
| 106 | [`IGEL/CONFIG_IGEL_USE_BEST_MODE_FRAMEBUFFER.diff`](#patch-106) |
| 107 | [`IGEL/CONFIG_IGEL_USE_VERSION_SIGNATURE.diff`](#patch-107) |
| 108 | [`IGEL/CONFIG_IGEL_VERIFY_SIGNATURE_AGAINST_KEYRING.diff`](#patch-108) |
| 109 | [`IGEL/CONFIG_IGEL_VGA_USE_DVI_MODES_IF_MODES_MISSING_QUIRK.diff`](#patch-109) |
| 110 | [`IGEL/CONFIG_IGEL_VMWGFX_FIX.diff`](#patch-110) |
| 111 | [`IGEL/CONFIG_IGEL_WACOM_BAMBOO_QUIRK.diff`](#patch-111) |
| 112 | [`IGEL/CONFIG_IGEL_WOL_FIX_8139TOO.diff`](#patch-112) |
| 113 | [`Ubuntu/CONFIG_IGEL_ALLOW_ASPM_FOR_VMD.diff`](#patch-113) |
| 114 | [`Ubuntu/CONFIG_IGEL_ALLOW_R8169_ASPM_FOR_DELL.diff`](#patch-114) |
| 115 | [`Ubuntu/CONFIG_IGEL_I915_DP_BYTE_BY_BYTE_FALLBACK.diff`](#patch-115) |
| 116 | [`Ubuntu/CONFIG_IGEL_I915_TC_DP_ALT_FALSE_DISCONNECT.diff`](#patch-116) |
| 117 | [`Ubuntu/CONFIG_IGEL_LENOVO_THINKCENTRE_MUTE_LED.diff`](#patch-117) |
| 118 | [`Ubuntu/CONFIG_IGEL_MT792X_FIX_DEADLOCK_IN_HIGH_LOAD.diff`](#patch-118) |
| 119 | [`Ubuntu/CONFIG_IGEL_RTL8116AF_SERDES_QUIRK.diff`](#patch-119) |
| 120 | [`Ubuntu/CONFIG_IGEL_THUNDERBOLT_PCIE_DELAYED_RESCAN.diff`](#patch-120) |
| 121 | [`Ubuntu/CONFIG_IGEL_USB_HUB_ACPI_PRR_RESET.diff`](#patch-121) |
| 122 | [`Ubuntu/CONFIG_IGEL_VERSION_SIGNATURE.diff`](#patch-122) |
| 123 | [`linux-surface/CONFIG_IGEL_HID_SURFACE.diff`](#patch-123) |
| 124 | [`linux-surface/CONFIG_IGEL_RTC_DRV_SURFACE.diff`](#patch-124) |
| 125 | [`linux-surface/CONFIG_IGEL_SURFACE_ACPI_CHANGES.diff`](#patch-125) |
| 126 | [`linux-surface/CONFIG_IGEL_SURFACE_BOOK1_DGPU_SWITCH.diff`](#patch-126) |
| 127 | [`linux-surface/CONFIG_IGEL_SURFACE_BUTTON_CHANGES.diff`](#patch-127) |
| 128 | [`linux-surface/CONFIG_IGEL_SURFACE_CAMERA_LEDS_TPS68470.diff`](#patch-128) |
| 129 | [`linux-surface/CONFIG_IGEL_SURFACE_COVER_QUIRK.diff`](#patch-129) |
| 130 | [`linux-surface/CONFIG_IGEL_SURFACE_EFI_RESET_SHUTDOWN_FIX.diff`](#patch-130) |
| 131 | [`linux-surface/CONFIG_IGEL_SURFACE_HID.diff`](#patch-131) |
| 132 | [`linux-surface/CONFIG_IGEL_SURFACE_HID_IPTS.diff`](#patch-132) |
| 133 | [`linux-surface/CONFIG_IGEL_SURFACE_HID_ITHC_DISABLE_IRQ.diff`](#patch-133) |
| 134 | [`linux-surface/CONFIG_IGEL_SURFACE_IMPROVE_CAMERA_SUPPORT.diff`](#patch-134) |
| 135 | [`linux-surface/CONFIG_IGEL_SURFACE_IPTS_MEI_CHANGES.diff`](#patch-135) |
| 136 | [`linux-surface/CONFIG_IGEL_SURFACE_IRQ7_QUIRK.diff`](#patch-136) |
| 137 | [`linux-surface/CONFIG_IGEL_SURFACE_SECUREBOOT.diff`](#patch-137) |
| 138 | [`linux-surface/CONFIG_IGEL_SURFACE_SUPPORT_GPE.diff`](#patch-138) |
| 139 | [`linux-surface/CONFIG_IGEL_SURFACE_SURFACE3_OEMB_FIX.diff`](#patch-139) |
| 140 | [`linux-surface/CONFIG_IGEL_SURFACE_USB_QUIRK_DELAY_INIT.diff`](#patch-140) |
| 141 | [`linux-surface/CONFIG_IGEL_SURFACE_WLAN_IMPROVEMENTS.diff`](#patch-141) |
| 142 | [`patchwork-kernel/CONFIG_IGEL_ADD_RTL8723BS_RFKILL_SWITCH_SUPPORT.diff`](#patch-142) |
| 143 | [`upstream-kernel-reverted/CONFIG_IGEL_FIX_ELO_I2_WIFI_ISSUE.diff`](#patch-143) |
| 144 | [`upstream-kernel-reverted/CONFIG_IGEL_HP_MT645_BIOS_S3.diff`](#patch-144) |

## Patch details

<a id="patch-001"></a>

### `AMD/CONFIG_IGEL_AMD_WORKAROUND_XHCI_S3_ISSUES.diff`

**Change:** `xhci_pci_quirks()` extends the combination `XHCI_DISABLE_SPARSE` and `XHCI_RESET_ON_RESUME` from AMD device `0x15e5` to `0x15e0` and `0x15e1`. It leaves the adjacent `XHCI_SNPS_BROKEN_SUSPEND` assignment unchanged.

**Scope:** `drivers/usb/host/xhci-pci.c`; guarded by `CONFIG_IGEL_AMD_WORKAROUND_XHCI_S3_ISSUES` and an AMD PCI-vendor/device check. Without the option, the original `0x15e5` branch remains. There is no machine-model filter.

**Reason / limits:** The preamble attributes failed wakeups on some AMD devices to xHCI. The diff selects existing quirk flags; it does not show their implementation or identify affected machine models.

**Declared source:** AMD; No reference supplied

<a id="patch-002"></a>

### `AMD/CONFIG_IGEL_FAKE_DUAL_CHANNEL_ON_AMD_STONEY.diff`

**Change:** In `bw_calcs_init()`, the Stoney bandwidth-calculation case sets `vbios->number_of_dram_channels` to two instead of calculating it from `asic_id.vram_width / dram_channel_width_in_bits`. The surrounding 64-bit channel-width and memory-clock assumptions remain.

**Scope:** `drivers/gpu/drm/amd/display/dc/basics/dce_calcs.c`; only `BW_CALCS_VERSION_STONEY` under `CONFIG_IGEL_FAKE_DUAL_CHANNEL_ON_AMD_STONEY`. This changes the display driver's bandwidth model, not physical RAM wiring.

**Reason / limits:** The stated purpose is to improve supported resolutions by pretending dual-channel RAM exists. Neither the achievable resolutions nor the consequences of overstating available bandwidth are established by this hunk.

**Declared source:** AMD; No reference supplied

<a id="patch-003"></a>

### `Debian/CONFIG_IGEL_DISABLE_AUTOLOADING_OF_NON_SECURE_NET_MODULES.diff`

**Change:** Removes the `MODULE_ALIAS_NETPROTO(PF_IEEE802154)` and `MODULE_ALIAS_NETPROTO(PF_RDS)` declarations from enabled builds, so those aliases no longer advertise protocol-triggered module loading. It does not remove either protocol implementation or prohibit explicit loading.

**Scope:** `net/ieee802154/socket.c` and `net/rds/af_rds.c`; aliases remain when `CONFIG_IGEL_DISABLE_AUTOLOADING_OF_NON_SECURE_NET_MODULES` is unset. Built-in protocol behavior is not changed by these module-metadata hunks.

**Reason / limits:** Comments describe mitigation against local exploits. The preamble additionally lists IPv4/IPv6 DCCP and DECnet, but this archived diff contains no changes to those protocols: its claimed coverage is broader than its code.

**Declared source:** Debian; [source 1](https://salsa.debian.org/kernel-team/linux/-/blob/debian/5.10/bullseye/debian/patches/debian/af_802154-Disable-auto-loading-as-mitigation-against.patch?ref_type=heads); [source 2](https://salsa.debian.org/kernel-team/linux/-/blob/debian/5.10/bullseye/debian/patches/debian/rds-Disable-auto-loading-as-mitigation-against-local.patch?ref_type=heads)

<a id="patch-004"></a>

### `Debian/CONFIG_IGEL_DISABLE_SND_PCSP_AUTOLOAD.diff`

**Change:** Conditionally omits `MODULE_ALIAS("platform:pcspkr")` from the PC-speaker sound driver. The driver's implementation and its existing sound-card parameters are unchanged.

**Scope:** `sound/drivers/pcsp/pcsp.c`; `CONFIG_IGEL_DISABLE_SND_PCSP_AUTOLOAD` suppresses this particular platform alias. When unset, the existing alias remains. No module blacklist or built-in-driver suppression is introduced.

**Reason / limits:** The preamble says automatic loading should stop while manual `modprobe snd-pcsp` remains possible. The observable change is specifically the absence of that alias, not a prohibition on all possible loading paths.

**Declared source:** Debian; [source 1](https://salsa.debian.org/kernel-team/linux/-/blob/debian/6.18/forky/debian/patches/debian/snd-pcsp-disable-autoload.patch?ref_type=heads)

<a id="patch-005"></a>

### `Debian/CONFIG_IGEL_MORE_VERBOSE_FIRMWARE_LOADING.diff`

**Change:** Promotes user-helper lock-wait timeout logging from debug to error, and filesystem firmware decompression/direct-loading messages from debug to informational level. After filesystem search, it adds an error naming the firmware for `-ENOENT` or another nonzero result. Conversely, individual non-`ENOENT` filesystem-attempt failures are demoted from warning to debug.

**Scope:** `drivers/base/firmware_loader/fallback.c` (`fw_load_from_user_helper()`) and `main.c` (`fw_get_filesystem_firmware()`), under `CONFIG_IGEL_MORE_VERBOSE_FIRMWARE_LOADING`. Existing search/loading logic stays intact. The new final-error messages are outside the shown `FW_OPT_NO_WARN` check.

**Reason / limits:** Intended for firmware debugging; “more verbose” is not uniformly true because per-path warnings become less visible. The decompression message announces an attempt, not successful decompression or overall firmware-request success.

**Declared source:** Debian; [source 1](https://salsa.debian.org/kernel-team/linux/-/blob/debian/5.10/bullseye/debian/patches/bugfix/all/firmware_class-log-every-success-and-failure.patch?ref_type=heads)

<a id="patch-006"></a>

### `Debian/CONFIG_IGEL_SYSCTL_PROTECT_SYMLINKS_AND_HARDLINKS.diff`

**Change:** Initializes `sysctl_protected_symlinks` and `sysctl_protected_hardlinks` to one rather than their implicit zero initialization. It changes startup defaults for the existing link restrictions, not their enforcement algorithms.

**Scope:** `fs/namei.c`; guarded by `CONFIG_IGEL_SYSCTL_PROTECT_SYMLINKS_AND_HARDLINKS`. With the option unset, both retain their original zero defaults. `sysctl_protected_fifos` and `sysctl_protected_regular` are left unchanged.

**Reason / limits:** The preamble and comment explicitly seek enabled link restrictions without a separate sysctl-setting step. Nothing in this diff makes the settings immutable or changes later userspace overrides.

**Declared source:** Debian; [source 1](https://salsa.debian.org/kernel-team/linux/-/blob/debian/5.10/bullseye/debian/patches/debian/fs-enable-link-security-restrictions-by-default.patch?ref_type=heads)

<a id="patch-007"></a>

### `External/CONFIG_IGEL_ADD_SUPPORT_FOR_MEDIATEK_MT7902.diff`

**Change:** Extends the MT7921-family driver to MT7902 PCI and SDIO ID `0x7902`, with `WIFI_RAM_CODE_MT7902_1.bin` and `WIFI_MT7902_patch_mcu_1_1_hdr.bin`. A new `is_connac2()` classification includes MT7902 and the former MT7921-family IDs, extending existing TX-descriptor, RX-rate/radiotap, station-TLV, scanning, power-limit and firmware-download handling. PCI DMA uses MCU TX ring 15, a 512-entry shared event/TX-done RX ring, no MCU-WA ring, and a copied IRQ map with `wm2_complete_mask=0`. MT7902-specific prefetch and a PSE-register read are added; default runtime/deep-sleep enablement excludes MT7902.

**Scope:** Under `drivers/net/wireless/mediatek/mt76/`: `mt76_connac.h`, `mt76_connac_mac.c`, `mt76_connac_mcu.{c,h}`, `mt7921/{init.c,mt7921.h,pci.c,pci_mac.c,sdio.c}`, `mt792x.h`, `mt792x_core.c`, `mt792x_dma.c`, `mt792x_regs.h`. Most additions use `CONFIG_IGEL_ADD_SUPPORT_FOR_MEDIATEK_MT7902`; shared hunks also contain MT7927 guards. Firmware loading restarts/polls the MCU for either this option or the MT7925-fix option; semaphore release requires the latter.

**Reason / limits:** Described as a support backport; PSE-underflow avoidance is the source comment's rationale. Shared hunks, including the optional MCU-WA allocation and both prefetch branches, also serve the MT7927 and stability options. Firmware availability and functioning PCI/SDIO hardware have not been demonstrated.

**Declared source:** External; [source 1](https://github.com/jetm/mediatek-mt7927-dkms/blob/master/mt7902-wifi-6.19.patch)

<a id="patch-008"></a>

### `External/CONFIG_IGEL_ADD_SUPPORT_FOR_MEDIATEK_MT7927.diff`

**Change:** Adds PCI IDs `0x7927`, `0x6639`, `0x0738` to the MT7925 driver, MT6639-named Wi-Fi firmware under `mediatek/mt7927/`, and MT7927 chip recognition. Probe adds CBTOP remapping, subsystem reset/MCU-idle polling, forced chip identification when reads disagree, CNM-operation restoration, and unconditional ASPM disabling for these IDs. Chip-specific DMA configuration selects RX rings 4/6/7, packed prefetch, extra management-frame reception and IRQ masks. MT7927 initialization requests DBDC; channel/BSS/ROC handling maps 2.4 GHz to band zero and 5/6 GHz to one. It adds 320-MHz EHT capabilities/rate handling, station MURU/TX-processing TLVs, power tracking, and per-link cleanup fixes.

**Scope:** `drivers/net/wireless/mediatek/mt76/mt76_connac.h`; `mt7925/{init.c,mac.c,main.c,mcu.c,mcu.h,mt7925.h,pci.c,pci_mac.c,pci_mcu.c}`; `mt792x.h`, `mt792x_dma.c`, `mt792x_regs.h`. Primarily `CONFIG_IGEL_ADD_SUPPORT_FOR_MEDIATEK_MT7927`, with overlapping MT7902/stability guards. Runtime/deep-sleep default enablement excludes MT7927; some capability/TLV changes affect the shared MT7925 path whenever the option is built.

**Reason / limits:** Comments attribute ownership/ASPM changes to shared Wi-Fi/Bluetooth power-domain and WFDMA problems; these are not independently verified hardware findings. Station-request sizing includes the new MURU/TX-processing TLVs. DBDC failure is warned but ignored. `mt7925e_mac_reset()` returns `-EOPNOTSUPP` for MT7927 and advises module reload; the reset worker retries this path and can report failure, so this path does not implement automatic MT7927 recovery. Firmware and hardware operation remain untested.

**Declared source:** External; [source 1](https://github.com/jetm/mediatek-mt7927-dkms)

<a id="patch-009"></a>

### `External/CONFIG_IGEL_ADD_SUPPORT_FOR_MT6639.diff`

**Change:** Adds Bluetooth USB quirks for `0489:e13a/e0fa/e10f/e110/e116` and `13d3:3588`, with MediaTek and wideband-speech flags. `btmtk_usb_setup()` substitutes chip ID `0x6639` only when the read ID is zero and the USB pair matches that list. Firmware naming selects `mediatek/mt7927/BT_RAM_CODE_MT6639_2_<version>_hdr.bin`. `btmtk_setup_firmware_79xx()` gains a device-ID argument and skips nonempty MT6639 sections whose download-mode low byte is not `0x01`. MT6639 uses the MT7925 CONNV3 subsystem-reset branch; a zero post-reset ID no longer triggers the failure message for MT6639.

**Scope:** `drivers/bluetooth/{btmtk.c,btmtk.h,btmtksdio.c,btusb.c}`, guarded by `CONFIG_IGEL_ADD_SUPPORT_FOR_MT6639`. The SDIO caller passes zero, leaving MT6639-specific section filtering inactive there. Interrupt-interface selection changes to alternate setting one only when multiple settings exist, otherwise zero; this adjustment is not restricted to MT6639 at runtime.

**Reason / limits:** The preamble claims Bluetooth support; comments link section filtering to Windows-driver behavior and hangs from other sections. Listed board names are comments, not model checks. The adjacent Wi-Fi patch documents shared combo-chip power-domain issues, but this Bluetooth diff does not enforce coordinated Wi-Fi configuration or supply firmware.

**Declared source:** External; [source 1](https://github.com/jetm/mediatek-mt7927-dkms)

<a id="patch-010"></a>

### `External/CONFIG_IGEL_APPLE_ACPI.diff`

**Change:** `acpi_ds_exec_end_op()` tests `walk_state->num_operands > 0` rather than the opcode's `AML_HAS_ARGS` flag before resolving operands, while retaining the `AML_NO_OPERAND_RESOLVE` exclusion.

**Scope:** `drivers/acpi/acpica/dswexec.c`; selected by `CONFIG_IGEL_APPLE_ACPI`. This is an ACPICA-wide execution-path change, with no Apple/T2 runtime identity check.

**Reason / limits:** The preamble calls this a fix for zero-argument ACPI calls. The hunk changes the resolution gate to actual operand count, but supplies no failing AML example or affected firmware list. The standalone `source "drivers/hid/amd-sfh-hid/Kconfig"` text precedes the diff and is not a Kconfig modification hunk.

**Declared source:** External; [source 1](https://github.com/t2linux/linux-t2-patches/blob/6.1/2001-fix-acpica-for-zero-arguments-acpi-calls.patch)

<a id="patch-011"></a>

### `External/CONFIG_IGEL_APPLE_GMUX.diff`

**Change:** Adds switcheroo-driven amdgpu probe deferral, an i915 four-lane DDI-A quirk for MacBookPro15,1 (`3e9b/106b/0176`), and an exported `vga_set_default_device()`. T2/MMIO gmux clears interrupts through a new `acpi_evaluate_object("GMSP", integer 0)` wrapper; the unpatched branch already invokes GMSP using a different helper. Optional `force_igd` switches to integrated graphics during `gmux_probe()` and updates the default VGA device if PCI `00:02.0` exists. Debugfs writes now return the raw nonzero `copy_from_user()` result instead of `-EFAULT`.

**Scope:** `drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c`; `drivers/gpu/drm/i915/display/{intel_ddi.c,intel_quirks.c,intel_quirks.h}`; `drivers/pci/vgaarb.c`; `drivers/platform/x86/apple-gmux.c`. Main changes use `CONFIG_IGEL_APPLE_GMUX`; `force_igd` defaults false and has mode zero. The diff also includes Wyse 3040 quirk registration under `CONFIG_IGEL_I915_WYSE_3040_DP_QUIRK && _I915_DRV_H_`.

**Reason / limits:** Comments describe incorrect firmware lane counts and advise apple-set-os for exposing the iGPU. This is not a blanket T2-support switch: amdgpu deferral/debugfs changes have broader scope, and the Wyse hunk is independent. Parameter-description/error strings misspell `force_igd` as `force_idg`; GMSP errors are logged but ignored by interrupt clearing.

**Declared source:** External; [source 1](https://github.com/t2linux/linux-t2-patches/blob/6.1/2005-apple-gmux-Use-GMSP-acpi-method-for-interrupt-clear.patch); [source 2](https://github.com/t2linux/linux-t2-patches/blob/6.1/2008-i915-4-lane-quirk-for-mbp15-1.patch); [source 3](https://github.com/t2linux/linux-t2-patches/blob/6.1/2009-apple-gmux-allow-switching-to-igpu-at-probe.patch)

<a id="patch-012"></a>

### `External/CONFIG_IGEL_APPLE_HID_CHANGES.diff`

**Change:** Defines `USB_DEVICE_ID_APPLE_IBRIDGE` as `0x8600` in the shared HID-ID header. That is the entire code change.

**Scope:** `drivers/hid/hid-ids.h`, guarded by `CONFIG_IGEL_APPLE_HID_CHANGES`. No driver registration, USB match entry, HID parsing, backlight behavior or applesmc code is changed here.

**Reason / limits:** The preamble links generic HID changes to applesmc and references three driver patches. This member only defines the iBridge ID. In the supplied tree, that ID is consumed by apple-ibridge's match table and the `CONFIG_HID_APPLE_IBRIDGE` entry in the HID special-driver list; `IGEL_USE_PATCHED_APPLESMC` explicitly depends on `IGEL_APPLE_HID_CHANGES` in Kconfig. That establishes a configuration relationship, not an independently demonstrated functional necessity, and this member does not itself add those drivers.

**Declared source:** External; [source 1](https://github.com/t2linux/linux-t2-patches/blob/6.1/1006-HID-hid-apple-magic-backlight-Add-driver-for-keyboar.patch); [source 2](https://github.com/t2linux/linux-t2-patches/blob/6.1/1007-HID-apple-ibridge-Add-Apple-iBridge-HID-driver-for-T.patch); [source 3](https://github.com/t2linux/linux-t2-patches/blob/6.1/1008-HID-apple-touchbar-Add-driver-for-the-Touch-Bar-on-M.patch)

<a id="patch-013"></a>

### `External/CONFIG_IGEL_APPLE_TRACKPAD.diff`

**Change:** Adds bcm5974 USB matching and configuration records for T2-attached trackpads: IDs `0x027a`–`0x0280` and `0x0340`, labelled MacBookAir8,1/9,1 and MacBookPro15,1/15,2/15,4/16,1/16,2/16,3. All use the existing TYPE4 data format, trackpad endpoint `0x83`, integrated-button flag, pressure range 0–300 and width 0–2048; coordinate extents differ for the larger J680 and J152F devices.

**Scope:** `drivers/input/mouse/bcm5974.c`; ID definitions, `bcm5974_table` and `bcm5974_config_table` additions are guarded by `CONFIG_IGEL_APPLE_TRACKPAD`. Binding remains through the existing `BCM5974_DEVICE` matching mechanism.

**Reason / limits:** The stated goal is T2 trackpad support. This is device-table/calibration enablement, not a new packet decoder or transport implementation; the archive does not establish whether every labelled device exposes the expected endpoint/layout.

**Declared source:** External; [source 1](https://github.com/t2linux/linux-t2-patches/blob/6.1/4001-Input-bcm5974-Add-support-for-the-T2-Macs.patch)

<a id="patch-014"></a>

### `External/CONFIG_IGEL_MEDIATEK_MT7925_WIFI_DRIVER_FIX.diff`

**Change:** Reworks MT7921/MT7925 remain-on-channel and reset locking, removes WCIDs from station-poll lists during cleanup, adds MT7921 asynchronous ROC abort, and handles an abort flag before worker locking. MT7925 ROC requests gain exponential timeout backoff (100–1600 ms; short waits below 200 ms sleep, longer waits return `-EBUSY`; successful grants or over ten seconds without timeouts reset tracking). Numerous MLO link/key/BSS/TLV paths reject or skip missing state; TX drops packets with missing link data. Station-add failures unpublish/free WCID allocation, and BSS/key/aggregation MCU errors are propagated. Firmware loading releases a prior patch semaphore, restarts the MCU and polls readiness; timeout warns but does not stop loading.

**Scope:** Under `drivers/net/wireless/mediatek/mt76/`: `mac80211.c`, `mt76.h`, `mt7921/{mac.c,main.c}`, `mt7925/{mac.c,main.c,mcu.c,pci.c}`, `mt792x.h`, `mt792x_core.c`. Primarily `CONFIG_IGEL_MEDIATEK_MT7925_WIFI_DRIVER_FIX`; shared channel-context hunks also contain MT7927 guards, and firmware restart also recognizes the MT7902 option. There is no AMD host check.

**Reason / limits:** Comments cite deadlocks, stale lists and reconnection overload; the timeout warning suggests upper-layer/MLO causes without establishing them. The full tree already implements the removal-path cancel-work change in `mt7925_roc_abort_sync()`, so the comment does not identify an absent fix here. Shared hunks are integrated with companion options. This does not establish complete MLO recovery or measured stability; firmware-readiness timeout still warns and continues loading.

**Declared source:** External; [source 1](https://github.com/zbowling/mt7925/tree/main/kernels/6.18)

<a id="patch-015"></a>

### `External/CONFIG_IGEL_USE_PATCHED_APPLESMC.diff`

**Change:** Adds a substantial alternate applesmc implementation with per-device register/cache/lock, input, backlight and resource state. It binds ACPI `APP0001`, derives I/O/MMIO addresses from `_CRS`, and selects MMIO communication after checking status and `LDKN >= 2`, falling back to I/O on failure. Read/write/key-info wrappers support both transports. Cached key discovery determines available temperature, fan, accelerometer, light and keyboard-backlight interfaces. Fan helpers support T2 `flt ` speeds and per-fan `F%dMd` manual control, falling back to `FS! `. A `battery_charge_limit` sysfs attribute reads/writes `BCLM`, accepts 0–100, and reports missing/unusable keys as `-ENODEV`. Resume restores keyboard backlight; hibernation restore reinitializes motion sensing.

**Scope:** `drivers/hwmon/Makefile` selects the existing `igel/applesmc.o` when `CONFIG_IGEL_USE_PATCHED_APPLESMC=y`, still conditioned on `CONFIG_SENSORS_APPLESMC`; Kconfig also depends on `IGEL_APPLE_HID_CHANGES`. The archived implementation hunk instead adds a guarded alternate branch to `drivers/hwmon/applesmc.c`. The selected `igel/applesmc.c` is a different, older implementation: it has ACPI/MMIO and fan support, but lacks the archive's BCLM/`battery_charge_limit` interface. Feature creation depends on discovered keys, and initialization also uses an Apple DMI whitelist.

**Reason / limits:** The preamble describes maintaining a copied driver for newer Macs. That copy exists in the supplied tree, and the normal file's alternate branch has a closing `#endif`. The copy selected by the Makefile is not synchronized to the archived alternate branch: the charge-limit feature is present in the archive's added code but absent from the selected source as supplied. No copy-refresh arrangement or deployed configuration was established, and no default charge limit is written. The source-5 URL retains its literal `.patchh` spelling.

**Declared source:** External; [source 1](https://github.com/t2linux/linux-t2-patches/blob/6.1/3001-applesmc-convert-static-structures-to-drvdata.patch); [source 2](https://github.com/t2linux/linux-t2-patches/blob/6.1/3002-applesmc-make-io-port-base-addr-dynamic.patch); [source 3](https://github.com/t2linux/linux-t2-patches/blob/6.1/3003-applesmc-switch-to-acpi_device-from-platform.patch); [source 4](https://github.com/t2linux/linux-t2-patches/blob/6.1/3004-applesmc-key-interface-wrappers.patch); [source 5](https://github.com/t2linux/linux-t2-patches/blob/6.1/3005-applesmc-basic-mmio-interface-implementation.patchh); [source 6](https://github.com/t2linux/linux-t2-patches/blob/6.1/3006-applesmc-fan-support-on-T2-Macs.patch); [source 7](https://github.com/t2linux/linux-t2-patches/blob/6.1/3009-applesmc-battery-charge-limiter.patch)

<a id="patch-016"></a>

### `IGEL-downgraded/CONFIG_IGEL_HP_T640_EMMC_FIX.diff`

**Change:** `sdhci_o2_execute_tuning()` omits the slot/chip and scratch locals used by the device-specific "Update output phase" switch and excludes that switch, while retaining the subsequent DLL/tuning path. `sdhci_pci_o2_set_clock()` substitutes a restricted SDR104-at-200-MHz PLL adjustment using `0x2c280000` for the normal 208/200-MHz selection and output-clock-source cleanup.

**Scope:** `drivers/mmc/host/sdhci-pci-o2micro.c`; `CONFIG_IGEL_HP_T640_EMMC_FIX` selects the exclusions. No HP t640 DMI filter appears; the shown tuning/clock paths concern the O2Micro driver.

**Reason / limits:** The preamble describes a reboot-hang fix derived from older code. The changes affect O2Micro tuning/clock paths without an HP t640 DMI filter. Their source effect is established, but an actual reboot-hang fix was not tested.

**Declared source:** IGEL-downgraded; [source 1](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/mmc/host/sdhci-pci-o2micro.c?h=linux-5.16.y); `4be33cf187036744b4ed84824e7157cfc09c6f4c`

<a id="patch-017"></a>

### `IGEL-downgraded/CONFIG_IGEL_MMC_QUIRK_FOR_SAMSUNG_TC2.diff`

**Change:** `amd_probe()` adds `SDHCI_QUIRK2_BROKEN_HS200` alongside the existing clear-transfer-mode-before-command quirk for chipset generations `AMD_CHIPSET_BEFORE_ML` and `AMD_CHIPSET_CZ`.

**Scope:** `drivers/mmc/host/sdhci-pci-core.c`; the additional flag requires `CONFIG_IGEL_MMC_QUIRK_FOR_SAMSUNG_TC2`. Generation checks, not a Samsung TC2 machine check, determine runtime scope. The existing transfer-mode quirk remains independently of this option.

**Reason / limits:** The preamble says TC2 reliability regressed after removing an older HS200 quirk. The diff reinstates the flag for those AMD generations but does not show the flag consumer, actual fallback transfer mode, or measured reliability.

**Declared source:** IGEL-downgraded; [source 1](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/mmc/host/sdhci-pci-core.c?h=linux-4.10.y)

<a id="patch-018"></a>

### `IGEL-downgraded/CONFIG_IGEL_NO_SIMPLEFB_PREVENT_VM_SEGFAULT.diff`

**Change:** Selects an alternate `sysfb_init()` that creates simple or legacy firmware framebuffers without assigning a PCI parent. `sysfb_create_simplefb()` loses its parent argument and assignment in both implementation and header/stub signatures. Alternate `sysfb_disable()` ignores its device argument, always unregisters the system framebuffer and permanently sets `disabled`. The replacement initialization retains EFI quirks, simple-mode parsing and fallback names (`efi-`, `vesa-`, `vga-`, `ega-`, or `platform-framebuffer`).

**Scope:** `drivers/firmware/sysfb.c`, `drivers/firmware/sysfb_simplefb.c` and `include/linux/sysfb.h`, guarded by `CONFIG_IGEL_NO_SIMPLEFB_PREVENT_VM_SEGFAULT`. The real implementation/stub selection is `CONFIG_SYSFB_SIMPLEFB`. A nested `CONFIG_IGEL_VMWGFX_FIX` branch skips simple-mode compatibility for VMware `15ad:0405`/`15ad:0406`; that option is defined in this tree's IGEL Kconfig. Otherwise the replacement has no VM-only identity check.

**Reason / limits:** The preamble reports LightDM/libc segfaults from kernel 6.9-rc1 when both simplefb settings are absent and cites a framebuffer-parent change found by bisection. The actual alternative applies wherever the IGEL option is built, including configurations where simplefb is present; its filename does not mean simplefb is universally disabled. The separate VMware option is defined in the supplied tree; its deployment is unknown. The reported segfault/bisection history was not reproduced.

**Declared source:** IGEL-downgraded; [source 1](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/firmware/sysfb.c?h=linux-6.10.y); [source 2](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/firmware/sysfb_simplefb.c?h=linux-6.8.y)

<a id="patch-019"></a>

### `IGEL-downgraded/CONFIG_IGEL_XHCI_THINKCENTRE_M73_REBOOT_QUIRK.diff`

**Change:** `xhci_pci_quirks()` sets `XHCI_SPURIOUS_REBOOT` for Intel `PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI`.

**Scope:** `drivers/usb/host/xhci-pci.c`; requires `CONFIG_IGEL_XHCI_THINKCENTRE_M73_REBOOT_QUIRK` and matching Intel vendor/device. There is no Lenovo/ThinkCentre DMI test, so other machines with that controller receive the same flag.

**Reason / limits:** The preamble describes ThinkCentre M73 powering back up shortly after shutdown and explicitly intends coverage of all machines with the controller. This hunk only adds the flag; the shutdown implementation consuming it and the controller's numeric ID are not shown.

**Declared source:** IGEL-downgraded; [source 1](https://lists.ubuntu.com/archives/kernel-team/2013-October/033091.html); `638298dc66ea36623dbc2757a24fc2c4ab41b016`

<a id="patch-020"></a>

### `IGEL-lore.kernel/CONFIG_IGEL_NFS_QNAP_WORKAROUND.diff`

**Change:** `_nfs4_server_capabilities()` sets `NFS_CAP_FS_LOCATIONS` from the advertised attribute only when `minorversion >= 3`. This tree supports NFSv4 minor versions only up to 2 and rejects larger values, so the option prevents this function from setting the capability for all supported NFSv4 clients. Separately, an unguarded addition sets `NFS_CAP_DELEGTIME` from `TIME_DELEG_MODIFY` alone; a later stricter delegation-time test does not clear that earlier assignment.

**Scope:** `fs/nfs/nfs4proc.c`; the FS_LOCATIONS restriction requires `CONFIG_IGEL_NFS_QNAP_WORKAROUND` and affects all queried NFSv4 servers, not just QNAP. The delegation-time addition is independent of this option.

**Reason / limits:** The preamble claims a restriction to NFSv4.2-capable servers and the comment says v4.3+, but neither expresses the actual supported-client effect: the >=3 threshold is unreachable in this tree, so FS_LOCATIONS capability and its dependent mount trunk-discovery path are suppressed for all supported NFSv4 versions. The comment identifies QNAP knfsd-3.4.6, but there is no QNAP identity gate. The independent delegation-time addition relaxes the existing capability criterion and has no supplied rationale. No mount failure or fix was reproduced.

**Declared source:** IGEL-lore.kernel; [source 1](https://lore.kernel.org/linux-nfs/10d55787-7b97-8636-9426-73fdeda0a122@garloff.de/T/#m00027a668fc42bab7d771efa9d2b22047b2c66dc)

<a id="patch-021"></a>

### `IGEL/CONFIG_IGEL_3DCONNEXION_BATTERY_QUIRK.diff`

**Change:** Adds two USB HID battery-ignore entries for vendor `0x256f`, products `0xc62e` and `0xc631` (SpaceMouse Wireless and SpaceMouse Pro Wireless identifiers). It also adds both devices to `hid_have_special_driver`, so the patch changes special-driver classification as well as battery processing.

**Scope:** `drivers/hid/hid-ids.h`, `hid-input.c`, and `hid-quirks.c`; all additions are guarded by `CONFIG_IGEL_3DCONNEXION_BATTERY_QUIRK`. It uses `HID_BATTERY_QUIRK_IGNORE`, not the narrower avoid-query quirk. No runtime parameter is added.

**Reason / limits:** The preamble reports HID crashes when charge levels are reported. The battery suppression implements that workaround, but the diff supplies no separate special-driver implementation or explanation for the additional classification change.

**Declared source:** IGEL; No reference supplied

<a id="patch-022"></a>

### `IGEL/CONFIG_IGEL_4_SCREENS_BEST_MODE_ISSUE.diff`

**Change:** Counts connectors marked enabled in `drm_client_modeset_probe()` and sets `use_best_mode = 0` when more than three are enabled. This applies to any DRM driver, not just the H860C or AMD V1000 cited in the preamble/comments. The replacement fallback tries cloned modes first; with best mode enabled it tries common modes then best modes, otherwise preferred modes.

**Scope:** `drivers/gpu/drm/drm_client_modeset.c`, guarded by `CONFIG_IGEL_4_SCREENS_BEST_MODE_ISSUE`. The same diff also includes the separately guarded Radeon three-screen rule. The fallback implementation is conditional on `CONFIG_IGEL_USE_BEST_MODE_FRAMEBUFFER`; firmware configuration and clone selection remain earlier paths.

**Reason / limits:** The preamble reports intermittent H860C four-screen failures; comments mention four 4K screens on V1000. The code does not test platform, resolution, or actual modes. It references `use_best_mode`, `m_width`, `m_height`, and custom helpers whose declarations/definitions are absent here. This is shared content with the Radeon patch in this batch, not evidence that both files can be applied independently.

**Declared source:** IGEL; No reference supplied

<a id="patch-023"></a>

### `IGEL/CONFIG_IGEL_ACPI_EC_LG_FIX.diff`

**Change:** In `ec_install_handlers()`, systems matching `dmi_name_in_vendors("LG Electronics")` install the EC address-space handler on `ec->handle`, including the first EC, instead of using the ACPI root for that first controller. The chosen installation handle is recorded and subsequently used by `ec_remove_handlers()`.

**Scope:** `drivers/acpi/ec.c` and `drivers/acpi/internal.h`, under `CONFIG_IGEL_ACPI_EC_LG_FIX`. `struct acpi_ec` gains `address_space_handler_holder`. Nonmatching systems retain the original root-versus-local choice, but also use the recorded handle for removal when this config is defined.

**Reason / limits:** The preamble attributes nonworking LG backlight keys to ACPI EC changes. The observed fix changes handler namespace scope and removal bookkeeping; it does not edit key mappings or list particular LG models.

**Declared source:** IGEL; No reference supplied

<a id="patch-024"></a>

### `IGEL/CONFIG_IGEL_ADD_GENERIC_USB_DEVICE_IDS.diff`

**Change:** Replaces the generic USB serial driver's two-entry zero-initialized table with a populated table and exports it through `MODULE_DEVICE_TABLE`. Added fixed matches are `0780:1202` (ORGA 900), `0780:1302` (ORGA 6000), `04e6:1a02` (eHealth500), and `152a:8180` (CARD STAR /medic2 and /memo3).

**Scope:** `drivers/usb/serial/generic.c`, under `CONFIG_IGEL_ADD_GENERIC_USB_DEVICE_IDS`. The first entry, initialized to `05f9:ffff`, is explicitly designated a placeholder for the insmod-specified device; existing `vendor` and `product` parameters remain in context.

**Reason / limits:** The preamble says to preset known serial devices. This supplies matching/module-alias information, not device-specific serial protocol handling. The initialization code that may replace the placeholder is not included in the diff.

**Declared source:** IGEL; No reference supplied

<a id="patch-025"></a>

### `IGEL/CONFIG_IGEL_ADD_HW_RFKILL_TO_IDEAPAD.diff`

**Change:** Adds `no_hw_rfkill` and `hw_rfkill` boolean module parameters and uses them to override `priv->features.hw_rfkill_switch` in `ideapad_check_features()`. `no_hw_rfkill` wins if both are set; otherwise `hw_rfkill` forces the feature on. With neither set, the existing `hw_rfkill_switch || dmi_check_system(hw_rfkill_list)` decision remains.

**Scope:** `drivers/platform/x86/lenovo/ideapad-laptop.c`, under `CONFIG_IGEL_ADD_HW_RFKILL_TO_IDEAPAD`. Both new parameters default false and have permissions `0444`; no particular Ideapad model is added to a table.

**Reason / limits:** The preamble describes WLAN failures caused by assuming nonexistent hardware switches and a desire to override detection without rebuilding. This changes whether the driver uses the hardware-switch feature, rather than adding or removing physical RF hardware.

**Declared source:** IGEL; No reference supplied

<a id="patch-026"></a>

### `IGEL/CONFIG_IGEL_ADD_I915_HW_DETECTION.diff`

**Change:** Introduces a global `igel_platform` enum initialized to `NO_IGEL_PLATFORM`, with H830C and TC215B predicates. Before PCI driver registration, it reads DMI product name and searches for `TC215B` first, then `H830C`; there is no DMI vendor test.

**Scope:** `drivers/gpu/drm/i915/i915_drv.h` and `i915_pci.c`, under `CONFIG_IGEL_ADD_I915_HW_DETECTION`. Detection occurs in `i915_pci_register_driver()`, not independently for each GPU. The header also adds `QUIRK_SKIP_DP_DPMS_D3` under the separate `CONFIG_IGEL_I915_WYSE_3040_DP_QUIRK` guard.

**Reason / limits:** The preamble says this enables later special treatment. The patch itself only records identity and defines predicates; no H830C/TC215B behavioral consumer is shown. The Wyse quirk bit likewise has no consumer here.

**Declared source:** IGEL; No reference supplied

<a id="patch-027"></a>

### `IGEL/CONFIG_IGEL_ADD_KABA_B_Net_9107_RFID_READER.diff`

**Change:** Adds a `USB_DEVICE(KABA_VID, KABA_B_Net_9107_PID)` entry to the FTDI driver's combined device table. A matching reader can therefore be selected by the existing FTDI serial implementation.

**Scope:** `drivers/usb/serial/ftdi_sio.c`, guarded by `CONFIG_IGEL_ADD_KABA_B_Net_9107_RFID_READER`. There is no new runtime option, probe quirk, or RFID command implementation.

**Reason / limits:** The stated purpose is support for the KABA B-Net 9107 Legic reader. The archive member references, but does not define, the vendor/product constants, so it does not establish their numeric values or whether the target tree already supplies them.

**Declared source:** IGEL; No reference supplied

<a id="patch-028"></a>

### `IGEL/CONFIG_IGEL_ALLOW_ENERGY_POLICY.diff`

**Change:** In `msr_write()`, bypasses the `security_locked_down(LOCKDOWN_MSR)` check when the requested register is one of `MSR_HWP_REQUEST_PKG`, `MSR_PM_ENABLE`, `MSR_IA32_MISC_ENABLE`, or `MSR_HWP_REQUEST`, and the byte count is at most eight. Other registers or longer writes retain the lockdown check. The following `filter_write(reg)` call remains.

**Scope:** `arch/x86/kernel/msr.c`, under `CONFIG_IGEL_ALLOW_ENERGY_POLICY`. This is an MSR-device write-path exception based on register and count, not process name, executable identity, signature, or particular written bits.

**Reason / limits:** The preamble says lockdown prevents `x86_energy_perf_policy` from setting policy. The code is available to callers meeting existing access controls, not only that utility. It does not limit values or policy fields within the four permitted registers.

**Declared source:** IGEL; No reference supplied

<a id="patch-029"></a>

### `IGEL/CONFIG_IGEL_ALLOW_HP_LNXBCU_IOPL.diff`

**Change:** Replaces the unconditional refusal of an `iopl()` privilege increase lacking `CAP_SYS_RAWIO` or encountering I/O-port lockdown with an exception-check sequence. It requires task `comm` exactly `LnxBCU`, an executable path rendered as `/services/hp_bios_tools/hp/LnxBCU`, successful reopening of that path and `/dev/.mnt-system/ro/services/hp_bios_tools/hp/LnxBCU`, byte-for-byte equality through simultaneous EOF, and identical modification timestamps (seconds and nanoseconds). Successful comparison allows the syscall to continue.

**Scope:** `arch/x86/kernel/ioport.c`, under `CONFIG_IGEL_ALLOW_HP_LNXBCU_IOPL`, in the existing `CONFIG_X86_IOPL_IOPERM` implementation. Checks run only when `level > old` and the ordinary capability/lockdown test fails. Thus the exception can substitute for a missing capability as well as bypass lockdown. Normal permitted callers avoid the comparison.

**Reason / limits:** The preamble cites HP BIOS reads/writes, updates, and passwords. The code checks names, paths, opened contents, and mtimes; it does not verify executable signatures, reference-file origin, immutable storage, or the bytes already executing. The `ro` path name alone proves no trust property. Some late `kern_path()` error returns bypass earlier buffer/file cleanup, and the successful mtime-comparison path does not release the acquired path references.

**Declared source:** IGEL; No reference supplied

<a id="patch-030"></a>

### `IGEL/CONFIG_IGEL_ALLOW_RYZENADJ.diff`

**Change:** In PCI sysfs `pci_write_config()`, skips `security_locked_down(LOCKDOWN_PCI_ACCESS)` only for vendor `0x1022`, class `0x60000`, starting offset `0xB8` or `0xBC`, and byte count at most four. All other config writes retain the lockdown decision. The subsequent driver-exclusive-resource check remains.

**Scope:** `drivers/pci/pci-sysfs.c`, under `CONFIG_IGEL_ALLOW_RYZENADJ`. The predicate identifies AMD host-bridge-class devices and small writes at two offsets; it does not identify the calling executable or restrict the values written.

**Reason / limits:** The preamble names `ryzenadj` and lower idle power use. The exception is accessible through this write path under existing permissions to qualifying callers generally, not only a trusted `ryzenadj` binary. No platform-specific offset semantics or actual energy-policy values are supplied.

**Declared source:** IGEL; No reference supplied

<a id="patch-031"></a>

### `IGEL/CONFIG_IGEL_AMDGPU_ADD_DISABLE_MST_SUPPORT_MOD_OPTION.diff`

**Change:** Declares `amdgpu_disable_mst_support`, initializes it to zero, and registers integer module parameter `disable_mst` with permissions `0600`. Its description says zero leaves MST enabled by default and one disables DP MST.

**Scope:** `drivers/gpu/drm/amd/amdgpu/amdgpu.h` and `amdgpu_drv.c`, under `CONFIG_IGEL_AMDGPU_ADD_DISABLE_MST_SUPPORT_MOD_OPTION`. The same hunks also declare, initialize, and register separately guarded FBC, VRAM-preference, and eDP-power-sequencer parameters, repeated in their respective patches in this batch.

**Reason / limits:** The preamble describes an option to disable MST. This archived diff only declares, initializes, and registers the module parameter; it does not itself contain code reading `amdgpu_disable_mst_support`. Shared hunks also appear in companion option patches.

**Declared source:** IGEL; No reference supplied

<a id="patch-032"></a>

### `IGEL/CONFIG_IGEL_AMDGPU_ADD_PREFER_VRAM_MOD_OPTION.diff`

**Change:** Adds integer `prefer_vram_over_gtt` (`0600`, default `-1`). In `amdgpu_bo_get_preferred_domain()`, a combined VRAM/GTT request on Carrizo or Stoney chooses GTT for zero, VRAM for one, and the existing VRAM-size threshold otherwise. `amdgpu_bo_pin()` retains the original requested domain and retries in GTT on `-ENOMEM` if a combined-domain request was narrowed to VRAM. A separate FBC-domain helper chooses VRAM only for value one, otherwise GTT; FBC allocation also retries GTT on VRAM `-ENOMEM`.

**Scope:** `amdgpu.h`, `amdgpu_drv.c`, `amdgpu_object.c/.h`, and `display/amdgpu_dm/amdgpu_dm.c`, under `CONFIG_IGEL_AMDGPU_ADD_PREFER_VRAM_MOD_OPTION`. Ordinary preference narrowing is Carrizo/Stoney-specific; the new FBC helper has no such ASIC guard. Shared parameter hunks include the other three AMD options.

**Reason / limits:** The preamble states a VRAM-preference option, without a workload or failure example. This is not universal VRAM preference: it affects selected combined-domain requests and FBC allocation, with fallbacks.

**Declared source:** IGEL; No reference supplied

<a id="patch-033"></a>

### `IGEL/CONFIG_IGEL_AMDGPU_ADD_USE_FBC_MOD_OPTION.diff`

**Change:** Adds integer `use_fbc` (`0600`) initialized to zero. `amdgpu_dm_fbc_init()` returns before compressor initialization when the value is zero; `should_enable_fbc()` returns false unless the value is exactly one. Thus enabling this config changes the default to FBC suppression, while one permits the existing eligibility logic rather than forcing compression unconditionally.

**Scope:** `amdgpu.h`, `amdgpu_drv.c`, `display/amdgpu_dm/amdgpu_dm.c`, and `display/dc/hwss/dce110/dce110_hwseq.c`, under `CONFIG_IGEL_AMDGPU_ADD_USE_FBC_MOD_OPTION`. Shared parameter hunks also expose the other AMD options under their separate guards.

**Reason / limits:** The preamble asks for an FBC-disabling option, with no particular device failure described. Values other than zero/one are not equivalent: initialization can proceed for a nonzero value while the enable check still rejects it. Runtime writes do not themselves add a reinitialization or display-reprogramming trigger.

**Declared source:** IGEL; No reference supplied

<a id="patch-034"></a>

### `IGEL/CONFIG_IGEL_AMDGPU_CALL_DP_CEC_FUNCS_ONLY_FOR_DP.diff`

**Change:** Restricts DP CEC EDID-unset, attach, IRQ, and connector-unregister calls to connectors classified as DisplayPort or eDP. Existing AUX-mode checks remain around attach and the no-EDID unset path; the no-sink unset and teardown paths receive only the connector-type check. HPD RX IRQ handling also retains the existing exclusion of MST branches.

**Scope:** `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c`, under `CONFIG_IGEL_AMDGPU_CALL_DP_CEC_FUNCS_ONLY_FOR_DP`, in connector detection/update, HPD RX interrupt handling, and destruction. HDMI CEC calls remain unchanged.

**Reason / limits:** The preamble says some devices behave badly when DP CEC helpers run on non-DP connectors. This adds type-based gating, not device-specific exceptions, and explicitly includes eDP despite the shorter “only for DP” title. It does not disable CEC generally.

**Declared source:** IGEL; No reference supplied

<a id="patch-035"></a>

### `IGEL/CONFIG_IGEL_AMDGPU_CHANGE_DEFAULT_NORETRY_OPTION.diff`

**Change:** Initializes `amdgpu_noretry` to zero instead of minus one when the IGEL config is defined. The `amdgpu_uni_mes = 1` declaration is moved past the conditional without changing its value.

**Scope:** `drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c`, guarded by `CONFIG_IGEL_AMDGPU_CHANGE_DEFAULT_NORETRY_OPTION`. It changes the compiled initializer only; no parameter registration or consumer logic is included.

**Reason / limits:** The preamble only states the intended default change. It does not explain the failure being addressed or how `noretry` values affect particular GPU generations; those semantics should not be inferred from the option name alone.

**Declared source:** IGEL; No reference supplied

<a id="patch-036"></a>

### `IGEL/CONFIG_IGEL_AMDGPU_FIX_EDP_NOT_WAKING_UP_AFTER_SUSPEND.diff`

**Change:** Adds integer `support_edp0_on_dp1` (`0644`, default `-1`) and uses it in `dcn31_panel_cntl_construct()`. Zero selects sequential panel-instance power-sequencer mapping; one maps DIGA/DIGB to sequencer zero/one; minus one retains the existing `dc->config.support_edp0_on_dp1` choice. The DIG-engine switch is moved outside the previous support check, so its warning/assert for other engines executes even when sequential mapping is selected.

**Scope:** `amdgpu.h`, `amdgpu_drv.c`, and `display/dc/dcn31/dcn31_panel_cntl.c`. Parameter and mapping override are under `CONFIG_IGEL_AMDGPU_FIX_EDP_NOT_WAKING_UP_AFTER_SUSPEND`; the switch relocation and `#ifndef REG_SET/REG_GET` macro-definition protections are not config-gated. Shared hunks include FBC, VRAM, and MST options.

**Reason / limits:** The preamble reports an internal display failing after suspend since 6.10.x and uncertainty over device specificity. The code changes panel construction, not a resume callback or direct wake operation. Values outside `-1/0/1` have no assignment branch in the enabled override. No model whitelist or evidence establishing the correct override for a given device is supplied.

**Declared source:** IGEL; No reference supplied

<a id="patch-037"></a>

### `IGEL/CONFIG_IGEL_AMD_USB2_CHERRY_KEYBOARD_WORKAROUND.diff`

**Change:** Makes `xhci_endpoint_reset()` return early on an AMD CPU when the USB manufacturer string begins with `Cherry GmbH`. It logs that the device will not be reset and skips the subsequent endpoint-reset implementation.

**Scope:** `drivers/usb/host/xhci.c`, under `CONFIG_IGEL_AMD_USB2_CHERRY_KEYBOARD_WORKAROUND`, after obtaining the endpoint's USB device. There is no VID/PID, controller vendor, USB speed, or M350c DMI check; the commented-out product-name test is not active.

**Reason / limits:** The preamble names Cherry keyboards on AMD USB 2.0, mainly M350c, and says the workaround came from AMD. Comments cite older commit behavior. The effective condition is broader: any matching manufacturer prefix on an AMD CPU, not only the Secure Board or USB 2.0 connectors.

**Declared source:** IGEL; No reference supplied

<a id="patch-038"></a>

### `IGEL/CONFIG_IGEL_BCMA_PREFER_BROADCOM_STA.diff`

**Change:** Wraps a range of Broadcom PCI bridge table entries in `#ifdef CONFIG_IGEL_BCMA_PREFER_BROADCOM_STA`. Consequently, defining this config retains those BCMA matches; leaving it undefined removes the wrapped matches. Broadcom device `0x0576`, before the conditional, remains unconditional.

**Scope:** `drivers/bcma/host_pci.c`, in `bcma_pci_bridge_tbl` and its exported PCI match table. Visible boundary entries include `0x4313`, `43224` (`0xa8d8`), `0x4331`, `0x4727`, `43227` (`0xa8db`), and `43228` (`0xa8dc`). Intermediate unchanged entries are not printed by this diff.

**Reason / limits:** The preamble says to switch off detection for devices handled by Broadcom STA/WL. The guard polarity is opposite the intuitive enabled-option reading of that statement. No WL driver addition or availability check is present; removing BCMA matches does not itself guarantee an alternative driver binds.

**Declared source:** IGEL; No reference supplied

<a id="patch-039"></a>

### `IGEL/CONFIG_IGEL_CHANGE_OSS_DEVICE_NAMES.diff`

**Change:** Alters `sound_insert_unit()` so first-unit names beginning with `dsp`, `audio`, or `mixer` use the numbered formatting path (`sound/%s%d`), yielding a zero suffix for the first unit. Other names with `r < SOUND_STEP` retain the unnumbered form; later units remain numbered as before.

**Scope:** `sound/sound_core.c`, under `CONFIG_IGEL_CHANGE_OSS_DEVICE_NAMES`. Tests are prefix comparisons rather than exact string equality. No symlink creation is added.

**Reason / limits:** The preamble says IGEL creates `dsp -> dsp0` links and wants zero-suffixed OSS names. This patch changes kernel naming to support that convention, but the userspace device-node/link policy is not included.

**Declared source:** IGEL; No reference supplied

<a id="patch-040"></a>

### `IGEL/CONFIG_IGEL_CLIENTRON_SD_CARD_QUIRK.diff`

**Change:** Adds `adl_clientron_removable()` and, during `glk_emmc_probe_slot()`, clears `MMC_CAP_NONREMOVABLE` for an Intel Alder Lake eMMC PCI device whose DMI system vendor is `Clientron corp.` **or** product name is `UA9 TC156-AN`. It logs “Mark MMC as removable.”

**Scope:** `drivers/mmc/host/sdhci-pci-core.c`, under `CONFIG_IGEL_CLIENTRON_SD_CARD_QUIRK`. Existing Bay Trail probing still runs first, and the later CQE decision remains. The vendor/product checks are alternatives, not a required pair.

**Reason / limits:** The preamble describes instability when no SD card is inserted. The code changes the host's removability capability, with no card-present test and no runtime option. It does not identify a specific failure mechanism or alter physical eMMC/card wiring.

**Declared source:** IGEL; No reference supplied

<a id="patch-041"></a>

### `IGEL/CONFIG_IGEL_DISABLE_RTL8XXXU_USB_IDS_HANDLED_BY_8192EU.diff`

**Change:** Adds two `#ifndef CONFIG_IGEL_DISABLE_RTL8XXXU_USB_IDS_HANDLED_BY_8192EU` openings in rtl8xxxu's USB device table: one before Realtek `0x818b` (using `rtl8192eu_fops`) and one before vendor-driver-listed `2357:0107` and `2019:ab33`. The intended direction is to omit matches when this config is defined.

**Scope:** `drivers/net/wireless/realtek/rtl8xxxu/core.c`, in `dev_table`. Entries use vendor-specific interface class/subclass/protocol `0xff`. No alternative 8192eu driver is supplied.

**Reason / limits:** The preamble reports problems with officially supported devices. Crucially, the complete archive member contains no closing `#endif` for either added opening. It therefore does not delimit the actual intended excluded ranges and cannot establish a complete, independently applicable table modification. A TP-Link TL-WN822N v4 comment is visible, but its match is outside the printed context.

**Declared source:** IGEL; No reference supplied

<a id="patch-042"></a>

### `IGEL/CONFIG_IGEL_DISBALE_EFI_COMPLETE_WITH_NOEFI_PARAM.diff`

**Change:** Makes `efisubsys_init()` return immediately if `efi_runtime_disabled()` is true, as well as for the existing no-`EFI_BOOT` case. This skips the remainder of EFI subsystem initialization through this function.

**Scope:** `drivers/firmware/efi/efi.c`, under the literally spelled `CONFIG_IGEL_DISBALE_EFI_COMPLETE_WITH_NOEFI_PARAM`. No boot-parameter parser, EFI-stub code, or other EFI call site is changed.

**Reason / limits:** The preamble says `noefi` left unwanted EFI messages and promises complete EFI shutdown. The actual change is an initialization-path gate based on runtime-disabled state. The diff does not prove that all EFI functionality is disabled or show every circumstance setting that state.

**Declared source:** IGEL; No reference supplied

<a id="patch-043"></a>

### `IGEL/CONFIG_IGEL_DO_NOT_LIMIT_MAX_MODE_SIZE_TO_CURRENT_FB.diff`

**Change:** Passes zero width/height instead of the current framebuffer dimensions to `drm_client_modeset_probe()` during `drm_fb_helper_hotplug_event()`. This removes the current-fb size arguments from that hotplug probe, before `drm_setup_crtcs_fb()`.

**Scope:** `drivers/gpu/drm/drm_fb_helper.c`, under `CONFIG_IGEL_DO_NOT_LIMIT_MAX_MODE_SIZE_TO_CURRENT_FB`. With `CONFIG_IGEL_USE_BEST_MODE_FRAMEBUFFER`, the call also forwards `drm_use_best_mode`, `drm_use_max_w`, and `drm_use_max_h`; those controls are not removed. Without it, the ordinary call signature is retained.

**Reason / limits:** The preamble objects to monitor mode limits derived from the current framebuffer. This does not remove all mode limits, enlarge buffers itself, or change initial enumeration everywhere. The custom signature and variables depend on best-mode support not defined here.

**Declared source:** IGEL; No reference supplied

<a id="patch-044"></a>

### `IGEL/CONFIG_IGEL_DO_NOT_WRITE_EFI_PCR9_REGISTER.diff`

**Change:** Conditionally removes the `efi_measure_tagged_event()` calls for nonempty loaded-image command-line options in `efi_convert_cmdline()` and for nonempty initrd data in `efi_load_initrd()`. The initrd-success measurement log is also omitted; normal load-option conversion and initrd table allocation remain.

**Scope:** `drivers/firmware/efi/libstub/efi-stub-helper.c`, with call sites under `#ifndef CONFIG_IGEL_DO_NOT_WRITE_EFI_PCR9_REGISTER`. An additional opening conditional precedes the measurement-support `static_assert`; the complete member supplies no corresponding close for that opening.

**Reason / limits:** The preamble cites initrd PCR9 measurement conflicting with IGEL TPM handling and newer GRUB. The diff also suppresses load-option measurement, a broader change than that summary. It does not change image signature verification or demonstrate every measurement performed elsewhere. The missing conditional closure leaves the intended helper-region boundary and standalone applicability unresolved.

**Declared source:** IGEL; No reference supplied

<a id="patch-045"></a>

### `IGEL/CONFIG_IGEL_DRM_I915_SAVE_RESTORE_SDVO.diff`

**Change:** Adds per-SDVO vendor-register storage and validity state, a single-register I2C writer, and save/restore routines for the range `SDVO_I2C_VENDOR_BEGIN` through `0xff`. New public `intel_sdvo_save()/restore()` helpers iterate connectors and invoke the matching SDVO callbacks. `drm_connector_funcs` gains `save` and `restore` members; SDVO registers those callbacks.

**Scope:** `drivers/gpu/drm/i915/display/intel_sdvo.c/.h` and `include/drm/drm_connector.h`, under `CONFIG_IGEL_DRM_I915_SAVE_RESTORE_SDVO`. There is no SDVO vendor/device whitelist. Save and restore stop at their first failed I2C access.

**Reason / limits:** The preamble promises register preservation over suspend/resume. No suspend/resume caller of the new public helpers is present, so actual invocation is not established by this member. Moreover, save sets `vendor_regs_valid = true` even after an early read failure, while restore may write the entire stored range. The register-range constant's numeric starting value is not defined in this member, and no per-register restrictions are documented.

**Declared source:** IGEL; No reference supplied

<a id="patch-046"></a>

### `IGEL/CONFIG_IGEL_E1000E_OPTIPLEX_WORKAROUND.diff`

**Change:** Adds a fallback branch in `e1000_phy_is_accessible_pchlan()` that writes hardcoded PHY ID `22282400` and revision `6`, then jumps to the existing exit. It runs only when the preceding normal PHY-ID acceptance branch was not taken and DMI matches both `Dell Inc.` and `OptiPlex Micro 7020`.

**Scope:** `drivers/net/ethernet/intel/e1000e/ich8lan.c`, under `CONFIG_IGEL_E1000E_OPTIPLEX_WORKAROUND`. It adds the DMI header and error-level trigger log. No explicit reboot-state condition is present.

**Reason / limits:** The preamble reports PHY-ID detection failure after reboot. The patch supplies known identity data on that fallback path; it does not retry the read or repair PHY communication.

**Declared source:** IGEL; No reference supplied

<a id="patch-047"></a>

### `IGEL/CONFIG_IGEL_EDID_DETECTION_SECOND_TRY_QUIRK.diff`

**Change:** Adds retry-count handling inside the `ret == -ENXIO` branch of `drm_do_probe_ddc_edid()`: counts at most two log and break; larger counts become two. However, the original unconditional `break` remains immediately after the conditional block, so the larger-count path also exits the loop instead of performing the advertised second transfer.

**Scope:** `drivers/gpu/drm/drm_edid.c`, under `CONFIG_IGEL_EDID_DETECTION_SECOND_TRY_QUIRK`. No Lenovo DMI or connector-type restriction is present.

**Reason / limits:** The preamble promises a second EDID read after the first `-ENXIO`, and comments mention ThinkCentre M32. The full diff's retained `break` contradicts that intended behavior. It may alter logging/retry bookkeeping, but does not implement the promised loop retry as written.

**Declared source:** IGEL; No reference supplied

<a id="patch-048"></a>

### `IGEL/CONFIG_IGEL_FIX_DELL_HARDWARE_BUTTONS.diff`

**Change:** Adds a DMI quirk for Dell Wyse 5470 AIO that force-enables GPEs `0x43`, `0x44`, and `0x45` through `acpi_set_gpe(NULL, ..., ACPI_GPE_ENABLE)` after successful WMI driver registration. It also sets a single-event flag before registration and copies it to per-device state during probe. `dell_wmi_notify()` then trims event buffers to the first entry even for nonzero interface versions on that machine.

**Scope:** `drivers/platform/x86/dell/dell-wmi-base.c`, under `CONFIG_IGEL_FIX_DELL_HARDWARE_BUTTONS`; table matches system vendor `Dell Inc.` and product `Wyse 5470 AIO`. GPE-enable failures generate warnings but do not change the final zero return. Other machines retain normal event parsing.

**Reason / limits:** The preamble cites nonworking side buttons. Comments explain firmware enable-bit mismatch and garbage beyond the first `_WED` event, associating the three GPEs with brightness up/down and display toggle. The code directly enables hardware GPE state rather than changing ACPI's reference count. No resume reapplication or teardown undo is added; additional models require code/table entries, not a runtime parameter.

**Declared source:** IGEL; No reference supplied

<a id="patch-049"></a>

### `IGEL/CONFIG_IGEL_FIX_MT183_WIFI_ISSUE.diff`

**Change:** Adds Atrust mt183 to `bridge_d3_blacklist`, matching DMI vendor `Atrust Computer Corp.`, product `mt183`, and product version `1.0`. The same member separately adds Elo i2 RevB under `CONFIG_IGEL_FIX_ELO_I2_WIFI_ISSUE`.

**Scope:** `drivers/pci/pci.c`; the mt183 entry is guarded by `CONFIG_IGEL_FIX_MT183_WIFI_ISSUE`. This is system-level PCI bridge D3 blacklisting, not a Wi-Fi-driver or particular wireless PCI-ID change.

**Reason / limits:** The preamble's "WiFi PCI issue" is clarified by comments: a downstream device becomes inaccessible after a root port goes to D3cold and returns to D0. This diff adds a blacklist entry; the actual achieved power-transition outcome was not tested.

**Declared source:** IGEL; No reference supplied

<a id="patch-050"></a>

### `IGEL/CONFIG_IGEL_FIX_OLD_BIOS_CPU_STEPPING.diff`

**Change:** In `intel_idle_init()`, if `max_cstate` still equals `CPUIDLE_STATE_MAX - 1`, an Intel family 6/model `0x37`/stepping `0x9` CPU with a DMI BIOS date before November 2018 gets `max_cstate = 1`. An additional `cpuid_level < CPUID_LEAF_MWAIT` return is inserted outside the IGEL guard.

**Scope:** `drivers/idle/intel_idle.c`, with the DMI include and C-state rule under `CONFIG_IGEL_FIX_OLD_BIOS_CPU_STEPPING`. No product or J1900-name check exists. A nondefault maximum is not overridden; the day is read but not used.

**Reason / limits:** The preamble links old downgraded BIOSes on J1900 devices to crashes and says limiting C-states helps. The date-parser's return value is ignored at this call site. The unguarded CPUID check is an additional general behavior change.

**Declared source:** IGEL; No reference supplied

<a id="patch-051"></a>

### `IGEL/CONFIG_IGEL_FIX_R8169_WOL.diff`

**Change:** Removes `WAKE_BCAST` from `rtl8169_get_wol()`'s advertised capabilities; broadens the `rtl_wol_enable_rx()` receive-acceptance adjustment from MAC versions at least 25 to at least 18; and calls `__rtl8169_set_wol(tp, 0)` during `rtl_init_one()`. The receive adjustment still sets broadcast, multicast, and physical-address acceptance bits.

**Scope:** `drivers/net/ethernet/realtek/r8169_main.c`, under `CONFIG_IGEL_FIX_R8169_WOL`. No model/DMI filter or new parameter is supplied. Returning `saved_wolopts` remains unchanged.

**Reason / limits:** The preamble broadly reports unreliable WOL; comments specifically say including broadcast wake prevented waking. Masking advertised broadcast wake is distinct from clearing receive broadcast acceptance. The diff does not show the WOL setter's validation or all later initialization, so it does not establish a permanent final default or every rejected setting.

**Declared source:** IGEL; No reference supplied

<a id="patch-052"></a>

### `IGEL/CONFIG_IGEL_FIX_RADEON_3_SCREENS_BEST_MODE_ISSUE.diff`

**Change:** Counts enabled DRM client connectors and disables `use_best_mode` at more than two when `dev->driver->name` equals `radeon`. For the custom best-mode fallback, clone selection still happens first; disabling best mode makes the later branch select preferred modes instead of trying common/best modes. Firmware configuration remains the earlier path.

**Scope:** `drivers/gpu/drm/drm_client_modeset.c`, under `CONFIG_IGEL_FIX_RADEON_3_SCREENS_BEST_MODE_ISSUE`. The identical shared diff also includes the separately guarded four-or-more-screen rule for all drivers. Custom fallback use depends on `CONFIG_IGEL_USE_BEST_MODE_FRAMEBUFFER` and definitions/signature support not supplied here.

**Reason / limits:** The preamble says some Radeon devices fail with three or more monitors; comments mention differing resolutions. The actual test is driver name and count only, with no resolution comparison or device whitelist. Shared hunks with the four-screen patch are visible duplication, not evidence of independent clean application.

**Declared source:** IGEL; No reference supplied

<a id="patch-053"></a>

### `IGEL/CONFIG_IGEL_FIX_WWAN_RFKILL_FOR_THINKPAD_L480.diff`

**Change:** Makes `wan_get_status()` return `TPACPI_RFK_RADIO_ON` when DMI system vendor contains `LENOVO` and product version contains `ThinkPad L480`. This bypasses the later ordinary status-query path for matching systems. The member also includes a separately guarded early return when `wwan_rfkill` is false.

**Scope:** `drivers/platform/x86/lenovo/thinkpad_acpi.c`, under `CONFIG_IGEL_FIX_WWAN_RFKILL_FOR_THINKPAD_L480`; the parameter-related branch uses `CONFIG_IGEL_THINKPAD_RFKILL_MODULE_PARAM`. Substring matches are used, with null checks.

**Reason / limits:** The preamble describes a nonexistent WWAN switch causing blocking. The code overrides reported WWAN status; it does not remove the rfkill object or directly power on the radio. `wwan_rfkill` declaration/default/registration are absent here.

**Declared source:** IGEL; No reference supplied

<a id="patch-054"></a>

### `IGEL/CONFIG_IGEL_FUJITSU_DVI_VGA_SPLIT_QUIRKS.diff`

**Change:** In `radeon_atom_apply_quirks()`, suppresses a VGA connector by returning false for PCI device `0x9805`, subsystem `1734:11bd`, when the DMI board name contains `D3003-S1`. The member also includes separately guarded LVDS suppression (`radeon_lvds == 0`) and M340C handling: recognizing device `0x9854`/subsystem `1002:9854`, setting platform identity from board name, and converting a DFP2 DisplayPort connector to DVI-D on M340C.

**Scope:** `drivers/gpu/drm/radeon/radeon_atombios.c`; Fujitsu logic uses `CONFIG_IGEL_FUJITSU_DVI_VGA_SPLIT_QUIRKS`, with additional `CONFIG_IGEL_RADEON_LVDS_SWITCH` and `CONFIG_IGEL_M340C_DVI_VGA_SPLIT_QUIRKS` branches.

**Reason / limits:** The preamble simply promises split DVI/VGA support. Comments distinguish a D3003-S2 description from the actual D3003-S1 board restriction and mention Futro S700 VGA trouble. This patch suppresses one connector description, not new independent split-output plumbing. M340C platform definitions and `radeon_lvds` are not provided; `product` is declared only under the Radeon-detection or Fujitsu guards despite use by the M340C branch.

**Declared source:** IGEL; No reference supplied

<a id="patch-055"></a>

### `IGEL/CONFIG_IGEL_GENERATE_UUID_FOR_SQUASHFS.diff`

**Change:** Fills all 16 bytes of `sb->s_uuid` from SquashFS superblock fields: four bytes each of inode count, mkfs time, and fragment count, followed by two bytes each of compression and block-log values. This is a deterministic concatenation of stored metadata, not random UUID generation or a cryptographic content identifier.

**Scope:** `fs/squashfs/super.c`, in `squashfs_fill_super()`, under `CONFIG_IGEL_GENERATE_UUID_FOR_SQUASHFS`. The filesystem remains read-only; no on-disk field is written.

**Reason / limits:** The preamble cites overlayfs warnings about zero UUIDs. The patch supplies an in-memory identifier but does not enforce uniqueness; different images with the same selected metadata can produce identical identifiers.

**Declared source:** IGEL; No reference supplied

<a id="patch-056"></a>

### `IGEL/CONFIG_IGEL_HP_RFKILL_MT645_G7_FIX.diff`

**Change:** Adds DMI substring checks for vendor `HP` and product name `mt645 G7` in `hp_wmi_bios_setup()`. For matches, `no_rfkill` prevents entering the shown legacy rfkill setup block, otherwise preserving the existing `!hp_wmi_bios_2009_later()` condition and `hp_wmi_rfkill_setup()`/fallback `hp_wmi_rfkill2_setup()` sequence.

**Scope:** `drivers/platform/x86/hp/hp-wmi.c`, under `CONFIG_IGEL_HP_RFKILL_MT645_G7_FIX`. Detected rfkill pointers/count are still cleared first; no user parameter is added.

**Reason / limits:** The preamble reports rfkill cycling every two or three seconds with hp-wmi loaded. The code avoids setup in this block, not every conceivable rfkill provider.

**Declared source:** IGEL; No reference supplied

<a id="patch-057"></a>

### `IGEL/CONFIG_IGEL_HP_T240_SOUND_FIXES.diff`

**Change:** Adds exported unsigned `rt5645_jack_option` (`0644`, default zero), described as combo jack zero or split jack one. For one, `rt5645_jack_detect_work()` reads JD comparator/status registers, adjusts JD1_1/JD1_2 polarity, separately reports headphone/microphone presence, and returns before the ordinary mutex-protected detection path. Probe adds codec register writes, JD1_2 IRQ enable and inversion changes. The Cherry Trail/Braswell machine driver selects a split-jack routing map for RT5645 and value one, and only performs the shown idle internal-clock switch for value zero.

**Scope:** `sound/soc/codecs/rt5645.c/.h` and `sound/soc/intel/boards/cht_bsw_rt5645.c`, under `CONFIG_IGEL_HP_T240_SOUND_FIXES`. No HP DMI match exists. Some IRQ/inversion changes depend on pdata mode rather than the option itself. The existing initial `rt5645_irq()` call becomes config-dependent.

**Reason / limits:** The preamble says to fix t240 jack detection. The new `jd_mode1_platform_data` is defined but not selected in this member. Split detection is observable from the register/report code, but default enablement and complete integration are not established by this diff alone.

**Declared source:** IGEL; No reference supplied

<a id="patch-058"></a>

### `IGEL/CONFIG_IGEL_HP_T640_SOUND_FIXES.diff`

**Change:** Adds a Realtek HDA fixup that installs a playback hook during `HDA_FIXUP_ACT_PRE_PROBE`. PCM open calls `alc_auto_setup_eapd(codec, true)` and PCM close calls it with false; other playback actions receive no added operation.

**Scope:** `sound/hda/codecs/realtek/alc269.c`, under `CONFIG_IGEL_HP_T640_SOUND_FIXES`. The new fixup enum/table entry is selected by subsystem vendor/device `103c:8523`, labelled HP t640, and does not add a global module option.

**Reason / limits:** The preamble reports speaker noise. The observed workaround couples EAPD setup to stream open/close rather than continuous playback state. The helper implementation and evidence that this removes noise on the hardware are not contained in the diff.

**Declared source:** IGEL; No reference supplied

<a id="patch-059"></a>

### `IGEL/CONFIG_IGEL_I915_ADD_DISABLE_DP_AUDIO_OPTION.diff`

**Change:** Registers boolean `disable_dp_audio` (`0644`, advertised default false) and adds early audio rejection in `intel_dp_port_has_audio()` and conditional audio configuration in `intel_dp_compute_config()`. A shared `intel_ddi_get_config()` change reads hardware audio state and attempts to clear it when a comparison involving `encoder->compute_output_type` equals `INTEL_OUTPUT_DP` and the parameter is set.

**Scope:** `drivers/gpu/drm/i915/display/intel_ddi.c`, `intel_dp.c`, and `i915_params.c/.h`. DP decision branches require both `CONFIG_IGEL_I915_ADD_DISABLE_DP_AUDIO_OPTION` and `_I915_PARAMS_H_`. The DDI branch instead allows either DP or HDMI config, yet unconditionally references `disable_dp_audio`. Common registration hunks include other independently guarded IGEL i915 parameters.

**Reason / limits:** The preamble cites debugging and getting displays working; comments mention black screens when DP audio initializes at high resolutions. The shown DDI comparison casts `compute_output_type` rather than calling it; this analysis does not establish the intended output-type detection. Advertised defaults and full parameter definitions are not shown in this diff.

**Declared source:** IGEL; No reference supplied

<a id="patch-060"></a>

### `IGEL/CONFIG_IGEL_I915_ADD_DISABLE_HDMI_AUDIO_OPTION.diff`

**Change:** Registers boolean `disable_hdmi_audio` (`0644`, advertised default false). `intel_hdmi_has_audio()` returns false for a set parameter, ahead of force-audio handling; `intel_hdmi_compute_config()` suppresses audio computation likewise. Importantly, its config-enabled branch also omits the existing `intel_link_bw_compute_pipe_bpp()` call and its `-EINVAL` return, even when the runtime parameter is false.

**Scope:** `drivers/gpu/drm/i915/display/intel_ddi.c`, `intel_hdmi.c`, and `i915_params.c/.h`. HDMI decisions additionally require `_I915_PARAMS_H_`. Shared DDI changes still test `disable_dp_audio`, not `disable_hdmi_audio`, under a guard accepting either config. Repeated registration/header hunks overlap the other i915 option patches.

**Reason / limits:** The preamble cites display workarounds/debugging. The removed bandwidth/BPP validation from the enabled-config path is broader than audio disabling. The shown cast comparison using `encoder->compute_output_type` does not establish the intended type detection.

**Declared source:** IGEL; No reference supplied

<a id="patch-061"></a>

### `IGEL/CONFIG_IGEL_I915_ADD_LIMIT_DP_RATE_OPTION.diff`

**Change:** Registers integer `limit_dp_max_rate` (`0644`, described default zero), and in `intel_dp_set_source_rates()` caps `max_rate` when the requested value is at least `162000` and the existing maximum is zero or higher than the request. The existing `intel_dp_rate_limit_len()` subsequently filters source rates.

**Scope:** `drivers/gpu/drm/i915/display/intel_dp.c` and `i915_params.c/.h`, under `CONFIG_IGEL_I915_ADD_LIMIT_DP_RATE_OPTION`; the consumer additionally requires `_I915_PARAMS_H_`. Parameter help lists values from `162000` to `810000`, but the condition does not enforce membership in that list. Shared hunks include other i915 option registrations.

**Reason / limits:** The preamble says this is primarily a debugging control and cautions against using it for bad cables; comments also cite wrongly detected rates/black screens. It caps selection rather than forcing a specific listed rate or directly retraining links on a parameter write. The archived header has an unclosed conditional and no new field/default definition, so the help's default is not independently established by an initializer.

**Declared source:** IGEL; No reference supplied

<a id="patch-062"></a>

### `IGEL/CONFIG_IGEL_I915_ADD_M250C_NO_LIMITED_COLOR_RANGE_OPTION.diff`

**Change:** Registers boolean `m250c_no_limited_color_range` (`0444`, described default false). When set and the connector name equals `DP-1`, `intel_dp_limited_color_range()` returns false before its ordinary color-range logic, including the subsequent comment about YCbCr always being limited.

**Scope:** `drivers/gpu/drm/i915/display/intel_dp.c` and `i915_params.c/.h`, under `CONFIG_IGEL_I915_ADD_M250C_NO_LIMITED_COLOR_RANGE_OPTION`; the consumer also requires `_I915_PARAMS_H_`. There is no M250C DMI/PCI identity check: the parameter applies to any connector named `DP-1` reaching this function. Shared registration/header hunks overlap other options.

**Reason / limits:** The preamble describes M250 color trouble and a black-screen interval when applying a userspace xrandr workaround, expressly calling disabled limited colorspace “wrong but works.” The code makes an earlier kernel decision, not a hardware-specific detection fix. Its early return is broader than only overriding a normal RGB choice. The header's new conditional is unclosed and lacks the new field/default initializer.

**Declared source:** IGEL; No reference supplied

<a id="patch-063"></a>

### `IGEL/CONFIG_IGEL_I915_ADD_OPTION_TO_CHANGE_CONNECTOR_ENUM_ORDER.diff`

**Change:** Registers boolean `reverse_enum_order` (`0444`, described default false). `intel_bios_for_each_encoder()` uses `list_for_each_entry_reverse()` instead of forward iteration over `display->vbt.display_devices` when the option is nonzero, invoking the supplied callback for each entry.

**Scope:** `drivers/gpu/drm/i915/display/intel_bios.c` and `i915_params.c/.h`, under `CONFIG_IGEL_I915_ADD_OPTION_TO_CHANGE_CONNECTOR_ENUM_ORDER`; iteration override additionally requires `_I915_PARAMS_H_`. No particular platform, connector type, or callback is restricted. Shared registration hunks include the other i915 options.

**Reason / limits:** The preamble attributes changed connector order to 6.6.x and seeks former behavior. The patch reverses this VBT encoder traversal rather than explicitly renaming connectors or reverting every enumeration path. Actual connector numbering depends on its callers. The archived header opens a conditional but supplies neither its closing/alternative branch nor a new field/default definition, so complete option integration is not visible.

**Declared source:** IGEL; No reference supplied

<a id="patch-064"></a>

### `IGEL/CONFIG_IGEL_I915_CHANGE_DEFAULT_POWER_WELL_OPTION.diff`

**Change:** Changes the `disable_power_well` parameter help to label zero (“power wells always on”) as default instead of minus one (“auto”). It also omits registration of `enable_dmc_wl` when the same IGEL config is defined.

**Scope:** `drivers/gpu/drm/i915/display/intel_display_params.c`, under `CONFIG_IGEL_I915_CHANGE_DEFAULT_POWER_WELL_OPTION`. `disable_power_well` remains an unsafe integer parameter with permissions `0400`. No variable initializer or power-well consumer is modified in this archive member.

**Reason / limits:** The preamble cites nonstandard backlight controllers, such as DLOG, not recovering after DPMS power-well disabling. The visible diff changes documentation, not the actual default initialization, so the promised default cannot be confirmed here. Removing the DMC wakelock parameter registration is an additional change with no stated rationale.

**Declared source:** IGEL; No reference supplied

<a id="patch-065"></a>

### `IGEL/CONFIG_IGEL_I915_DISABLE_LVDS_MODULE_OPTION.diff`

**Change:** Registers integer `lvds` (`0444`) and returns early from `intel_lvds_init()` when its value is zero, with an informational log. Nonzero values continue existing LVDS initialization; it is a module-wide initialization gate rather than per-connector runtime switching.

**Scope:** `drivers/gpu/drm/i915/display/intel_lvds.c` and `i915_params.c/.h`, under `CONFIG_IGEL_I915_DISABLE_LVDS_MODULE_OPTION`. Unlike several neighboring consumers, this test has no `_I915_PARAMS_H_` condition. Shared hunks register the other IGEL i915 parameters under their own guards.

**Reason / limits:** The preamble cites misdetection and says LVDS is enabled by default. No initializer establishing a nonzero `lvds` default is shown in this diff. The runtime behavior of zero is clear; the advertised default is not established by this member alone.

**Declared source:** IGEL; No reference supplied

<a id="patch-066"></a>

### `IGEL/CONFIG_IGEL_I915_DISABLE_TV_MODULE_OPTION.diff`

**Change:** `intel_tv_init()` in `drivers/gpu/drm/i915/display/intel_tv.c` returns before the subsequent TV-output sanity check when `i915_modparams.tv` is zero, logging that integrated TV is disabled. `i915_params.c` registers an integer `tv` parameter with permission `0444`. This prevents TV initialization, rather than merely changing detection results on an already-created connector.

**Scope:** The include and early return use `CONFIG_IGEL_I915_DISABLE_TV_MODULE_OPTION`. The member also carries a shared parameter-registration block for LVDS, eDP-as-DP, DP link-rate limits, DP/HDMI audio suppression, M250C color range and reversed enumeration, each under its own guard. `i915_params.h` starts a conditional around `I915_PARAMS_FOR_EACH` when none of these options are enabled.

**Reason / limits:** The preamble cites TV misdetection and says TV remains enabled by default. This diff does not include the `tv` field/default definition or the matching alternative parameter macro; the declared default is not established by this member alone.

**Declared source:** IGEL; No reference supplied

<a id="patch-067"></a>

### `IGEL/CONFIG_IGEL_I915_DP_DETECT_WORKAROUND.diff`

**Change:** Adds a flag and timestamp to `struct intel_dp`. `intel_dp_detect()` retains ordinary eDP detection; for non-eDP, a false `intel_digital_port_connected()` result can still lead to DPCD detection if the flag is set and at most 900 ms have elapsed. Detection then clears the flag. Connector initialization clears it and initializes the timestamp. `intel_dp_start_link_train()` sets both before the visible training attempt.

**Scope:** Changes `intel_display_types.h`, `intel_dp.c` and `intel_dp_link_training.c`, guarded by `CONFIG_IGEL_I915_DP_DETECT_WORKAROUND`. The training hunk additionally contains the independently guarded retry behavior described in the next member: an extra training attempt and a 50–200 ms sleep on failure.

**Reason / limits:** Samsung U28D590D wake-up latency is the stated rationale. Contrary to the preamble and comment, the flag is set before training, not after demonstrated success; the diff does not condition it on `passed`. It allows a DPCD probe rather than forcibly reporting connected. The shared training hunk is duplicated in the retry member and needs coordinated application.

**Declared source:** IGEL; No reference supplied

<a id="patch-068"></a>

### `IGEL/CONFIG_IGEL_I915_DP_RETRY_LINK_TRAINING.diff`

**Change:** Inserts an additional initial attempt in `intel_dp_start_link_train()` in `intel_dp_link_training.c`: prepare the link, run either UHBR `intel_dp_128b132b_link_train()` or ordinary `intel_dp_link_train_all_phys()`, and return immediately on success. Failure sleeps via `usleep_range(50000, 200000)` before falling through to the existing prepare/train path.

**Scope:** The attempt uses `CONFIG_IGEL_I915_DP_RETRY_LINK_TRAINING`; there is no monitor-specific match or runtime parameter in this member. The same hunk also sets the detection-workaround flag/timestamp under `CONFIG_IGEL_I915_DP_DETECT_WORKAROUND`, requiring that option's fields.

**Reason / limits:** The preamble describes retrying after DPMS ON. No explicit sink-power/DPMS-ON call is added here, so that aspect cannot be confirmed from the added code. Success takes an early return instead of the original function tail, whose complete effects are not included. This is the identical training hunk visible in the preceding patch, not a separate second retry to stack blindly.

**Declared source:** IGEL; No reference supplied

<a id="patch-069"></a>

### `IGEL/CONFIG_IGEL_I915_EDP_IS_DP_MODULE_OPTION.diff`

**Change:** `_intel_dp_is_port_edp()` returns false when `i915_modparams.edp_is_dp == 1`, after rejecting display versions below 5 and before the existing port/platform eDP tests. This provides a global override of eDP classification, not a per-connector reclassification table. `i915_params.c` registers the boolean `edp_is_dp` parameter with permission `0444`.

**Scope:** `intel_dp.c` conditionally includes `i915_drv.h`; the actual override requires both `CONFIG_IGEL_I915_EDP_IS_DP_MODULE_OPTION` and `_I915_PARAMS_H_`. The member repeats parameter registrations for seven other guarded i915 options and starts the shared conditional around `I915_PARAMS_FOR_EACH` in `i915_params.h`.

**Reason / limits:** The preamble says some devices expose embedded DP as ordinary DP; the comment specifically cites hotplug trouble and failed automatic detection. No device whitelist, parameter field/default definition, or completed alternative parameter macro is supplied here. Thus a default cannot be inferred solely from the boolean registration. The TV member contains overlapping shared hunks, so these are not independent, freely composable additions.

**Declared source:** IGEL; No reference supplied

<a id="patch-070"></a>

### `IGEL/CONFIG_IGEL_I915_H830_CHANGE_CONNECTOR_ORDER.diff`

**Change:** Adds a dedicated Valleyview/H830C branch in `intel_setup_outputs()` in `intel_display.c`. It initializes optional CRT, then DP/HDMI on port C before port B, and finally DSI, bypassing the normal Valleyview/Cherryview branch. DP initialization and VBT port presence still determine whether HDMI initialization is appropriate.

**Scope:** Requires `CONFIG_IGEL_I915_H830_CHANGE_CONNECTOR_ORDER`, `_I915_DRV_H_`, `IS_VALLEYVIEW(dev_priv)` and `IS_IGEL_H830C`. The platform macro/state must be provided elsewhere; the Wyse member visibly supplies its guarded header declaration but not the detection implementation.

**Reason / limits:** The comment says H830C PCB connector ordering gives its DVI output a different HDMI number than H820C, potentially swapping monitors during migration. The change controls initialization order, not a direct user-visible connector rename. Actual numbering and correct H830C identification remain dependent on the surrounding driver and hardware-detection support.

**Declared source:** IGEL; No reference supplied

<a id="patch-071"></a>

### `IGEL/CONFIG_IGEL_I915_WYSE_3040_DP_QUIRK.diff`

**Change:** Adds a quirk callback in `intel_quirks.c` that calls `intel_set_quirk(display, QUIRK_SKIP_DP_DPMS_D3)` and logs its application, plus a table match for GPU `0x22b0` and Dell subsystem `0x1028:0x07c1`. `i915_drv.h` defines `QUIRK_SKIP_DP_DPMS_D3` as `(1<<15)`. The member also adds an Apple MacBookPro15,1 match (`0x3e9b`, `0x106b:0x0176`) and callback setting `QUIRK_DDI_A_FORCE_4_LANES` under a separate Apple guard.

**Scope:** The Dell callback/table require `CONFIG_IGEL_I915_WYSE_3040_DP_QUIRK` and `_I915_DRV_H_`; the header definition requires the Wyse option. Apple additions use `CONFIG_IGEL_APPLE_GMUX`. A further shared header hunk declares H830C/TC215B platform state under `CONFIG_IGEL_ADD_I915_HW_DETECTION`.

**Reason / limits:** The Dell rationale is avoiding DP D3 transitions that prevent some E-series monitors waking. This member sets a flag but does not show a DP power-transition consumer or corresponding quirk-enum integration. Therefore “do not use DPMS” is broader than the demonstrated change. Apple lane forcing is an additional, separately gated behavior.

**Declared source:** IGEL; No reference supplied

<a id="patch-072"></a>

### `IGEL/CONFIG_IGEL_KEYCODES.diff`

**Change:** Inserts an alternate 256-entry `x86_keycodes` lookup table in `drivers/tty/vt/keyboard.c`, preserving the low identity-mapped range and specifying mappings for higher input-key indices. For example, indices 85 and 89 map to 118 and 115 in the new table. The ordinary table begins under an added `#else`.

**Scope:** Selection is compile-time through `CONFIG_IGEL_KEYCODES`; there is no keyboard VID/PID filter or runtime switch in the member. The change concerns VT keyboard translation rather than a USB HID descriptor.

**Reason / limits:** The preamble mentions unspecified special keyboards. It does not identify models or explain individual remappings.

**Declared source:** IGEL; No reference supplied

<a id="patch-073"></a>

### `IGEL/CONFIG_IGEL_KYOCERA_USB_SET_INTF_QUIRK.diff`

**Change:** Adds USB device `0x0482:0x0392` to `usb_quirk_list` with `USB_QUIRK_NO_SET_INTF` in `drivers/usb/core/quirks.c`. This supplies the existing USB-core quirk flag rather than implementing a new printer protocol.

**Scope:** The entry is compiled only with `CONFIG_IGEL_KYOCERA_USB_SET_INTF_QUIRK`; its comment identifies the Kyocera FS-1350DN. Matching is by USB vendor/product, with no revision range or module parameter added.

**Reason / limits:** Both preamble and comment report that the printer otherwise prints nothing. The member does not include the consumer of `USB_QUIRK_NO_SET_INTF`, failed USB traces, or a narrower condition distinguishing affected firmware revisions.

**Declared source:** IGEL; No reference supplied

<a id="patch-074"></a>

### `IGEL/CONFIG_IGEL_LENOVO_M600_SOUND_FIXES.diff`

**Change:** Adds an ALC233 fixup that, at `HDA_FIXUP_ACT_BUILD`, renames node `0x19`'s `Mic Jack` control to `Headset Mic Jack`. It adds fixup ID/table registration and the explicit model name `lenovo-m600` in Realtek `alc269.c`. Helpers traverse jack controls to find the old name. To expose their layout, `struct snd_jack_kctl` is added to `include/sound/jack.h` and its old definition in `sound/core/jack.c` starts being conditionally suppressed.

**Scope:** Lenovo behavior uses `CONFIG_IGEL_LENOVO_M600_SOUND_FIXES`. Shared struct/helpers compile with either that option or `CONFIG_IGEL_OWN_DEVICE_SOUND_FIXES`. `alc662.c` also includes separately guarded IGEL helpers for microphone gain limiting and UD9/H830/M340C control renaming, repeated in the own-device member.

**Reason / limits:** The generic “sound fix” preamble is concretely a jack-control naming correction in the Lenovo-specific path, not a shown routing or gain fix. No automatic Lenovo PCI/DMI match is added; explicit model selection is the visible entry point. The `jack.c` conditional closure is absent from this member. Repeated helper hunks need coordinated application.

**Declared source:** IGEL; No reference supplied

<a id="patch-075"></a>

### `IGEL/CONFIG_IGEL_LG_AIO_MIC_FIXES.diff`

**Change:** Adds Realtek ALC256 fixups in `sound/hda/codecs/realtek/alc269.c`. At pre-probe, `alc_fixup_lg_headphone()` clears node `0x19`'s input-amplifier capability, writes coefficient `0x1b = 0x0a4b`, adjusts coefficient `0x47` timing bits, and overrides node `0x08` input-amplifier capabilities with offset `0x1f`, steps `0x37`, step size `0x02` and mute support. A pin fixup writes node `0x19 = 0x04a11030` and `0x21 = 0x411111f0`, chained to that function.

**Scope:** All additions use `CONFIG_IGEL_LG_AIO_MIC_FIXES`. The new PCI subsystem entry `0x1854:0x0345`, labeled LG CL66 AIO, selects **existing** `ALC256_FIXUP_ASUS_MIC_NO_PRESENCE`, not either new LG fixup.

**Reason / limits:** The preamble cites a nonworking microphone. The new low-level fixups are defined, but this member does not connect them to the new device match or a model name. The demonstrated automatic effect is selection of the ASUS-named fixup; asserting that the added LG coefficient/pin changes run on CL66 would overstate the evidence. Commented-out coefficient/capability tests are not executed.

**Declared source:** IGEL; No reference supplied

<a id="patch-076"></a>

### `IGEL/CONFIG_IGEL_LG_LIMIT_VOLUME.diff`

**Change:** `snd_hda_mixer_amp_volume_info()` in `sound/hda/common/codec.c` reports the control maximum as `get_amp_max_value(...) - 11` for amplifier node `0x03` when DMI system vendor equals `LG Electronics`. Other nodes/vendors retain the original maximum.

**Scope:** `CONFIG_IGEL_LG_LIMIT_VOLUME` controls the DMI include and branch. Matching is vendor-wide, not tied to a particular LG product, codec ID or direction beyond the control's existing `dir` value.

**Reason / limits:** The preamble requests maximum-volume limiting. The shown effect changes ALSA control metadata; it does not add a separate clamp to the value-write path. Eleven is a count of control steps here, not a demonstrated decibel limit, and the diff adds no lower-bound check before subtracting.

**Declared source:** IGEL; No reference supplied

<a id="patch-077"></a>

### `IGEL/CONFIG_IGEL_LIMIT_BAYTRAIL_C_STATES.diff`

**Change:** Adds `CPUIDLE_FLAG_UNUSABLE` to the Bay Trail `byt_cstates[]` entries `C6N` (`MWAIT 0x58`) and `C6S` (`MWAIT 0x52`) in `drivers/idle/intel_idle.c`, retaining their existing MWAIT and TLB-flushed flags.

**Scope:** Both changes require `CONFIG_IGEL_LIMIT_BAYTRAIL_C_STATES`. They affect those two entries in the Bay Trail idle table rather than all Intel CPUs, and no runtime parameter is added.

**Reason / limits:** Comments target J1900 freezes and say the patch was taken from [kernel Bugzilla issue 109051, comment 865](https://bugzilla.kernel.org/show_bug.cgi?id=109051#c865), adding public attribution beyond the preamble's IGEL source label. The preamble's “C states below 5” is misleading: the shown code marks C6 variants unusable; it does not change C1–C5 entries or set a universal numerical C-state threshold. Reliability improvement is the stated objective, not a tested outcome here.

**Declared source:** IGEL; No reference supplied

<a id="patch-078"></a>

### `IGEL/CONFIG_IGEL_LVDS_CONNECTED_ON_TC215.diff`

**Change:** Before returning from `intel_sdvo_detect()` in `intel_sdvo.c`, replaces a nonconnected result with `connector_status_connected` when the SDVO response contains `SDVO_LVDS_MASK` and the connector's VBT SDVO-LVDS mode pointer is non-NULL, logging the available VBT mode.

**Scope:** The branch is compiled with `CONFIG_IGEL_LVDS_CONNECTED_ON_TC215`. Despite the name, the added code has no TC215 DMI/platform test: the response mask and VBT-mode presence are the visible runtime gates.

**Reason / limits:** The preamble attributes incorrect LVDS connected-state detection to TC215 hardware; the comment mentions dual-monitor support. The implementation uses VBT mode availability as grounds to override detection and may apply to other matching SDVO LVDS connectors. It does not add or validate the VBT mode itself.

**Declared source:** IGEL; No reference supplied

<a id="patch-079"></a>

### `IGEL/CONFIG_IGEL_M340C_DVI_VGA_SPLIT_QUIRKS.diff`

**Change:** In `radeon_atom_apply_quirks()`, GPU `0x9854` with subsystem `0x1002:0x9854` can set the global platform to M340C when DMI board name contains `M340C`. For that platform, a DisplayPort connector supported as `ATOM_DEVICE_DFP2_SUPPORT` becomes DVI-D. In `radeon_dvi_detect()`, an analog EDID on M340C is treated like a shared-DDC conflict: EDID is freed, status becomes disconnected and the function exits.

**Scope:** These branches use `CONFIG_IGEL_M340C_DVI_VGA_SPLIT_QUIRKS` and rely on `IS_IGEL_M340C`/`igel_platform`, visibly provided by the Radeon-detection member. A repeated, independently guarded Fujitsu branch rejects VGA for device `0x9805`, subsystem `0x1734:0x11bd`, when board name contains `D3003-S1`.

**Reason / limits:** The M340C objective is working DVI/VGA split output, but this member changes connector interpretation/detection rather than itself creating two connectors. The Fujitsu comment mentions D3003-S2, while its actual board-name condition is S1. DMI includes and `product` declaration also depend on companion support visible elsewhere in this scope.

**Declared source:** IGEL; No reference supplied

<a id="patch-080"></a>

### `IGEL/CONFIG_IGEL_MARK_MMC_SD_CARD_REMOVEABLE.diff`

**Change:** `mmc_blk_alloc_req()` in `drivers/mmc/core/block.c` sets `GENHD_FL_REMOVABLE` on the allocated disk when `card->type` is `MMC_TYPE_SD_COMBO`, `MMC_TYPE_SD` or `MMC_TYPE_SDIO`.

**Scope:** This is compiled under `CONFIG_IGEL_MARK_MMC_SD_CARD_REMOVEABLE`; there is no laptop, host-controller or physically removable-slot check. It changes block-disk metadata, not card-removal handling.

**Reason / limits:** The preamble says the automounter relies partly on this flag and acknowledges false positives. More precisely, the added predicate names SD-family types, not `MMC_TYPE_MMC`; internal SD-type media satisfying it can be labeled removable. Whether an SDIO card reaches this block-allocation path is not demonstrated by the member.

**Declared source:** IGEL; No reference supplied

<a id="patch-081"></a>

### `IGEL/CONFIG_IGEL_MICROTOUCH_USB_RESUME_QUIRK.diff`

**Change:** Adds `USB_QUIRK_RESET_RESUME` for USB `0x0596:0x051e` in `drivers/usb/core/quirks.c`, labeled a MicroTouch Systems touchscreen.

**Scope:** The entry is guarded by `CONFIG_IGEL_MICROTOUCH_USB_RESUME_QUIRK`. It uses an exact vendor/product match, without device-revision filtering, a runtime switch or changes to touchscreen event parsing.

**Reason / limits:** The preamble asks for reset/resume handling, and the observed change assigns that existing core quirk. No failing resume sequence or USB-core reset-resume implementation is included, so this member establishes device selection but not the exact reset timing or a verified recovery result.

**Declared source:** IGEL; No reference supplied

<a id="patch-082"></a>

### `IGEL/CONFIG_IGEL_NO_TIMESTAMP_WARNING.diff`

**Change:** Inserts `#ifndef CONFIG_IGEL_NO_TIMESTAMP_WARNING` at the start of `mnt_warn_timestamp_expiry()` in `fs/namespace.c`, before its superblock declaration and existing readonly-mount test. The intended selection excludes the warning body when the option is enabled.

**Scope:** This is a compile-time logging change in mount handling, with no filesystem or device-specific parameter added.

**Reason / limits:** The preamble explicitly targets “supports timestamp until 2038” warnings. It does not extend filesystem timestamp ranges or fix timestamp storage. The entire archived member ends during the original condition and supplies no matching `#endif`; therefore the intended suppression is evident, but a complete self-contained function/build cannot be reconstructed from this diff alone.

**Declared source:** IGEL; No reference supplied

<a id="patch-083"></a>

### `IGEL/CONFIG_IGEL_OWN_DEVICE_SOUND_FIXES.diff`

**Change:** Adds Realtek ALC662 fixups: UD9 disables EAPD on node `0x14`, renames Front controls to Speaker (or Master to PCM for the commented old-BIOS case), and renames node `0x09` capture controls to Alt Capture. H830 renames rear line-out controls/jack to Headphone. Both chain to input-capability overrides limiting node `0x18` mic-boost steps and node `0x0b` mic-playback gain. M340C relabels Speaker controls as Alt Speaker and Headphone controls as Speaker. ALC256 initialization detects IGEL M350C/M250C and sets a new global `igel_thin_clients` value.

**Scope:** Main guard is `CONFIG_IGEL_OWN_DEVICE_SOUND_FIXES`; shared jack layout/helpers also accept the Lenovo option. ALC662 subsystem matches are `0x8086:0x27d8` (UD9) and `0x8086:0x7270` (H830); explicit models include `igel-ud9` and `igel-m340c`. The integer parameter `igel_thin_clients`, permission `0644`, starts at `IGEL_OFF` (0); enum values are M350=1 and M250=2.

**Reason / limits:** Comments explain noisy microphone boost and control naming. Despite its parameter description promising a reboot-microphone fix, this member shows no consumer of `igel_thin_clients` beyond detection/assignment. Several hunks duplicate the Lenovo patch; `jack.c`'s conditional closure is not supplied.

**Declared source:** IGEL; No reference supplied

<a id="patch-084"></a>

### `IGEL/CONFIG_IGEL_PCIEAER_DISABLE.diff`

**Change:** Initializes the existing `pcie_aer_disable` flag to 1 rather than its implicit zero default in `drivers/pci/pcie/aer.c` when the IGEL option is enabled.

**Scope:** Selection uses `CONFIG_IGEL_PCIEAER_DISABLE`. There is no per-device match or new runtime parameter: the change alters the PCIe AER subsystem's initial disable policy globally.

**Reason / limits:** The preamble and comment cite excessive syslog messages; the comment supplies a linux-pci mailing-list URL. This is not merely filtering selected messages: it changes the disable flag used by existing AER code. The member does not show all flag consumers or subsequent overrides, so exact loss of reporting/recovery behavior requires those surrounding paths.

**Declared source:** IGEL; No reference supplied

<a id="patch-085"></a>

### `IGEL/CONFIG_IGEL_RADEON_DETECTION.diff`

**Change:** Introduces global `igel_platform`, initially `NO_IGEL_PLATFORM`, with M340C and Samsung TC2 enum values/macros in `radeon_drv.h`. During `radeon_module_init()`, DMI product/vendor substrings select TC2 for `TC2` plus `Samsung Electronics Co., Ltd`, or M340C for `M340C` plus `IGEL Technology GmbH`. Adds guarded DMI/driver-header includes and a `product` declaration for connector quirks.

**Scope:** Core additions require `CONFIG_IGEL_RADEON_DETECTION`; matching occurs only while the platform remains unclassified. State is module-global, not per PCI device. Shared hunks also add the independently guarded, default-zero DP/DVI probe-workaround variable, the LVDS-disable early return under its own guard, and Samsung PCI include.

**Reason / limits:** This is identification infrastructure for the M340C and Samsung connector changes in this batch, not a complete display repair by itself. The M340C member can additionally classify by board name and PCI tuple. The helpers' definitions are guarded, making configuration combinations material; no Kconfig dependency declarations are present in this member.

**Declared source:** IGEL; No reference supplied

<a id="patch-086"></a>

### `IGEL/CONFIG_IGEL_RADEON_DP_DVI_ADAPTER_PROBE_WORKAROUND.diff`

**Change:** Adds integer `dp_dvi_probe_workaround`, default 0, permission `0644`. In `radeon_dp_detect()`, nonzero enables special handling for DisplayPort connectors whose sink type is not native DisplayPort. When DPMS is OFF, it retains `connector->status` and exits. Otherwise it waits 200 ms, frees cached EDID and tries non-AUX DDC; success reports connected, updates scratch registers, reloads EDID, optionally detects audio and exits. Probe failure falls through to the existing path.

**Scope:** Guarded by `CONFIG_IGEL_RADEON_DP_DVI_ADAPTER_PROBE_WORKAROUND` across `radeon.h`, `radeon_drv.c` and `radeon_connectors.c`. Audio refresh additionally requires nonzero `radeon_audio` and an encoder. There is no adapter/monitor whitelist. The global-variable hunk also repeats Radeon-platform state under its separate guard.

**Reason / limits:** The preamble cites adapters/monitors losing readable EDID while off. Retaining status can defer recognizing a real unplug while DPMS is OFF; it does not guarantee EDID availability. Any nonzero integer activates the branch, although the description presents 1/0 semantics. The default is actually shown, unlike several other parameter patches.

**Declared source:** IGEL; No reference supplied

<a id="patch-087"></a>

### `IGEL/CONFIG_IGEL_RADEON_FIX_CONNECTOR_STATUS.diff`

**Change:** In `radeon_connector_hotplug()`, sets forced connector status to connected only for `DRM_FORCE_ON`, otherwise disconnected, invokes the force callback and clears EDID property for disconnected status. In native-DP hotplug needing training, invokes detection if status is not connected. `radeon_dvi_detect()` retries a missing EDID after 500 ms. Native-DP detection with asserted HPD retries failed DPCD retrieval after 200 ms and reports disconnected if both attempts fail.

**Scope:** All changes are in `radeon_connectors.c` under `CONFIG_IGEL_RADEON_FIX_CONNECTOR_STATUS`, with no board whitelist or runtime option. The extra DP hotplug detection also requires native sink type, sensed HPD and a training need.

**Reason / limits:** The preamble generically targets incorrect connection state; comments mention DPMS wake-up and missing DPCD. The hotplug detection result is logged in `new_status` but never assigned to `connector->status` by the addition. Also, the force branch does not explicitly handle `DRM_FORCE_ON_DIGITAL` as connected. These details matter when assessing the broad claim that connector status is “fixed.”

**Declared source:** IGEL; No reference supplied

<a id="patch-088"></a>

### `IGEL/CONFIG_IGEL_RADEON_FIX_CURSOR_DISAPPEAR.diff`

**Change:** Initializes CRTC cursor registers using `radeon_crtc_cursor_set2(..., NULL, 0, ...)` at the end of `radeon_crtc_init()`. During `radeon_resume_kms()` with `notify_clients` true, after forced mode restoration, resets each present Radeon CRTC cursor via `radeon_cursor_reset()`.

**Scope:** Cursor additions in `radeon_display.c` and `radeon_device.c` require `CONFIG_IGEL_RADEON_FIX_CURSOR_DISAPPEAR`. The resume hunk also clears `detected_by_load` on split-DVI connectors under the separate `CONFIG_IGEL_RADEON_SPLIT_DVII` guard, overlapping that member.

**Reason / limits:** The stated aim is incorrect cursor visibility, mostly after suspend/resume. The demonstrated intervention is cursor initialization/reinitialization, not new cursor-plane selection logic. Resume resetting is skipped when `notify_clients` is false; no GPU-specific match or runtime switch narrows the cursor change.

**Declared source:** IGEL; No reference supplied

<a id="patch-089"></a>

### `IGEL/CONFIG_IGEL_RADEON_LVDS_SWITCH.diff`

**Change:** Adds integer `radeon_lvds = 1` and read-only (`0444`) module parameter `lvds`. `radeon_atom_apply_quirks()` returns false for LVDS connectors when the parameter equals zero, preventing those connectors being added through this AtomBIOS path.

**Scope:** Requires `CONFIG_IGEL_RADEON_LVDS_SWITCH`; touches `radeon.h`, `radeon_atombios.c` and `radeon_drv.c`. It is not device-specific. Shared hunks also declare/register default-enabled `split_dvii` under `CONFIG_IGEL_RADEON_SPLIT_DVII` and provide a guarded DMI-product declaration.

**Reason / limits:** The preamble compares this to the TV-enable parameter. Its observable semantics are zero disables, nonzero permits the existing connector path, with default 1 explicitly shown. It is an initialization-time connector omission, not a writable runtime panel-power toggle, and no change to legacy non-Atom connector creation is included.

**Declared source:** IGEL; No reference supplied

<a id="patch-090"></a>

### `IGEL/CONFIG_IGEL_RADEON_SINK_POWER_ON_QUIRK.diff`

**Change:** Adds `radeon_dp_sink_power_on()` in `atombios_dp.c`, writing `DP_SET_POWER_D0` to `DP_SET_POWER` through the connector AUX channel. It attempts up to three writes, stopping when the returned byte count is 1 and sleeping 1 ms after a failed attempt. Calls are inserted before sink-type lookup and before the link-training lane-capability read.

**Scope:** All additions require `CONFIG_IGEL_RADEON_SINK_POWER_ON_QUIRK`. There is no device whitelist, module parameter, DPCD-version test or explicit power-state-support check in the added helper.

**Reason / limits:** The preamble aims to make EDID/link data available in corner cases. Its “if the sink supports” phrasing is not implemented as a capability gate here: writes are attempted and failure is silently tolerated. The function does not propagate an error or guarantee a powered/ready sink before probing continues.

**Declared source:** IGEL; No reference supplied

<a id="patch-091"></a>

### `IGEL/CONFIG_IGEL_RADEON_SPLIT_DVII.diff`

**Change:** Changes AtomBIOS supported-device parsing to retain complementary digital/analog BIOS entries separately rather than merge them when `split_dvii` is nonzero. Both intermediate connector types are set to DVI-I and carry `splitted_dvii`, with digital HPD copied across. The flag extends connector structures and `radeon_add_atom_connector()` signatures/calls, bypasses same-ID merging/shared-DDC marking for split entries, and filters detected EDID type against CRT/DFP support. Connected analog outputs previously detected by load skip destructive polling; resume clears that cached load-detection state.

**Scope:** Main guard is `CONFIG_IGEL_RADEON_SPLIT_DVII`; integer parameter `split_dvii` defaults to 1 with permission `0444`. Changes span `radeon.h`, `radeon_atombios.c`, `radeon_connectors.c`, `radeon_device.c`, `radeon_drv.c` and `radeon_mode.h`. Object-table calls pass a zero split flag. Shared hunks include independently guarded Samsung shared-DDC and cursor-resume additions.

**Reason / limits:** The aim is simultaneous analog/digital use through a split cable without analog polling blackouts. The preamble's “DVI-D and VGA” is not literal registration in the shown parsing: both are tagged DVI-I and distinguished by support flags. Samsung code writes `dvii_shared`, declared under the split guard, making their configuration relationship significant. No dependency declarations are supplied.

**Declared source:** IGEL; No reference supplied

<a id="patch-092"></a>

### `IGEL/CONFIG_IGEL_RALINK_ONE_ANTENNA_QUIRK.diff`

**Change:** Extends rt2800 USB with read-only `noht` (boolean, initially false) and `chain_num` (integer, initially -1) parameters and optional library callbacks. A positive chain override replaces both EEPROM TX/RX chain counts. With fewer than two TX chains, initialization uses `DATA_FRAME_SIZE` rather than `AGGREGATION_SIZE`, and AMPDU capability is advertised only above one TX chain. HT can be disabled by callback for non-RF2020 devices; RF2020 remains without HT. TX-power calculation uses `chan->max_reg_power` instead of `max_power` and adds a positive-delta branch setting `power_ctrl = 3`, subtracting six from delta.

**Scope:** `CONFIG_IGEL_RALINK_ONE_ANTENNA_QUIRK` guards changes in `rt2800lib.c`, `rt2800lib.h` and `rt2800usb.c`. Optional callback absence returns false for HT suppression and -1 for chain override, preserving EEPROM selection for other backends. Power and aggregation changes are library-wide, not USB-ID-specific.

**Reason / limits:** Comments cite one-antenna aggregation and TX-power control. No added upper-bound validation limits a positive `chain_num`, and the member supplies no register documentation establishing a physical dBm meaning for `power_ctrl = 3`. Single-chain handling disables aggregation even without explicitly setting the new parameter when EEPROM already reports one chain.

**Declared source:** IGEL; No reference supplied

<a id="patch-093"></a>

### `IGEL/CONFIG_IGEL_REPLACE_UNKNOWN_BATTERY_STATE_WITH_NOT_CHARGING.diff`

**Change:** Selects `POWER_SUPPLY_STATUS_NOT_CHARGING` unconditionally for the final fallback in ACPI battery status reporting when the IGEL option is enabled. Earlier charging, discharging and charged/full decisions remain ahead of it. When the option is disabled, the added alternate path reports Not Charging only when a new DMI quirk flag is set; otherwise it reports Unknown. A Lenovo/ThinkPad DMI callback sets that flag.

**Scope:** All changes are in `drivers/acpi/battery.c`. `CONFIG_IGEL_REPLACE_UNKNOWN_BATTERY_STATE_WITH_NOT_CHARGING` removes the need for the quirk flag/callback/table entry; those additions compile only when it is absent.

**Reason / limits:** The preamble advocates a more useful label for inactive, nonfull batteries. This changes reported status, not actual charging behavior or ACPI state acquisition. Compared with the shown original fallback, even the option-disabled build gains new Lenovo-specific behavior. Other unknown/error-producing paths outside this final fallback are not addressed.

**Declared source:** IGEL; No reference supplied

<a id="patch-094"></a>

### `IGEL/CONFIG_IGEL_SAMSUNG_TC2_DVI_VGA_QUIRK.diff`

**Change:** During `radeon_add_atom_connector()`, a VGA candidate on GPUs `0x9856`/`0x9851` with subsystem `0x1022:0x1234`, or on `IS_SAMSUNG_TC2`, checks for an already-added DVI-I connector. If found, it sets `dvii_shared`. The shared-DDC comparison is extended to accept that flag, marking connectors as sharing DDC even if their recorded bus IDs differ.

**Scope:** Samsung recognition uses `CONFIG_IGEL_SAMSUNG_TC2_DVI_VGA_QUIRK`; `IS_SAMSUNG_TC2` comes from the Radeon-detection support. Critically, `dvii_shared` is declared and its extended comparison compiled under `CONFIG_IGEL_RADEON_SPLIT_DVII`, not the Samsung guard. The member also repeats the split option's same-ID merge exemption.

**Reason / limits:** The rationale is avoiding duplicate VGA detection for a DVI monitor on NC241, NC221 and TC2. It does not directly suppress VGA creation: it changes shared-DDC state used by existing detection logic and depends on DVI-I already being enumerated. The shown guards imply companion configuration requirements; with Samsung alone, the added assignments reference a declaration not compiled by that guard.

**Declared source:** IGEL; No reference supplied

<a id="patch-095"></a>

### `IGEL/CONFIG_IGEL_SPLASH_FIX.diff`

**Change:** Adds vgacon boot parsing for `splash=` (integer, initially 0) and `no_igel_splash_fix` (sets it to -1). `vgacon_startup()` skips VGA setup when `splash_mode > 0`. Separately, fbcon starts `igel_splash_fix = 1`; its active-console test suppresses rendering for foreground VT0 until that VT is observed in `KD_GRAPHICS`, at which point it clears the flag and logs removal.

**Scope:** Both files, `drivers/video/console/vgacon.c` and `drivers/video/fbdev/core/fbcon.c`, use `CONFIG_IGEL_SPLASH_FIX`. The fbcon helper applies only to VT0 when it is foreground and its display-foreground pointer matches. It logs initial suppression once by changing the flag from 1 to 2.

**Reason / limits:** The preamble seeks to preserve the bootloader splash until X/DRM takes over. The shown fbcon removal condition is graphics-mode observation, not DRM driver load. Moreover, the `no_igel_splash_fix` parser changes only vgacon's variable; it does not clear fbcon's separate flag. Thus claiming that this boot option disables both halves, or that suppression requires `splash=` in fbcon, would be inaccurate.

**Declared source:** IGEL; No reference supplied

<a id="patch-096"></a>

### `IGEL/CONFIG_IGEL_SSB_B43_PCI_PREFER_BROADCOM_STA.diff`

**Change:** Omits Broadcom PCI IDs `0x4311`, `0x4312`, `0x4315`, `0x4328`, `0x4329`, `0x432b` and `0x432c` from `b43_pci_bridge_tbl` in `drivers/ssb/b43_pci_bridge.c` when the option is enabled. Neighboring bridge matches remain present.

**Scope:** The removals are implemented as `#ifndef CONFIG_IGEL_SSB_B43_PCI_PREFER_BROADCOM_STA` around two ID groups. They operate by device ID across matching Broadcom hardware, not by IGEL DMI or a user-selectable preference switch.

**Reason / limits:** The preamble favors the Broadcom STA driver, and comments mention a bcm943224hms adapter in UDC2. The actual effect is removing SSB bridge matching for the listed IDs. It neither adds STA support nor loads/enables that driver; availability and successful alternate binding are outside this member.

**Declared source:** IGEL; No reference supplied

<a id="patch-097"></a>

### `IGEL/CONFIG_IGEL_TC236_TOUCH_QUIRK.diff`

**Change:** In `hidinput_hid_event()` in `drivers/hid/hid-input.c`, suppresses the final `input_event()` for XAT vendor / XAT CSR product when `usage->type == EV_ABS` and `value == 0`, issuing a HID debug message instead. Other events retain the original call.

**Scope:** Guarded by `CONFIG_IGEL_TC236_TOUCH_QUIRK`. The member uses existing symbolic IDs rather than supplying their numeric definitions. It filters all matching zero-valued absolute usages, without restricting the axis code or interpreting whether a report is otherwise empty.

**Reason / limits:** The preamble describes empty HID events from TC236. The predicate is narrower in device selection but broader in event meaning: it also discards legitimate zero absolute coordinates/values if emitted by that device. It does not drop the entire HID report or change earlier MSC_SCAN handling.

**Declared source:** IGEL; No reference supplied

<a id="patch-098"></a>

### `IGEL/CONFIG_IGEL_THINKPAD_RFKILL_MODULE_PARAM.diff`

**Change:** Adds boolean `wwan_rfkill`, `wlan_rfkill` and `bluetooth_rfkill`, all initially true, with permission `0444`. Setting one false makes its corresponding ThinkPad status getter report `TPACPI_RFK_RADIO_ON` instead of consulting the subsequent switch/status logic. WLAN still first returns `-ENODEV` if the driver lacks `hotkey_wlsw`. The WWAN hunk also adds a separately guarded DMI override for Lenovo ThinkPad L480.

**Scope:** Parameter additions and bypasses in `drivers/platform/x86/lenovo/thinkpad_acpi.c` require `CONFIG_IGEL_THINKPAD_RFKILL_MODULE_PARAM`. The L480 branch uses `CONFIG_IGEL_FIX_WWAN_RFKILL_FOR_THINKPAD_L480`, matching vendor/version substrings `LENOVO` and `ThinkPad L480`.

**Reason / limits:** The preamble describes falsely detected switches leaving radios blocked. The implementation changes reported status; it does not remove rfkill objects or demonstrate an actual radio-power command. The parameters are read-only after loading through the shown permissions. Their names can mislead: false bypasses switch reporting, while true preserves it; no particular ThinkPad model limits the parameter-based bypass.

**Declared source:** IGEL; No reference supplied

<a id="patch-099"></a>

### `IGEL/CONFIG_IGEL_TI_TUSB73X0_XHCI_QUIRK.diff`

**Change:** Adds a fallback in `quirk_usb_handoff_xhci()` after the existing halt handshake times out. For TI xHCI device `0x8241`, it saves PCI USB-control register `0xe0`, disables ports by OR-ing `0xf00`, requests light host-controller reset through command bit 7, waits on reset/readiness, retries the halt handshake and restores the saved port-control value. It logs controller status; the original halt warning appears if the helper returns nonzero.

**Scope:** `drivers/usb/host/pci-quirks.c`, guarded by `CONFIG_IGEL_TI_TUSB73X0_XHCI_QUIRK`. The helper explicitly requires xHCI class, TI vendor and the device ID; other controllers return 1 and retain warning behavior. It is a firmware-handoff recovery attempt, not every runtime xHCI halt.

**Reason / limits:** Comments say it restores an older-kernel workaround. The preamble's negative wording is internally confusing; observed intent is recovery after a failed halt. Intermediate handshake results are overwritten, not individually checked; only the final halt result determines success. The comment promises a five-second readiness wait, but the shown numeric handshake arguments are `5000, 10`, so that prose should not be used as a verified duration.

**Declared source:** IGEL; No reference supplied

<a id="patch-100"></a>

### `IGEL/CONFIG_IGEL_TOUCHSCREEN_EGALAX_REPT2.diff`

**Change:** Extends eGalax packet handling in `drivers/input/touchscreen/usbtouchscreen.c` to accept masked report type `0x02` alongside existing `0x80`. New six-byte reports decode X from packet bytes 3/2, Y from 5/4 (high nibble shifted eight bits), and touch from bit zero of byte 1. Existing five-byte report parsing is preserved. Packet-length detection returns 6 for the new type.

**Scope:** Guarded by `CONFIG_IGEL_TOUCHSCREEN_EGALAX_REPT2` in definitions, `egalax_read_data()` and `egalax_get_pkt_len()`. This changes format support for devices already using that parser; it adds no USB-device match.

**Reason / limits:** The preamble/comment identify a newer UD9 controller. Selection is by packet format, not UD9 system identity. The member supplies no example report trace or additional coordinate-range calibration, so successful parsing support should not be conflated with verified touchscreen operation.

**Declared source:** IGEL; No reference supplied

<a id="patch-101"></a>

### `IGEL/CONFIG_IGEL_UNGPL_VMA_START_WRITE.diff`

**Change:** Replaces `EXPORT_SYMBOL_GPL(__vma_start_write)` with unrestricted `EXPORT_SYMBOL(__vma_start_write)` in `mm/mmap_lock.c` when the IGEL option is enabled. The function's locking/state-change implementation remains unchanged.

**Scope:** Controlled solely by `CONFIG_IGEL_UNGPL_VMA_START_WRITE`. The policy change concerns which modules may resolve this exported symbol, not a driver-specific exception or new memory-management behavior.

**Reason / limits:** The preamble says an export restriction change affected the NVIDIA driver and seeks to revert it. The archived diff proves the before/after export macros, not the historical claim or a successful NVIDIA build. It does not add that driver, guarantee ABI compatibility, or relax restrictions on other symbols.

**Declared source:** IGEL; No reference supplied

<a id="patch-102"></a>

### `IGEL/CONFIG_IGEL_USB_DISABLE_DISCONNECT.diff`

**Change:** Adds a per-USB-device `disable_disconnect` bit and read/write sysfs attribute accepting integer 0/1. When set, usbfs `USBDEVFS_DISCONNECT` with a bound driver and disconnect-claim return `-EACCES`; USB device/interface unbind paths return `-ENODEV`, and `usb_driver_release_interface()` returns without releasing. Warnings identify each blocked path.

**Scope:** `CONFIG_IGEL_USB_DISABLE_DISCONNECT` guards additions in `drivers/usb/core/devio.c`, `driver.c`, `sysfs.c` and `include/linux/usb.h`. The sysfs attribute is attached to the USB **device** attribute group. No explicit initial value assignment or special-device whitelist appears.

**Reason / limits:** The preamble describes retaining devices against redirection/disconnect and acknowledges roughness. The added paths block selected driver-detachment operations, not physical unplug. The shown sysfs store interprets the same `dev` as both `usb_device` and `usb_interface`, then derives a second device from the latter and writes both under locks. The second conversion does not match the device-level attribute registration shown in this member; its final-source integration and runtime behavior have not been checked. The wider driver-core reaction to early unbind returns is not supplied.

**Declared source:** IGEL; No reference supplied

<a id="patch-103"></a>

### `IGEL/CONFIG_IGEL_USB_SERIAL_SUPPORT_HP_LDM350_DEVICES.diff`

**Change:** Defines `HP_LDM350_PRODUCT_ID` as `0x3739` in `drivers/usb/serial/pl2303.h` and adds an `HP_VENDOR_ID`/that-product entry to the PL2303 USB match table in `pl2303.c`.

**Scope:** Both additions require `CONFIG_IGEL_USB_SERIAL_SUPPORT_HP_LDM350_DEVICES`. The HP vendor macro is existing context, with no numeric definition in this member. There is no revision-specific test or new serial protocol implementation.

**Reason / limits:** The preamble asks to support newer LDM350 devices. The observed effect is making that ID eligible for the existing PL2303 driver. It does not show device-specific initialization, serial settings or functional validation; those should not be inferred merely from the new match.

**Declared source:** IGEL; No reference supplied

<a id="patch-104"></a>

### `IGEL/CONFIG_IGEL_USB_SOUND_PLANTRONICS_QUIRKS.diff`

**Change:** Adds a shared USB mixer range helper in `sound/usb/mixer.c`. For volume controls of Plantronics vendor `0x047f`, it queries maximum/minimum and resolution using the first selected channel (or master channel zero), substitutes resolution 1 when zero/unavailable, converts signed 1/256-dB values to ALSA hundredths of dB, and marks successful initialization. Feature-control construction falls back to the existing range path if needed. Multichannel writes additionally log get/set failures and mark a change only after a successful set.

**Scope:** Shared mixer changes require either `CONFIG_IGEL_USB_SOUND_PLANTRONICS_QUIRKS` or the Sennheiser option. Vendor range selection is independently guarded; the shared write-error behavior is not vendor-filtered. The member also contains the Sennheiser range branch under its guard.

**Reason / limits:** The preamble lists Conexant CX20773 and Plantronics C510/C520 and promises USB delays plus mixer fixes. This complete member touches only `mixer.c`: no delay is inserted, no Conexant-specific ID appears, and no C510/C520-specific product restriction is shown. Those promises must not be treated as implemented by this member. Shared hunks overlap the following Sennheiser patch.

**Declared source:** IGEL; No reference supplied

<a id="patch-105"></a>

### `IGEL/CONFIG_IGEL_USB_SOUND_SENNHEISER_QUIRKS.diff`

**Change:** Adds the shared mixer range/error handling described in the Plantronics member, with vendor `0x1395` range queries. SC660 `0x0037`, unit 11, instead gets sidetone min 0, max 4096 and resolution 512. For DW Pro2 `0x740a`, unit 6 receives `Sidetone` when the normal string name is empty. USB class-control messages for Sennheiser gain 50 ms delay for `UAC_SET_CUR`, otherwise 20 ms. Adds `QUIRK_FLAG_GET_SAMPLE_RATE` for SC630 `0x0036`, SC660 `0x0037`, SC260 `0x0050`, SC60 `0x005a`, SC45/S `0x0060` and BTD800 `0x002d`.

**Scope:** Changes `sound/usb/mixer.c`, `mixer_quirks.c/.h` and `quirks.c`, chiefly under `CONFIG_IGEL_USB_SOUND_SENNHEISER_QUIRKS`; shared mixer code accepts the Plantronics option too. Delays apply vendor-wide to class requests and precede existing quirk-flag delay handling, so additional delays can accumulate.

**Reason / limits:** The rationale is USB timing and mixer/sidetone correctness. The preamble mentions SC45/SC75, whereas the explicit new table label is SC45/S; no separately identified SC75 entry appears. The range override is unit-specific, not universal. Repeated shared mixer hunks should not be applied as independent implementations.

**Declared source:** IGEL; No reference supplied

<a id="patch-106"></a>

### `IGEL/CONFIG_IGEL_USE_BEST_MODE_FRAMEBUFFER.diff`

**Change:** Extends DRM client probing with best-mode selection and limits. It builds common-mode lists using exact timings and resolution-only matches, prefers a previously selected resolution, then aspect-compatible pixel-area choices, and duplicates/cleans up owned modes. Firmware and cloned configuration remain first; otherwise common-mode selection requires multiple already-configured CRTCs and enabled connectors, with command-line/best/preferred/first-mode fallback. Fb-helper parameters are `best_mode=true`, `max_width=1920`, `max_height=1200`, all `0600`.

**Scope:** `CONFIG_IGEL_USE_BEST_MODE_FRAMEBUFFER` changes `drm_client_modeset.c`, `drm_fb_helper.c`, `drm_client.h` and `clients/drm_log.c`, including probe signatures/calls. DRM logging passes best-mode false. Separate guards disable best mode above two Radeon screens or above three screens generally, and optionally remove current-framebuffer size limits on hotplug.

**Reason / limits:** The preamble's “highest horizontal size” simplifies an aspect/pixel-area/history heuristic. Preferred/first fallbacks can escape the intended limits; zero width/height also produces zero initial search bounds rather than unbounded search here. Common-mode success is overwritten per connector and returned for the last processed one, not aggregated. The resolution fallback can overwrite an exact timing match despite the comment promising priority. No remaining callers, allocation-failure behavior or live multi-display result are verified.

**Declared source:** IGEL; No reference supplied

<a id="patch-107"></a>

### `IGEL/CONFIG_IGEL_USE_VERSION_SIGNATURE.diff`

**Change:** Adds `version_signature.o` to the proc filesystem build's conditional object list in `fs/proc/Makefile`.

**Scope:** The object is selected by `CONFIG_IGEL_USE_VERSION_SIGNATURE`. This member contains only that Makefile addition; it supplies no runtime parameter or object implementation.

**Reason / limits:** The preamble says this creates `/proc/version_signature` containing `IGEL_VERSION_SIGNATURE`. Neither the source file nor proc-entry creation, permissions, formatting or signature-value definition appears in this diff. Consequently, the demonstrated change is build wiring for an expected object, not proof that the claimed proc file exists or what it reports.

**Declared source:** IGEL; No reference supplied

<a id="patch-108"></a>

### `IGEL/CONFIG_IGEL_VERIFY_SIGNATURE_AGAINST_KEYRING.diff`

**Change:** Adds GPL-exported `verify_signature_igel(key, sig, serial)` in `crypto/asymmetric_keys/signature.c` and its public declaration. It zeros the optional output serial. For a keyring, it iterates its associative array under RCU, strips pointer tag bit `2UL`, and tries `verify_signature()` via the wrapper for each directly encountered asymmetric key. The first successful verification stops iteration, returns 0 and supplies that key's serial. No success returns `-ENOKEY`, collapsing individual verification failures. A non-keyring delegates directly to `verify_signature()` and leaves the serial zero.

**Scope:** Requires `CONFIG_IGEL_VERIFY_SIGNATURE_AGAINST_KEYRING`; declaration is in `include/crypto/public_key.h`. Nonasymmetric members, including nested keyrings, are skipped rather than recursively searched. Each attempted asymmetric key logs pointer, description and permissions.

**Reason / limits:** The preamble describes community-app verification before partition mounting. This member exposes a helper but adds no mount check, caller, trusted-keyring selection, key provisioning or signature-format construction. It does not visibly check each member's validity/revocation or permissions before trying verification; surrounding verifier behavior is not supplied. The policy demonstrated is “any directly stored asymmetric key that verifies,” not certificate-chain validation or a changed default kernel/module trust policy.

**Declared source:** IGEL; No reference supplied

<a id="patch-109"></a>

### `IGEL/CONFIG_IGEL_VGA_USE_DVI_MODES_IF_MODES_MISSING_QUIRK.diff`

**Change:** Calls `dev->driver->fbdev_probe(fb_helper, &sizes)` a second time in `drm_fb_helper_single_fb_probe()` in `drm_fb_helper.c`, overwriting `ret` before the existing error check.

**Scope:** The duplicate invocation is unconditional whenever `CONFIG_IGEL_VGA_USE_DVI_MODES_IF_MODES_MISSING_QUIRK` is enabled. It has no VGA/DVI connector test, missing-mode/EDID predicate, device match or first-call-success guard.

**Reason / limits:** The preamble attributes the extra call to allowing VGA to reuse DVI modes when VGA EDID is absent. The member itself performs no mode or EDID copy. Driver-specific callback behavior and idempotency are essential, and a first-call error can be hidden by a succeeding second call, or vice versa; neither outcome is tested here.

**Declared source:** IGEL; No reference supplied

<a id="patch-110"></a>

### `IGEL/CONFIG_IGEL_VMWGFX_FIX.diff`

**Change:** In `sysfb.c`, finding VMware PCI `0x15ad:0x0405` or `0x15ad:0x0406` prevents simple-framebuffer creation, allowing legacy framebuffer fallback. In `vmwgfx_drv.c`, moves conflicting-aperture removal from early probe into PCI-resource setup, ignores its result, and continues after failed `pci_request_regions()` with a warning. Resource mappings still return errors on failure. `vmw_driver_load()` returns `-ENOSYS` when display-topology capability, register pitchlock capability and FIFO pitchlock are all absent.

**Scope:** Main option is `CONFIG_IGEL_VMWGFX_FIX`. A shared `CONFIG_IGEL_NO_SIMPLEFB_PREVENT_VM_SEGFAULT` branch adds an alternative sysfb initialization using global screen info and no PCI-parent argument; VMware simplefb suppression appears in both initialization paths.

**Reason / limits:** The preamble cites framebuffer resource conflicts and QEMU losing graphics after initialization. The observed response to limited capabilities is early load rejection, not demonstrated fallback success. Continuing after unreserved PCI regions changes failure policy materially. PCI lookup results are not released in the added conditions.

**Declared source:** IGEL; No reference supplied

<a id="patch-111"></a>

### `IGEL/CONFIG_IGEL_WACOM_BAMBOO_QUIRK.diff`

**Change:** Defines Bamboo pad USB IDs CTH301 `0x0318` and CTH300 `0x0319` for Wacom vendor `0x056a`, then adds a branch in `hid_ignore()` returning false for those products.

**Scope:** Changes `drivers/hid/hid-ids.h` and `hid-quirks.c` under `CONFIG_IGEL_WACOM_BAMBOO_QUIRK`. Earlier returns in `hid_ignore()` remain ahead of the new vendor switch; other Wacom products proceed through the existing path.

**Reason / limits:** The preamble says the default HID driver works better. The actual intervention prevents this particular ignore decision for the two IDs; it does not add a generic-driver match or remove Wacom-driver support. Final driver binding and which reports work better are not established by these additions alone.

**Declared source:** IGEL; No reference supplied

<a id="patch-112"></a>

### `IGEL/CONFIG_IGEL_WOL_FIX_8139TOO.diff`

**Change:** In `8139too.c`, initialization enables device wakeup for chipsets with `HasLWake`, and ethtool WoL updates set device wakeup enabled according to whether `wolopts` is nonzero. Suspend now calls `pci_wake_from_d3(..., true)` and places the PCI device in `PCI_D3hot`, both for stopped interfaces (before early return) and running interfaces after existing shutdown work. Resume restores `PCI_D0` and disables D3 wake before checking whether the interface is running.

**Scope:** All additions use `CONFIG_IGEL_WOL_FIX_8139TOO`. The initialization wakeup toggle checks `HasLWake`, but the added suspend/resume PCI calls check only that `tp->pci_dev` is non-NULL; they are not explicitly conditional on configured WoL options.

**Reason / limits:** The stated objective is wake-on-LAN for Realtek 8139. The change coordinates wakeup metadata and PCI power state; it does not demonstrate that wake packets are programmed correctly for every chipset. Added PCI return values are ignored, and D3 wake is requested at suspend even for a stopped interface or zero WoL options, so the runtime policy is broader than “enable requested WoL.”

**Declared source:** IGEL; No reference supplied

<a id="patch-113"></a>

### `Ubuntu/CONFIG_IGEL_ALLOW_ASPM_FOR_VMD.diff`

**Change:** Adds an `aspm_os_control` flag to `struct pci_dev`, sets it in `vmd_pm_enable_quirk()` after the existing `VMD_FEAT_BIOS_PM_QUIRK` check, and allows both PCIe link-state enable and disable requests to proceed despite global `aspm_disabled` when ASPM support remains enabled and the device has that override. Other devices still receive `-EPERM`. This permits OS ASPM programming; it does not itself demonstrate a particular link power state.

**Scope:** `drivers/pci/controller/vmd.c`, `drivers/pci/pcie/aspm.c`, and `include/linux/pci.h`; guarded by `CONFIG_IGEL_ALLOW_ASPM_FOR_VMD`. The header hunk also declares `no_shutdown` under the separate Surface EFI shutdown option.

**Reason / limits:** The preamble says VMD-mapped bridges/NVMe prevent lower SoC power states without ASPM, citing Canonical's OEM 6.17 patches. The entire PCI header hunk is duplicated in the Surface EFI shutdown diff in this batch: these are overlapping archived edits, not independent additions to apply twice. No Kconfig default is supplied here.

**Declared source:** Ubuntu; [source 1](https://wiki.ubuntu.com/Kernel/SourceCode); `6a74379399879517eb7f14c0b3fa24539da8feae`; `915083dc7e5e61f86200aab7cafae9b368c562e0`

<a id="patch-114"></a>

### `Ubuntu/CONFIG_IGEL_ALLOW_R8169_ASPM_FOR_DELL.diff`

**Change:** Makes `rtl_aspm_is_safe()` return true for DMI product-family prefixes associated with Dell, in addition to its existing register-based acceptance. The helper recognizes Alienware, Dell Laptops/Desktops and Pro/Pro Max variants, Dell Pro Rugged Laptops, Precision, Essential, Education, and XPS. This changes the driver's ASPM eligibility decision rather than directly programming a link in the shown hunks.

**Scope:** Only `drivers/net/ethernet/realtek/r8169_main.c`, including a conditional DMI include, under `CONFIG_IGEL_ALLOW_R8169_ASPM_FOR_DELL`. Missing product-family information returns false. Matching uses prefixes and does not check system vendor, model year, or an explicit model list.

**Reason / limits:** The preamble claims new Dell models will be verified with ASPM and Dell will pursue RTL fixes. Those are stated plans, not test evidence; the actual family-prefix scope is broader than an independently verified list of “new models.”

**Declared source:** Ubuntu; [source 1](https://wiki.ubuntu.com/Kernel/SourceCode); `05bda1b689ffb9bc29af2d28681565defc097c11`; `0d9aba26504ddef497aab134c0600758ab2c5881`

<a id="patch-115"></a>

### `Ubuntu/CONFIG_IGEL_I915_DP_BYTE_BY_BYTE_FALLBACK.diff`

**Change:** In `intel_dp_read_dprx_caps()`, a successful normal capability read still returns immediately. If that read fails, the new path reads every receiver-capability byte separately from `DP_DPCD_REV + i`; a negative byte-read result or zero DPCD revision returns `-EIO`. The existing eDP early return remains.

**Scope:** `drivers/gpu/drm/i915/display/intel_dp_link_training.c`, guarded by `CONFIG_IGEL_I915_DP_BYTE_BY_BYTE_FALLBACK`. Runtime gating is failure of the normal DPCD read, not a USB vendor/product match. Comments name Lenovo's VIA VL817 VGA adapter (`17ef:7217`) and Dell DA310 (`413c:c010`).

**Reason / limits:** The stated workaround addresses multi-byte AUX timeouts where single-byte reads work. It applies to qualifying failures generally, not just those named adapters; no parameter or default is introduced.

**Declared source:** Ubuntu; `84b049fd15e71ea3f67b7548cf279fc4dca49020`

<a id="patch-116"></a>

### `Ubuntu/CONFIG_IGEL_I915_TC_DP_ALT_FALSE_DISCONNECT.diff`

**Change:** `intel_tc_port_connected()` now returns true before consulting HPD live status when a Type-C port has a positive link reference count, is in `TC_PORT_DP_ALT` mode, and `tc_phy_is_owned()` succeeds. All other cases continue through the existing HPD/mode mask.

**Scope:** `drivers/gpu/drm/i915/display/intel_tc.c`, under `CONFIG_IGEL_I915_TC_DP_ALT_FALSE_DISCONNECT`; no module parameter or platform-ID check is added in this hunk.

**Reason / limits:** The preamble attributes false disconnects to transient HPD deassertion during long pulses on XELPDP+ platforms, described as Lunar Lake onward. The observed predicate relies on active-link/PHY ownership rather than explicitly limiting this insertion to those platform names.

**Declared source:** Ubuntu; `4d8202ebc42f103dd37c800540629b527edd7cbc`

<a id="patch-117"></a>

### `Ubuntu/CONFIG_IGEL_LENOVO_THINKCENTRE_MUTE_LED.diff`

**Change:** Adds an ALC233 Lenovo fixup that configures coefficient index `0x10`, bit 13, for a microphone-mute LED (clear means on, set means off), and registers the mic-mute LED class device. Its combined fixup also enables coefficient bit 2, creates a microphone-mute input device, enables GPIO2 unsolicited events, installs `gpio2_mic_hotkey_event`, and unregisters that input device on the free action. Initialization is at `HDA_FIXUP_ACT_PRE_PROBE`.

**Scope:** `sound/hda/codecs/realtek/alc269.c`, under `CONFIG_IGEL_LENOVO_THINKCENTRE_MUTE_LED`. New subsystem quirks are Lenovo `17aa:3341/3342` (M90 Gen4), `3343/3344` (M70 Gen4), and `334f` (M90a Gen5). The existing M70 Gen5 `334b` entry remains assigned to its headset-mic fixup.

**Reason / limits:** The preamble promises speaker- and microphone-mute LEDs for M70/M90 Gen4/Gen5. The added implementation explicitly covers the mic-mute LED and GPIO2 hotkey; it does not add a speaker-mute LED setter, nor change every Gen5 entry. The GPIO3 LED comment should be read alongside the actual coefficient-based LED configuration.

**Declared source:** Ubuntu; `208fdac8812cf66c5b325a97d059fc057b250ed8`

<a id="patch-118"></a>

### `Ubuntu/CONFIG_IGEL_MT792X_FIX_DEADLOCK_IN_HIGH_LOAD.diff`

**Change:** Replaces `cancel_delayed_work_sync(&mphy->mac_work)` with non-waiting `cancel_delayed_work()` in `mt792x_pm_power_save_work()` when `mt792x_mcu_fw_pmctrl(dev)` returns zero. This cancels pending work without waiting for an already-running callback.

**Scope:** `drivers/net/wireless/mediatek/mt76/mt792x_mac.c`, under `CONFIG_IGEL_MT792X_FIX_DEADLOCK_IN_HIGH_LOAD`. The original synchronous cancellation remains when the option is absent; no load threshold or device-ID filter is added.

**Reason / limits:** The preamble identifies mutual synchronous cancellation between power-save and MAC work as a deadlock scenario. The hunk removes this waiting edge.

**Declared source:** Ubuntu; `152d7b79cbd37be626db8503cc418859fbcf1b0b`

<a id="patch-119"></a>

### `Ubuntu/CONFIG_IGEL_RTL8116AF_SERDES_QUIRK.diff`

**Change:** Adds an RTL8116af-specific MDIO read wrapper that ORs ordinary PHY reads with status synthesized from the MAC's `PHYstatus`. With `LinkStatus` set, standard-page `MII_BMSR` gains autonegotiation-complete/link-status bits, while page `0xa430`, register `0x12`, gains `0x0028` for 1 Gbit/s or `0x0018` for 100 Mbit/s. With no reported link, the synthetic contribution is zero, not a clearing of the original PHY result.

**Scope:** `drivers/net/ethernet/realtek/r8169_main.c`, guarded by `CONFIG_IGEL_RTL8116AF_SERDES_QUIRK`. Detection requires MAC version 52, OCP `0xdc00 & 0x0078 == 0x0030`, and `0xd006 & 0x00ff == 0`; other versions in the existing read branch retain ordinary reads.

**Reason / limits:** The preamble describes RTL8116af as an RTL8168fp variation whose SerDes status is not reflected in PHY registers. The implementation supplements those specific reads; it is not a general PHY replacement or an unconditional overwrite of link state.

**Declared source:** Ubuntu; `c7d0a206df17d4cbb364d27532f6275e1486eda0`

<a id="patch-120"></a>

### `Ubuntu/CONFIG_IGEL_THUNDERBOLT_PCIE_DELAYED_RESCAN.diff`

**Change:** After `tb_tunnel_pci()` adds a tunnel to its list, allocates delayed work and queues a PCI bus rescan for 300 ms later on `tb->wq`. The worker takes the PCI rescan/remove lock, calls `pci_rescan_bus()`, unlocks, and frees its allocation. It rescans the NHI device's parent bus when available, otherwise its own bus.

**Scope:** `drivers/thunderbolt/tb.c`, under `CONFIG_IGEL_THUNDERBOLT_PCIE_DELAYED_RESCAN`. Requires the NHI, its PCI device, and bus pointers to exist. Allocation failure leaves tunnel creation successful without scheduling recovery. No device-specific match or adjustable delay is added.

**Reason / limits:** The preamble says spurious hotplug events cause missed enumeration roughly 70% of the time and claims nondisruptive recovery. These are claims, not measured results here. The bus pointer is retained without a visible reference acquisition or cancellation path, and the rescan covers a bus rather than only the newly tunneled endpoint; removal/lifetime handling needs checking in the surrounding implementation.

**Declared source:** Ubuntu; `8aecf0856dfad63b913755ae58f21358100827d8`

<a id="patch-121"></a>

### `Ubuntu/CONFIG_IGEL_USB_HUB_ACPI_PRR_RESET.diff`

**Change:** During the existing halfway-through-enumeration-retries power cycle, `hub_port_connect()` calls a new ACPI reset helper after VBUS power-off and its delay, before power-on. The helper evaluates the port's `_PRR`, validates a nonempty package and first-element reference, then invokes that referenced resource's `_RST`. A successful helper result adds 100 ms after the existing power-on-good delay. Reset errors do not abort the ordinary retry path.

**Scope:** `drivers/usb/core/hub.c`, `usb-acpi.c`, and `usb.h`, under `CONFIG_IGEL_USB_HUB_ACPI_PRR_RESET`. Actual reset requires a port ACPI handle, `_PRR`, the expected object shape, and successful `_RST`. The non-ACPI stub returns `-ENODEV`, so it does not trigger the extra delay.

**Reason / limits:** The rationale is a reset GPIO that normal VBUS cycling does not exercise. The patch adds an entire 100 ms sleep on success, rather than calculating just the shortfall to 100 ms. Only the first `_PRR` package element is used; the diff does not identify particular USB devices or demonstrate their firmware behavior.

**Declared source:** Ubuntu; `b4d2bec7c1110bff5ca7485836cc56df1b8b0361`

<a id="patch-122"></a>

### `Ubuntu/CONFIG_IGEL_VERSION_SIGNATURE.diff`

**Change:** Introduces `fs/proc/version_signature.c`, whose seq-file read returns the literal `CONFIG_IGEL_VERSION_SIGNATURE` string plus newline, and whose initialization creates `/proc/version_signature`. Separately appends the same string in parentheses to `linux_banner`.

**Scope:** The new proc implementation and `init/version-timestamp.c` are guarded by `CONFIG_IGEL_VERSION_SIGNATURE`. No Makefile integration for the new file, Kconfig string/default, or check of `proc_create()` failure is included.

**Reason / limits:** The preamble says the string changes the version seen by `uname` and refers to an additional `IGEL_USE_VERSION_SIGNATURE` option for proc output. Neither claim is implemented in these hunks: the visible edit changes `linux_banner`, not `init_uts_ns`, and the proc code uses `CONFIG_IGEL_VERSION_SIGNATURE` alone.

**Declared source:** Ubuntu; [source 1](https://wiki.ubuntu.com/Kernel/SourceCode); `195486586f0bbe34d0c1be810df4a2d78cfafee2`

<a id="patch-123"></a>

### `linux-surface/CONFIG_IGEL_HID_SURFACE.diff`

**Change:** Adds Makefile selection of `hid-surface.o` and the `ipts/` subdirectory; it contains no HID event-filtering implementation.

**Scope:** Only `drivers/hid/Makefile`. `hid-surface.o` is selected by `CONFIG_IGEL_HID_SURFACE`, while `ipts/` uses the separate `CONFIG_IGEL_SURFACE_HID_IPTS`. Actual y/m values and driver source availability are not provided.

**Reason / limits:** The preamble describes filtering erroneous integrated-keyboard/touchpad `BTN_0` FN events that disturb input focus. That behavior cannot be established from this Makefile-only member. Its complete Makefile hunk is repeated in the Surface HID and IPTS members in this batch.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-124"></a>

### `linux-surface/CONFIG_IGEL_RTC_DRV_SURFACE.diff`

**Change:** Selects `rtc-surface.o` in the RTC Makefile and adds Surface Laptop 7 ACPI ID `MSHW0551` to the Surface Aggregator registry, pointing it to `ssam_node_group_sl7`.

**Scope:** `drivers/rtc/Makefile` and `drivers/platform/surface/surface_aggregator_registry.c`. The object uses `CONFIG_IGEL_RTC_DRV_SURFACE`; the registry insertion uses `IS_ENABLED()` on that symbol, covering enabled built-in or module configurations.

**Reason / limits:** The stated purpose is basic RTC support through the Surface System Aggregator Module. This member supplies neither `rtc-surface.c` nor the definition of `ssam_node_group_sl7`, so RTC operations and the Laptop 7 node composition are dependencies, not described implementations. No actual build setting is shown.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-125"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_ACPI_CHANGES.diff`

**Change:** Splits ACPI Time and Alarm Device sysfs attributes into an always-created capabilities group and an AC-alarm/policy/status group created only when `ACPI_TAD_AC_WAKE` is advertised. Removal similarly gates AC group removal and AC timer disable/status clearing on that capability. It also bypasses probe's rejection for a missing `_PRW`.

**Scope:** Only `drivers/acpi/acpi_tad.c`, under `CONFIG_IGEL_SURFACE_ACPI_CHANGES`. Existing DC-wake and real-time capability paths remain in the shown context. There is no Surface DMI/ACPI-ID restriction introduced by the edits, so they affect qualifying TAD devices generally when compiled.

**Reason / limits:** “Some smaller ACPI changes” understates the concrete probe and sysfs behavior. The patch permits TAD devices without `_PRW` and avoids exposing/operating an unsupported AC wake timer; it does not supply a replacement wake description or demonstrate wake functionality on particular Surface models.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-126"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_BOOK1_DGPU_SWITCH.diff`

**Change:** Extends the ACPI I2C GenericSerialBus handler with write-only `ACPI_GSB_ACCESS_ATTRIB_RAW_BYTES` support. The helper submits one I2C message using the client's address/flags and `data_len + 1` bytes directly from the provided buffer; a negative transfer result propagates, and anything other than one completed message becomes `-EIO`. Reads of this protocol are rejected. Also adds Makefile selection of `surfacebook1_dgpu_switch.o`.

**Scope:** `drivers/i2c/i2c-core-acpi.c` uses `IS_ENABLED(CONFIG_IGEL_SURFACE_BOOK1_DGPU_SWITCH)`; `drivers/platform/surface/Makefile` selects the object with that option. The generic I2C handler addition itself has no Surface-specific device match.

**Reason / limits:** The preamble describes a Surface Book 1 discrete-GPU power-state sysfs switch, but its source and sysfs interface are absent here. The visible prerequisite is raw-byte ACPI I2C writes plus build wiring.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-127"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_BUTTON_CHANGES.diff`

**Change:** Adds alternative checks intended to divide devices sharing ACPI ID `MSHW0040` between `soc_button_array` and `surfacepro3_button`. The former accepts a device when the specified UUID/revision advertises OEM Platform Revision DSM function 2; the latter returns true when that function is absent. These checks test function availability, not the returned platform-revision value.

**Scope:** `drivers/input/misc/soc_button_array.c` and `drivers/platform/surface/surfacepro3_button.c`, under `CONFIG_IGEL_SURFACE_BUTTON_CHANGES`. Comments associate the positive DSM check with Surface Book 2/Pro 2017 and the complementary path with Pro 4/Book 1.

**Reason / limits:** The preamble says "button changes." The second hunk references DSM constants without showing their definition in this member.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-128"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_CAMERA_LEDS_TPS68470.diff`

**Change:** Adds `leds-tps68470.o` to the LED Makefile's configuration-controlled object list.

**Scope:** Only `drivers/leds/Makefile`, using `CONFIG_IGEL_SURFACE_CAMERA_LEDS_TPS68470`; y/m selection follows the object rule, but no Kconfig declaration or chosen value is shown.

**Reason / limits:** The preamble claims two LED controllers capable of driving two indicator and two flash LEDs, with module name `leds-tps68470`. The actual controller implementation is not in this member. The camera-support member in this batch supplies a `tps68470-led` MFD child and LED register definitions, a visible related integration point rather than proof of those LED capabilities.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-129"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_COVER_QUIRK.diff`

**Change:** Adds multitouch classes for Microsoft Type Cover `0x09c0` and touchpad `0x0c46`. The cover exports a vendor-defined folding-state usage as `SW_TABLET_MODE`: low byte `0x22` means false; other values mean true. It requests the state during configuration/resume/reset-resume and clears it on disconnect. A PM notifier sends vendor feature-report values to disable keyboard backlight before suspend and enable it afterward, with USB runtime-PM get/put around the request. The separate touchpad class skips reporting-mode changes in HID hardware-open/close hooks.

**Scope:** `drivers/hid/hid-multitouch.c`, under `CONFIG_IGEL_SURFACE_COVER_QUIRK`; ID entries allow any HID bus/group for those Microsoft products. Backlight/tablet behavior requires the corresponding class quirks and vendor report fields. Normal resume mode-setting remains. Notifier registration is added to the general probe path; unregistration is shown for parse/start failures and removal.

**Reason / limits:** The minimal preamble omits folding-state export, suspend backlight handling, and the Laptop Studio 2 touchpad rationale in comments. Backlight handling assumes a USB device even though the match uses any bus. Later probe failure cleanup beyond the shown early returns, and report-field/index assumptions, need surrounding-code verification; this member does not establish them.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-130"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_EFI_RESET_SHUTDOWN_FIX.diff`

**Change:** Adds a `no_shutdown` PCI-device bit and makes `pci_device_shutdown()` return immediately for marked devices, before runtime resume or the driver's shutdown callback. A final PCI fixup marks selected Intel Thunderbolt USB controllers, root ports, NHIs, and GPUs on matching Surface systems. This skips the PCI shutdown path; it does not modify EFI reset code itself.

**Scope:** `drivers/pci/pci-driver.c`, `drivers/pci/quirks.c`, and `include/linux/pci.h`, under `CONFIG_IGEL_SURFACE_EFI_RESET_SHUTDOWN_FIX`. DMI matches Microsoft Corporation plus Pro 9, Laptop 5, Laptop Studio 2, Pro 10, or Pro 10 for Business. Intel IDs are `461e,461f,462f,466d,46a8,a76e,a71e,a73f,a73e,a7a0,7ec0,7ec5,7ec6,7ec2,7ec3,7d45`; the fixup requires both PCI and DMI matches.

**Reason / limits:** The rationale is firmware failing to power off after PCI shutdown callbacks. Skipping callbacks does not establish successful power-off or hardware quiescence. The PCI header hunk also adds VMD's separately guarded `aspm_os_control` bit and is identical to that member's header hunk, so applying these archived edits requires overlap handling.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-131"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_HID.diff`

**Change:** Combines HID object/subdirectory build rules, an IPTS composite-object Makefile, and an Intel interrupt-remapping exception. In `set_msi_sid()`, matching Intel pen-class devices get an IRTE with `SVT_NO_VERIFY`, then return before ordinary source-ID handling.

**Scope:** `drivers/hid/Makefile`, new `drivers/hid/ipts/Makefile`, and `drivers/iommu/intel/irq_remapping.c`. Build rules use `CONFIG_IGEL_HID_SURFACE` and `CONFIG_IGEL_SURFACE_HID_IPTS`; the remapping exception instead uses `CONFIG_IGEL_SURFACE_HID_ITHC_DISABLE_IRQ`. It matches Intel pen class and IDs `98d0/98d1`, `a0d0/a0d1`, `43d0/43d1`, without a Surface DMI check.

**Reason / limits:** The vague “HID changes” preamble hides distinct options and behaviors. IPTS component sources are not supplied here. Comments describe an ITHC MSI requester-ID mismatch (`00:10.6` versus `01:05.0`) and explicitly request a proper fix/quirk. This changes verification, not interrupt enablement. All three components overlap with other members in this batch.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-132"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_HID_IPTS.diff`

**Change:** Adds top-level HID build selection for `hid-surface.o` and `ipts/`, plus a new IPTS Makefile assembling `ipts.o` from `cmd`, `control`, `eds1`, `eds2`, `hid`, `main`, `mei`, `receiver`, `resources`, and `thread` objects.

**Scope:** `drivers/hid/Makefile` and `drivers/hid/ipts/Makefile`. IPTS rules use `CONFIG_IGEL_SURFACE_HID_IPTS`, while `hid-surface.o` uses independent `CONFIG_IGEL_HID_SURFACE`. No Kconfig setting/default or driver C source is included.

**Reason / limits:** The preamble describes Intel Precise Touch & Stylus support and the module name `ipts`; the Makefile supports that name but cannot establish touchscreen protocol behavior. The same rules appear in the Surface HID member, and the top-level rule also appears in HID Surface.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-133"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_HID_ITHC_DISABLE_IRQ.diff`

**Change:** In `set_msi_sid()`, overrides ordinary MSI source-ID verification by calling `set_irte_sid(irte, SVT_NO_VERIFY, SQ_ALL_16, 0)` and returning for selected Intel Touch Host Controller devices.

**Scope:** `drivers/iommu/intel/irq_remapping.c`, under `CONFIG_IGEL_SURFACE_HID_ITHC_DISABLE_IRQ`. Requires Intel vendor, pen input class, and IDs `98d0/98d1` (LKF), `a0d0/a0d1` (TGL LP), or `43d0/43d1` (TGL H). There is no Surface-system match.

**Reason / limits:** The comment cites controller address `00:10.6` but MSI requester ID `01:05.0` and retains a FIXME for a proper fix/quirk. Despite the option's “DISABLE_IRQ” name, the shown code disables source-ID verification, not interrupts. This exact insertion also occurs in Surface HID.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-134"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_IMPROVE_CAMERA_SUPPORT.diff`

**Change:** Broadly modifies camera enumeration, power, and media integration: ACPI skips devices not ready for enumeration; DW9719 adds 10 ms power-up settling; OV13858 acquires `avdd`/`pwr1` regulators, optional `xvclk`/reset, clock-first power sequencing, delays, runtime-PM callbacks, cleanup and logging. OV5693 adds `OVTI5693`; the IPU bridge adds that sensor and `OVTID858`. OV7251 changes gain control to analogue gain, retaining range/default `16–1023`/`16`. CIO2 adds first-source-pad linking during bound notification; privacy-LED acquisition moves to generic async subdevice registration. TPS68470 enables I2C daisy chaining, adds an LED child/register definitions; INT3472 adds power-rail GPIO types. Intel IOMMU quirks select identity domains for IPUs.

**Scope:** `drivers/acpi/scan.c`, Intel IOMMU, media I2C (`dw9719`, `ov13858`, `ov5693`, `ov7251`), IPU bridge/CIO2, V4L2 async/fwnode, INT3472 discrete/TPS68470, staging IPU3, and `include/linux/mfd/tps68470.h`. Main guard is `CONFIG_IGEL_SURFACE_IMPROVE_CAMERA_SUPPORT`; repeated IPTS IOMMU edits use their separate option. IPU IDs are `9a19,9a39,4e19,465d,1919`; quirks skip `risky_device()`. `dmar_map_ipu` starts at 1 and is cleared by matching fixups.

**Reason / limits:** The broad "Enhanced support" preamble covers several mechanisms. No regulator registration is added for INT3472 type `0x10`. The shown staging selection edits do not establish assignments for `try_sel` or the crop-path `rect` in this diff. Shared IOMMU hunks overlap the IPTS MEI patch.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-135"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_IPTS_MEI_CHANGES.diff`

**Change:** Adds Intel MEI PCI ID `0x34e4` (Ice Lake LP 3/iTouch) using `MEI_ME_PCH12_CFG`. Also adds IOMMU identity-domain selection for Intel IPTS IDs `0x9d3e` and `0x34e4`: header fixups clear `dmar_map_ipts`, `init_dmars()` sets an identity-mapping flag, and `device_def_domain_type()` returns `IOMMU_DOMAIN_IDENTITY` for those devices. This is passthrough domain selection, not removal of the entire IOMMU.

**Scope:** `drivers/misc/mei/hw-me-regs.h`, `pci-me.c`, and `drivers/iommu/intel/iommu.c`, primarily under `CONFIG_IGEL_SURFACE_IPTS_MEI_CHANGES`. `dmar_map_ipts` defaults to 1; the fixup skips devices for which `risky_device()` is true. The shared IOMMU hunks also contain camera-option IPU handling for `9a19,9a39,4e19,465d,1919`.

**Reason / limits:** The preamble ties MEI support to Surface touch and makes a statement about IPTS module placement; placement is not established by this diff. The IOMMU hunks are repeated verbatim in camera support. Hardware-ID matching is not restricted to Surface DMI systems.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-136"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_IRQ7_QUIRK.diff`

**Change:** During MADT IOAPIC setup, inserts `mp_override_legacy_irq(7, 3, 3, 7)` before filling default legacy mappings. This supplies an IRQ7-to-GSI7 override with the ACPI polarity/trigger values used for active-low, level-triggered routing.

**Scope:** `arch/x86/kernel/acpi/boot.c`, under `CONFIG_IGEL_SURFACE_IRQ7_QUIRK`. DMI requires Microsoft Corporation and SKU `Surface_Laptop_4_1952:1953` (AMD 15-inch) or `Surface_Laptop_4_1958:1959` (AMD 13-inch). The insertion logs an override warning.

**Reason / limits:** The preamble identifies these Surface Laptop 4 variants but gives no specific failure scenario or validation. It is a model-gated routing override, not a blanket reassignment of every machine's IRQ7.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-137"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_SECUREBOOT.diff`

**Change:** Changes x86 EFI PE-header `DllCharacteristics`: with the IGEL option enabled, `IMAGE_DLLCHARACTERISTICS_NX_COMPAT` is retained only when `CONFIG_EFI_DXE_MEM_ATTRIBUTES` is defined; otherwise the field is zero. Separately introduces the boot option `lockdown_hibernate`, whose setup callback sets a static flag to 1. `hibernation_available()` then accepts that flag instead of consulting the `LOCKDOWN_HIBERNATION` restriction; short-circuit evaluation skips that check when set. The `nohibernate`, active secret-memory, and active CXL-memory conditions remain.

**Scope:** `arch/x86/boot/header.S` and `kernel/power/hibernate.c`, under `CONFIG_IGEL_SURFACE_SECUREBOOT`; no Surface DMI or actual Secure Boot-state predicate is added. The hibernation override starts at zero and requires the boot token; the callback does not parse a boolean value from its argument.

**Reason / limits:** The preamble mentions only Secure Boot early-boot hangs, omitting the separate lockdown hibernation override. Removing the NX-compatible declaration is a header-advertisement change, not a demonstrated firmware fix or proof that signing/Secure Boot checks are disabled. The hibernation addition does not implement authenticated/encrypted resume images or override the remaining availability restrictions.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-138"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_SUPPORT_GPE.diff`

**Change:** Adds a Surface Pro 9 lid-device property set with GPE `0x52` and a DMI entry selecting it.

**Scope:** Only `drivers/platform/surface/surface_gpe.c`, under `CONFIG_IGEL_SURFACE_SUPPORT_GPE`. Matching is exact for Microsoft Corporation and SKU `Surface_Pro_9_2038`, rather than the generic product name.

**Reason / limits:** The preamble describes Surface/Pro 9 GPE support; the comment explains SKU matching avoids collision with the ARM variant's product name. The member extends the existing lid/GPE mechanism and does not itself show its handler or guarantee lid wake behavior. No module rule, parameter, or default is added here.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-139"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_SURFACE3_OEMB_FIX.diff`

**Change:** Adds alternate OEMB DMI recognition to Surface 3 WMI, RT5645 codec platform data, and Cherry Trail audio matching. Separately adds writable boolean `use_dma` (mode `0644`, default false) to the Surface 3 SPI touchscreen driver. Probe replaces the SPI controller's `can_dma` callback with one returning that parameter, so default operation declines DMA and setting true permits it.

**Scope:** `drivers/input/touchscreen/surface3_spi.c`, `drivers/platform/surface/surface3-wmi.c`, `sound/soc/codecs/rt5645.c`, and `sound/soc/intel/common/soc-acpi-intel-cht-match.c`, under `CONFIG_IGEL_SURFACE_SURFACE3_OEMB_FIX`. Alternate DMI entries require BIOS vendor American Megatrends Inc., system vendor OEMB, and product OEMB. The touchscreen callback change is not itself conditional on those DMI matches and is assigned at controller level.

**Reason / limits:** The preamble mentions only OEMB detection. The touchscreen comments additionally cite crashes with DMA after suspend on 4.19 and first touch on kernels after 5.1, with PIO reportedly unaffected. Parameter help says “Disable DMA,” but its actual true value enables eligibility. No restoration of the controller callback is included in the shown edits.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-140"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_USB_QUIRK_DELAY_INIT.diff`

**Change:** Adds USB device `045e:09b5` to `usb_quirk_list` with `USB_QUIRK_DELAY_INIT`.

**Scope:** `drivers/usb/core/quirks.c`, under `CONFIG_IGEL_SURFACE_USB_QUIRK_DELAY_INIT`, matching Microsoft's Surface Go 3 Type Cover by USB vendor/product. No new timing constant, parameter, or alternative enumeration code is included.

**Reason / limits:** The rationale is intermittent failure to initialize the cover's touchpad properly. The observed edit selects the existing delayed-initialization mechanism; no specific delay value or successful recovery rate is established by this diff alone.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-141"></a>

### `linux-surface/CONFIG_IGEL_SURFACE_WLAN_IMPROVEMENTS.diff`

**Change:** Bundles Bluetooth, ath10k, and mwifiex changes. Bluetooth USB `1286:204c` gets passive LE scan interval/window `0x0190`/`0x000a` (250/6.25 ms). Ath10k gains writable `override_board` and `override_board2` strings: empty defaults keep `board.bin`/`board-2.bin`; `none` simulates missing firmware with `-ENOENT`; other values substitute filenames before ordinary directory/board-name path construction. Mwifiex disables upstream-bridge D3 eligibility during probe and calls `pci_reset_function()` on that bridge after firmware initialization when newly added quirks are selected.

**Scope:** `drivers/bluetooth/btusb.c`, ath10k `core.c`, and mwifiex `pcie.c`, `pcie_quirks.c`, `pcie_quirks.h`, all under `CONFIG_IGEL_SURFACE_WLAN_IMPROVEMENTS`. Both new bridge quirks augment existing D3cold-reset entries labeled Pro 4, Pro 5, Pro 5 LTE, Book 1/2, and Laptop 1/2. Visible exact Microsoft DMI predicates include Pro 4's product name, Pro 5 SKU `Surface_Pro_1796`, and Book 1 product `Surface Book`; other predicates fall outside the hunks. Ath10k overrides have no Surface match and permissions `0644`.

**Reason / limits:** Comments cite BT/Wi-Fi coexistence, packaging alternate board data, suspend firmware crashes, and fixed LTR values blocking package C10/S0ix. The preamble mentions only mwifiex. Bridge lookup results are dereferenced without a visible null check, and reset return status is ignored. No alternate firmware data or measured performance result is supplied.

**Declared source:** linux-surface; [source 1](https://github.com/linux-surface/linux-surface/tree/master/patches)

<a id="patch-142"></a>

### `patchwork-kernel/CONFIG_IGEL_ADD_RTL8723BS_RFKILL_SWITCH_SUPPORT.diff`

**Change:** Adds ACPI ID `OBDA8723` to `rfkill-gpio` matching with type `RFKILL_TYPE_BLUETOOTH`.

**Scope:** Only `net/rfkill/rfkill-gpio.c`, under `CONFIG_IGEL_ADD_RTL8723BS_RFKILL_SWITCH_SUPPORT`. Runtime binding uses the existing ACPI/platform rfkill-gpio driver and that ID; no RTL8723BS wireless-driver file or GPIO logic is changed here.

**Reason / limits:** The preamble says rfkill support for the RTL8723BS driver, whereas the concrete entry exposes Bluetooth-type rfkill matching, not a WLAN-type switch. Existing GPIO/resource handling must supply the operational switch.

**Declared source:** patchwork-kernel; [source 1](https://patchwork.kernel.org/project/linux-wireless/patch/20170408210520.2799-1-hdegoede@redhat.com/)

<a id="patch-143"></a>

### `upstream-kernel-reverted/CONFIG_IGEL_FIX_ELO_I2_WIFI_ISSUE.diff`

**Change:** Adds two entries to the PCI `bridge_d3_blacklist`: Elo i2 RevB and Atrust mt183 version 1.0. This feeds the existing bridge-D3 eligibility policy rather than changing the Wi-Fi driver.

**Scope:** `drivers/pci/pci.c`. Elo matching requires system vendor Elo Touch Solutions, product Elo i2, version RevB, under `CONFIG_IGEL_FIX_ELO_I2_WIFI_ISSUE`. The second entry independently uses `CONFIG_IGEL_FIX_MT183_WIFI_ISSUE` and vendor Atrust Computer Corp., product mt183, version 1.0.

**Reason / limits:** Comments state downstream devices become inaccessible after a root port transitions D3cold→D0. The preamble only mentions Elo and labels a version/commit; the actual diff also contains the separately gated Atrust entry. The surrounding blacklist consumer and actual build settings are not changed here.

**Declared source:** upstream-kernel-reverted; `92597f97a40bf661bebceb92e26ff87c76d562d4`

<a id="patch-144"></a>

### `upstream-kernel-reverted/CONFIG_IGEL_HP_MT645_BIOS_S3.diff`

**Change:** Restores enabled `_OSI` setup entry `Linux-HPI-Hybrid-Graphics` to the ACPI OS-interface string table.

**Scope:** `drivers/acpi/osi.c`, under `CONFIG_IGEL_HP_MT645_BIOS_S3`. The insertion has no HP DMI check: it changes the initial table globally when compiled.

**Reason / limits:** The preamble refers to a Lenovo BIOS, but the added comment specifically identifies HP mt645 BIOS U81 Ver.01.10.01 dated 01/09/2023 and says it uses this string for S3. The comment also explains custom Linux strings were no longer supported by default. This restores the named interface response; it does not show suspend/resume code or establish successful S3 operation.

**Declared source:** upstream-kernel-reverted; `e54049d481a9b25f5ae292f671e6aecb6d79f532`
