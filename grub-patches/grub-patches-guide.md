# GRUB patches: purpose and behavior

Patch guide for shim-review #589. This index covers all 38 patch files in
`grub-patches.tar.gz`; filenames are relative to its `grub-patches/` directory.
Descriptions below are based on the archived diffs. The detailed notes also
incorporate the patch series, IGEL boot scripts, and GRUB source after the
patches were applied with quilt. This is
code-reading context, not an independently rebuilt or runtime-tested GRUB.
All patches remain in scope for review; there is no
security/non-security classification.

## Why these changes are carried

IGEL's system partition uses an IGF section/extent layout. `part_igel` locates
the partition and `igelfs` exposes its boot files to GRUB. The boot registry
supplies settings used to generate IGEL boot entries. Other changes implement
dual boot, recovery, configurable boot options, display compatibility and
IGEL's menu presentation.

## Origin and upstream status

This guide covers the 38 IGEL-prefixed files in the submitted archive, not
the complete base/distribution patch stack also listed in the series.
Filenames alone do not establish original authorship or upstream status.
Per-patch attribution, external references, and the GRUB-specific upstream
assessment/submission status are not established by this guide. No candidate
list or submission commitment is implied.

## Patch index

Code paths below omit the common `grub-core/` prefix unless they begin with
`include/` or `IGEL/`; those paths are relative to the source-tree root.
The listed areas are navigation pointers, not necessarily all
files changed by a patch.

| Patch filename | Purpose / observed change | Code to inspect |
|---|---|---|
| `IGEL-Fix-high-bootregistry-issue.diff` | Filters the boot registry's `boot_cmd` arguments for the Custom boot command entry, dropping `systemd`-containing tokens except selected logging/debug matches. Dedicated boot-mode entries retain their explicit `systemd.unit` targets. See the clarification below. | `fs/bootregfs.c`, `fs/igelfs.c`, `include/grub/bootregfs.h` |
| `IGEL-Remove-default-from-Win-entry.diff` | Removes the literal `(default)` suffix from Windows menu labels; it does not change default selection in these hunks. | `fs/igelfs.c` |
| `IGEL-Update-Design-Dualboot.diff` | Revises the dual-boot menu design, themes, descriptive entry text, advanced-options presentation and supporting menu rendering. | `fs/igelfs.c`, `normal/menu_text.c`, `commands/menuentry.c`, `gfxmenu/gui_list.c`, `include/grub/menu.h` |
| `IGEL-add-acpi-boot-options.diff` | Translates the boot registry's ACPI setting into kernel command-line options for platform compatibility. | `fs/igelfs.c` |
| `IGEL-add-additional-boot-options.diff` | Adds settings for CPU mitigations, power states, timing, interrupts, PCI, USB-storage delay and reboot behavior. Several mitigation-disable choices are explicitly not emitted, but `retbleed=off` is among the accepted values; mitigation-disable settings are not uniformly blocked. | `fs/igelfs.c` |
| `IGEL-add-i8042-boot-options.diff` | Emits configurable i8042 kernel options to handle keyboard/controller compatibility and debugging. | `fs/igelfs.c` |
| `IGEL-add-ia32-emulation-option.diff` | Emits `ia32_emulation=true` or `false` from a boot-registry setting. | `fs/igelfs.c` |
| `IGEL-add-igel-partition-support.diff` | Adds IGF directory/fragment lookup and partition scanning so GRUB can locate logical IGEL partitions within the section-based layout. | `partmap/directory.c`, `partmap/igel.c`, `include/grub/igel_partition.h` |
| `IGEL-add-noquiet-boot-method.diff` | Supports a boot-registry `noquiet` choice, replacing quiet logging with verbose logging in generated boot entries. | `fs/igelfs.c` |
| `IGEL-add-second-kernel-extent-support.diff` | Extends IGF file handling and generated boot entries to support a second kernel and its associated extent/file selection. | `fs/igelfs.c` |
| `IGEL-add-wolfssl_enable-wolfssl_delay-options.diff` | Reads numeric `wolfssl_enable` and `wolfssl_delay` settings and appends corresponding kernel command-line parameters. It does not itself implement wolfSSL verification. | `fs/igelfs.c` |
| `IGEL-bc-dr-emergency-mode.diff` | Adds emergency/maintenance dual-boot behavior and a YAML-to-environment loader; exempts the new YAML file type from the shim verifier. See the YAML note below. | `fs/igelfs.c`, `commands/yaml.c`, `kern/efi/sb.c`, `include/grub/file.h` |
| `IGEL-cdboot-fix.patch` | Allows BIOS CD-drive probing when `PROBE_CD_DRIVES` is set, including additional BIOS drive numbers. | `disk/i386/pc/biosdisk.c` |
| `IGEL-change-menu-entries.diff` | Changes IGEL entry labels and menu-prefix generation; derives menu visibility from an EFI-partition marker file and changes timeout behavior. | `fs/igelfs.c` |
| `IGEL-change-menu-text.patch` | Uses IGEL branding in the header and removes standard menu/editor help text. | `normal/main.c`, `normal/menu_text.c` |
| `IGEL-check-kernel-signature-in-failsafe-mode.diff` | Adds shim-protocol signature checking while scanning a candidate failsafe kernel, with extent reading and related selection changes. Read together with the disabling patch below. | `partmap/igel.c` |
| `IGEL-disable-secure-boot-validation-in-failsafe.diff` | Disables selection-time kernel-buffer allocation; the applied source follows the section-CRC path and skips the buffer-dependent shim check. The generated failsafe entry subsequently invokes `linux`. | `partmap/igel.c` |
| `IGEL-disable-tpm-ev_ipl-event-handling.diff` | Disables the confidential-computing measurement protocol path and a diagnostic print. The TPM 1.2/2.0 logging paths remain in the diff context; this is not a general removal of all TPM logging. | `commands/efi/tpm.c` |
| `IGEL-dual-boot-find-win-boot-id.diff` | Changes formatting of EFI `Boot####` names and IDs to hexadecimal rather than decimal. | `commands/efi/find_win_boot_id.c` |
| `IGEL-dualboot-menu.diff` | Adds dual-boot-specific generated menu content and reorganizes IGEL/Windows entries and advanced options. | `fs/igelfs.c` |
| `IGEL-dualboot-submenu.diff` | Exports variables needed in the advanced submenu and adds a return-to-main-menu entry using `configfile`. | `fs/igelfs.c` |
| `IGEL-efi-fix.patch` | Changes EFI video fallback to 1024x768 and adjusts automatic UGA mode selection to avoid widths of 800 or less. | `video/efi_gop.c`, `video/efi_uga.c` |
| `IGEL-efi-helper-functions.diff` | Adds helpers to find Windows firmware boot entries, set the next firmware boot, and integrate this with generated dual-boot configuration. | `commands/efi/find_win_boot_id.c`, `commands/efi/set_next_boot.c`, `kern/efi/efi.c`, `fs/igelfs.c` |
| `IGEL-export-igel-part-env.diff` | Exports `igel_part` so the partition environment value is available beyond its local context. | `partmap/igel.c` |
| `IGEL-fix-INTEL_HDMI_STICK-MMC-size.diff` | Works around a specific BIOS disk-size report on Intel Compute Stick MMC devices by treating the reported size as unknown and adjusting geometry. | `disk/i386/pc/biosdisk.c` |
| `IGEL-fix-boot-with-hash-header.diff` | Masks out `PFLAG_HAS_IGEL_HASH` when testing supported IGF partition types, allowing recognition of partitions carrying that flag. These hunks do not implement cryptographic hash verification. | `partmap/igel.c` |
| `IGEL-fix-fontloading-with-secure-boot.diff` | Assigns `GRUB_VERIFY_FLAGS_DEFER_AUTH` to font files in the shim verifier. Deferred authorization is distinct from an unconditional verification skip. | `kern/efi/sb.c` |
| `IGEL-fix-security-issue-with-igel-conf-on-efi-parts.diff` | Records the detected IGEL-containing GPT/MS-DOS partition name as `igel_part`; the IGEL EFI boot script uses it to select the partition supplying `igel.conf`. The original incident behind the filename is not documented here. | `partmap/igel.c`, `IGEL/igel-lx_os-grub-efi.cfg` |
| `IGEL-handle-dualboot.diff` | Uses dual-boot environment/EFI marker settings to generate Windows and IGEL choices, changes keyboard-state/menu handling, and extends filesystem close handling. | `fs/igelfs.c`, `kern/term.c`, `normal/menu.c` |
| `IGEL-hide-terminal-box.patch` | Adjusts the graphical terminal rectangle and border so it does not overlay the boot menu as a separate black box. | `gfxmenu/view.c` |
| `IGEL-new-libbootreg.patch` | Adds boot-registry parsing, `bootregfs`, the `igelfs` boot-file reader/configuration generator and their build integration. Provides the base on which several other patches operate. | `fs/bootregfs.c`, `fs/igelfs.c`, `include/grub/bootregfs.h`, Makefiles |
| `IGEL-remove-unwanted-hotkeys.patch` | Gates a block of menu key handling, beginning with ESC, behind `IGEL_DEBUG`. Does not by itself establish complete prevention of interactive access. | `normal/menu.c` |
| `IGEL-tpm-pcr-vmlinuz-only.patch` | Limits the `tpm` verifier's file-content measurements in PCR 9 to filenames containing `vmlinuz`; its separate PCR 8 string-measurement path is unchanged. See the measurement note below. | `kern/verifiers.c`, `commands/tpm.c`, `include/grub/tpm.h` |
| `IGEL-udpocket-menuentry.diff` | Finds a UD Pocket firmware boot entry and adds a USB boot choice that uses the next-boot helper. | `commands/efi/find_udp_boot_id.c`, `fs/igelfs.c` |
| `IGEL-use-old-sys-minor-setting-for-failsafe.diff` | Adds an `old_sys_minor` hint and uses current/previous system-partition hints during fallback scanning and selection. | `fs/igelfs.c`, `partmap/igel.c` |
| `IGEL-vbe-fix.patch` | Skips invalid VBE entries and uses 1024x768 as the BIOS video fallback. | `video/i386/pc/vbe.c` |
| `IGEL-win-boot-fallback.diff` | Creates a Windows Boot Manager firmware entry when needed, sets `BootNext`, and reboots; leaves `BootOrder` unchanged. Integrates this fallback into generated Windows entries. | `commands/efi/win-bootnext.c`, `fs/igelfs.c` |
| `IGEL-work-with-sys-partition-is-not-igf-1.diff` | Reworks IGF file/partition handling and boot-registry hints so the system partition need not be logical minor 1. | `fs/igelfs.c`, `partmap/igel.c` |

## Detailed explanations

### Failsafe selection versus kernel loading

`IGEL-check-kernel-signature-in-failsafe-mode.diff` adds a shim-protocol check
during partition selection. `IGEL-disable-secure-boot-validation-in-failsafe.diff`
disables the kernel-buffer allocation used by that check; the later code tests
whether the buffer is non-null before calling shim. These are selection-stage
changes, not changes to the `linux` loader itself.

The series places the signature-check patch at position 19 in its 38-entry
IGEL section, the old-system-minor patch at position 20, and the disabling
patch at position 32. All 38 IGEL entries correspond to the review archive.

In the quilt-applied `partmap/igel.c`, `kernel` starts as null and its
allocation is compiled out. The section-reading loop therefore takes its
CRC-checking branch, and the later shim-validation branch requires a non-null
buffer, so it is not entered. CRC checking is distinct from signature
verification.

The generated failsafe menu entry in `fs/igelfs.c` sets
`igel_part_check=true`, scans IGEL partitions, selects `failsafe_kernel`, and
invokes `linux $failsafe_kernel`. This separates recovery selection from the
subsequent kernel-loading stage. This trace describes selection-stage checks;
it does not establish every check performed by the subsequent loader.

### YAML-controlled boot settings

`IGEL-bc-dr-emergency-mode.diff` opens YAML with `GRUB_FILE_TYPE_YAML` and adds
that file type to the shim verifier's `SKIP_VERIFICATION` cases. Its parser
places parsed keys/values in GRUB's environment; the menu code consumes values
for emergency/maintenance behavior and defaults/timeouts. This is not merely a
cosmetic change, nor does the exception itself exempt a kernel file.

The documented variables include `igel_os_default`, `boot_menu_timeout`,
`maintenance_mode`, `emergency_mode`, and `maintenance_boot_attempts`.
Together they control the default boot target, menu visibility/countdown, and
maintenance or emergency boot behavior. The documentation identifies the
Windows tray icon and GRUB selection as ways `igel_os_default` is changed.
RMagent resets `maintenance_mode` after maintenance, and the update script
increments `maintenance_boot_attempts`, which RMagent resets. Owner
clarification: the IGEL system component reads these variables and writes only
`maintenance_boot_attempts`; RMagent, a component of IGEL's UMS endpoint
management platform, writes the other variables to the file.

The IGEL EFI boot script loads this file from `${efidev}/EFI/BOOT.YML`.
It temporarily sets `check_signatures=no` for `yamlload`, then restores
`check_signatures=enforce`.

This is mutable boot state, not a static signed policy file. Requiring a valid
signature after each change would require the components that update it to
re-sign it; the verifier exception permits those intended updates without
that step. This explains the operational rationale, not write permissions or
protection against unauthorized modification, which are not established by
this code trace or the variable documentation summarized here.

### TPM measurement changes

`commands/tpm.c` registers a verifier named exactly `tpm`; therefore
`grub_strstr("tpm", ver->name)` matches this verifier despite the unusual
argument order. The applied `kern/verifiers.c` invokes its file-content
measurement callback only when the file's name contains `vmlinuz`.
That callback measures into `GRUB_BINARY_PCR`, defined as PCR 9. This is a
filename-substring rule, not a file-type or kernel-format test; it does not
mean other boot files are measured by this callback.

The separate `verify_string` callback measures kernel command lines, module
command lines, and GRUB commands passed through that interface into
`GRUB_STRING_PCR`, defined as PCR 8. The filename restriction does not alter
this path.

In `commands/efi/tpm.c`, the confidential-computing protocol GUID/function
and its measurement call are disabled. The TPM 1.2 and TPM 2.0 event-log paths
remain, including their `EV_IPL` event type. The patch name does not mean
all `EV_IPL` handling or all TPM logging is removed.

**Rationale not documented here:** the product-specific reason for this
file-measurement coverage and for disabling the confidential-computing path.
Signature verification and measured boot are different mechanisms.

### Partition variable and boot-registry filtering

After detecting IGEL boot-registry or directory magic, `iterate_real()` in
`partmap/igel.c` sets `igel_part` to `gptN` or `msdosN`. The companion
`IGEL-export-igel-part-env.diff` exports it. These are partition-identification
checks, not cryptographic authentication.

`IGEL/igel-lx_os-grub-efi.cfg` combines that name with the boot-disk prefix,
checks for `/igel.conf` on the identified partition, and sets `device` to
that partition in both dual-boot and non-dual-boot paths. Later it sources
`${device}/igel.conf` with `check_signatures=no`. The change thus ties
configuration selection to the detected IGEL-containing partition rather
than merely choosing a partition because it has a file named `igel.conf`.
The original incident implied by the patch's security-related name remains
undocumented; the filename alone establishes no security guarantee.

`fs/igelfs.c` reads the boot registry's `boot_cmd` value, calls
`filter_bootcmd()` from `fs/bootregfs.c`, and appends the result to the
generated Custom boot command entry in both menu variants. It does not
filter every generated command line.

The filter splits on spaces. A token containing `systemd` is retained only
if it also contains one of `quiet=`, `debug=`, `log_target=`, `log_level=`,
or `log_location=`; other tokens are retained. These are substring tests,
not exact option-name validation. For example, a plain
`systemd.unit=...` token is discarded from the custom arguments.
The dedicated verbose, emergency, and reset entries still explicitly supply
their own `systemd.unit` targets. If allocation of the filtered buffer fails,
the code falls back to the original unfiltered value.

This explains the implemented scope: constrain systemd-related custom
arguments while retaining selected logging/debug settings. The original
reported issue and historical motivation remain unknown; this is not a
blanket restriction on kernel arguments.
