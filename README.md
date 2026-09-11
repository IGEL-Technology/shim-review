This repo is for review of requests for signing shim. To create a request for review:

- clone this repo (preferably fork it)
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push it to GitHub
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag
- approval is ready when the "accepted" label is added to your issue

Note that we really only have experience with using GRUB2 or systemd-boot on Linux, so
asking us to endorse anything else for signing is going to require some convincing on
your part.

As of 27 June 2026, shims sent to Microsoft can only be signed by the Microsoft UEFI CA 2023. It is no longer possible to get your shim signed by the "old" Microsoft Corporation UEFI CA 2011 key. Up-to-date information from Microsoft about Secure Boot can be found here: https://support.microsoft.com/en-US/servicing/os/secure-boot/2026/02/updates-and-announcements

New signing requirements have also taken effect, and are available here: https://techcommunity.microsoft.com/blog/hardware-dev-center/updated-microsoft-uefi-signing-requirements/1062916 Please note that undergoing this shim review exempts you from yearly security audits, as long as your shim only hands off to open source boot loaders.

Hint: check the [docs](./docs/) directory in this repo for guidance on submission and getting your shim signed.

Here's the template:

*******************************************************************************
### What organization or people are asking to have this signed?
*******************************************************************************
IGEL Technology GmbH. We are a software company from Germany, building IGEL OS, a managed, Linux-based operating system.

*******************************************************************************
### What's the legal data that proves the organization's genuineness?
The reviewers should be able to easily verify, that your organization is a legal entity, to prevent abuse.
Provide the information, which can prove the genuineness with certainty.
*******************************************************************************
Company/tax register entries or equivalent:  
(a link to the organization entry in your jurisdiction's register will do)  

https://www.igel.com/legal-notice/
HRB 38302
VAT: DE 343232864
WEEE-Reg.-No. DE 79295479

The public details of both your organization and the issuer in the EV certificate used for signing .cab files at Microsoft Hardware Dev Center File Signing Services.  
(**not** the CA certificate embedded in your shim binary)

Example:

```
Issuer: O=MyIssuer, Ltd., CN=MyIssuer EV Code Signing CA
Subject: C=XX, O=MyCompany, Inc., CN=MyCompany, Inc.
```

Issuer: O=SSL Corp, CN=SSL.com EV Code Signing Intermediate CA RSA R3
Subject: C=DE, O=IGEL Technology GmbH, CN=IGEL Technology GmbH

*******************************************************************************
### What product or service is this for?
*******************************************************************************
IGEL OS. 

*******************************************************************************
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
*******************************************************************************
Our IGEL OS is rolled out onto large numbers of customer devices. Booting it with UEFI Secureboot enabled must be feasible without rolling out custom keys first.

*******************************************************************************
### Why are you unable to reuse shim from another distro that is already signed?
*******************************************************************************
We roll out GRUB and kernel updates frequently, each customized by us. The Linux kernel must fulfill hardware support for most recent devices, and needs therefore be custom-built and signed by us. Hence, GRUB needs to accept our Kernel signatures for SecureBoot. GRUB is also kept up to date and includes minor patches for IGEL OS-specific management and recovery options, therefore is also signed by us frequently.

*******************************************************************************
### Who is the primary contact for security updates, etc.?
The security contacts need to be verified before the shim can be accepted. For subsequent requests, contact verification is only necessary if the security contacts or their PGP keys have changed since the last successful verification.

An authorized reviewer will initiate contact verification by sending each security contact a PGP-encrypted email containing random words.
You will be asked to post the contents of these mails in your `shim-review` issue to prove ownership of the email addresses and PGP keys.
Please upload the PGP keys to a well-known keyserver like keyserver.ubuntu.com and/or include them in the review as an .asc file, and point to them here.

*******************************************************************************
- Name: Petersen, Arne
- Position: Linux Developer
- Email address: arne.petersen@igel.com
- PGP key fingerprint: 874E8759 4009ACD5 395BD29B 5E436F6F 4ECEB0B8
- File/keyserver location: ap-igel.asc (repo) and keyserver.ubuntu.com

*******************************************************************************
### Who is the secondary contact for security updates, etc.?
*******************************************************************************
- Name: Müller, Christina
- Position: Manager Linux Development
- Email address: christina.mueller@igel.com
- PGP key fingerprint: B432D36B F8CEFED0 9DCB6A9D 6FCDFA64 77566085
- File/keyserver location: keyserver.ubuntu.com

*******************************************************************************
### Were these binaries created from the 16.1 shim release tar?
Please create your shim binaries starting with the 16.1 shim release tar file: https://github.com/rhboot/shim/releases/download/16.1/shim-16.1.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/16.1 and contains the appropriate gnu-efi source.

Make sure the tarball is correct by verifying your download's checksum
(SHA256, SHA512) with the following ones:

```
46319cd228d8f2c06c744241c0f342412329a7c630436fce7f82cf6936b1d603  shim-16.1.tar.bz2
ca5f80e82f3b80b622028f03ef23105c98ee1b6a25f52a59c823080a3202dd4b9962266489296e99f955eb92e36ce13e0b1d57f688350006bba45f2718f159fb  shim-16.1.tar.bz2
```

Make sure that you've verified that your build process uses that file
as a source of truth (excluding external patches) and its checksum
matches. You can also further validate the release by checking the PGP
signature: there's [a detached
signature](https://github.com/rhboot/shim/releases/download/16.1/shim-16.1.tar.bz2.asc)

The release is signed by the maintainer Peter Jones - his master key
has the fingerprint `B00B48BC731AA8840FED9FB0EED266B70F4FEF10` and the
signing sub-key in the signature here has the fingerprint
`02093E0D19DDE0F7DFFBB53C1FD3F540256A1372`. A copy of his public key
is included here for reference:
[pjones.asc](https://github.com/rhboot/shim-review/blob/main/pjones.asc)

Once you're sure that the tarball you are using is correct and
authentic, please confirm this here with a simple *yes*.

A short guide on verifying public keys and signatures should be available in the [docs](./docs/) directory.
*******************************************************************************
Yes. The build is based on the shim-16.1 linked above.

*******************************************************************************
### URL for a repo that contains the exact code which was built to result in your binary:
Hint: If you attach all the patches and modifications that are being used to your application, you can point to the URL of your application here (*`https://github.com/YOUR_ORGANIZATION/shim-review`*).

You can also point to your custom git servers, where the code is hosted.
*******************************************************************************
https://github.com/IGEL-Technology/shim

*******************************************************************************
### What patches are being applied and why:
Mention all the external patches and build process modifications, which are used during your building process, that make your shim binary be the exact one that you posted as part of this application.
*******************************************************************************


 * `0001-Fix-build-with-binutils-2.46.patch` - build fix so shim compiles with
   binutils 2.46 (toolchain compatibility only; no functional/security change).
 * `IGEL-change-default-loader-to-igel.diff` - IGEL-specific change so shim loads
   `igelx64.efi` instead of `grubx64.efi` (required to boot from the IGEL USB
   stick - UDPocket) on x86_64.
 * `IGEL-change-default-loader-to-igel-arm64.diff` - the same default-loader
   change for aarch64 (loads `igelaa64.efi`).

*******************************************************************************
### Do you have the NX bit set in your shim? If so, is your entire boot stack NX-compatible and what testing have you done to ensure such compatibility?

See https://techcommunity.microsoft.com/t5/hardware-dev-center/nx-exception-for-shim-community/ba-p/3976522 for more details on the signing of shim without NX bit.
*******************************************************************************
No.

*******************************************************************************
### What exact implementation of Secure Boot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
Skip this, if you're not using GRUB2.
*******************************************************************************
We're using the Debian implementation.

*******************************************************************************
### Do you have fixes for all the following GRUB2 CVEs applied?
**Skip this, if you're not using GRUB2, otherwise make sure these are present and confirm with _yes_.**

* 2020 July - BootHole
  * Details: https://lists.gnu.org/archive/html/grub-devel/2020-07/msg00034.html
  * CVE-2020-10713
  * CVE-2020-14308
  * CVE-2020-14309
  * CVE-2020-14310
  * CVE-2020-14311
  * CVE-2020-15705
  * CVE-2020-15706
  * CVE-2020-15707
* March 2021
  * Details: https://lists.gnu.org/archive/html/grub-devel/2021-03/msg00007.html
  * CVE-2020-14372
  * CVE-2020-25632
  * CVE-2020-25647
  * CVE-2020-27749
  * CVE-2020-27779
  * CVE-2021-3418 (if you are shipping the shim_lock module)
  * CVE-2021-20225
  * CVE-2021-20233
* June 2022
  * Details: https://lists.gnu.org/archive/html/grub-devel/2022-06/msg00035.html, SBAT increase to 2
  * CVE-2021-3695
  * CVE-2021-3696
  * CVE-2021-3697
  * CVE-2022-28733
  * CVE-2022-28734
  * CVE-2022-28735
  * CVE-2022-28736
  * CVE-2022-28737
* November 2022
  * Details: https://lists.gnu.org/archive/html/grub-devel/2022-11/msg00059.html, SBAT increase to 3
  * CVE-2022-2601
  * CVE-2022-3775
* October 2023 - NTFS vulnerabilities
  * Details: https://lists.gnu.org/archive/html/grub-devel/2023-10/msg00028.html, SBAT increase to 4
  * CVE-2023-4693
  * CVE-2023-4692
* February 2025
  * Details: https://lists.gnu.org/archive/html/grub-devel/2025-02/msg00024.html, SBAT increase to 5
  * CVE-2024-45774
  * CVE-2024-45775
  * CVE-2024-45776
  * CVE-2024-45777
  * CVE-2024-45778
  * CVE-2024-45779
  * CVE-2024-45780
  * CVE-2024-45781
  * CVE-2024-45782
  * CVE-2024-45783
  * CVE-2025-0622
  * CVE-2025-0624
  * CVE-2025-0677
  * CVE-2025-0678
  * CVE-2025-0684
  * CVE-2025-0685
  * CVE-2025-0686
  * CVE-2025-0689
  * CVE-2025-0690
  * CVE-2025-1118
  * CVE-2025-1125
*******************************************************************************
Yes. CVE-2022-28737 is actually not a GRUB CVE, but fixed in shim upstream here (and thus fixed in our build):

https://github.com/rhboot/shim/commit/159151b6649008793d6204a34d7b9c41221fb4b0
https://github.com/rhboot/shim/commit/e99bdbb827a50cde019393d3ca1e89397db221a7

*******************************************************************************
### If shim is loading GRUB2 bootloader, and if these fixes have been applied, is the upstream global SBAT generation in your GRUB2 binary set to 5?
Skip this, if you're not using GRUB2, otherwise do you have an entry in your GRUB2 binary similar to:  
`grub,5,Free Software Foundation,grub,GRUB_UPSTREAM_VERSION,https://www.gnu.org/software/grub/`?
*******************************************************************************
Yes. Our GRUB2 binaries carry the upstream generation 5 entry:
`grub,5,Free Software Foundation,grub,2.12,https://www.gnu.org/software/grub/`
(see the full SBAT listings below).

*******************************************************************************
### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
If you had no previous signed shim, say so here. Otherwise a simple _yes_ will do.
*******************************************************************************
Yes. Our previous signed shim was 15.8 (x86_64 only; aarch64 is a first-time
submission with no predecessor, so there is no old aarch64 shim to revoke). The
Authenticode SHA256 of the 15.8 shim to be added to a future DBX update is:
`4395fc204a448b26d4f05486f6fc56e2ae421a33c6eed36707fb6936b2ccc952`

*******************************************************************************
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
Hint: upstream kernels should have all these applied, but if you ship your own heavily-modified older kernel version, that is being maintained separately from upstream, this may not be the case.  
If you are shipping an older kernel, double-check your sources; maybe you do not have all the patches, but ship a configuration, that does not expose the issue(s).
*******************************************************************************
Yes. Our kernel originates from upstream and has the respective patch commits included.

*******************************************************************************
### How does your signed kernel enforce lockdown when your system runs with Secure Boot enabled?
Hint: If it does not, we are not likely to sign your shim.
*******************************************************************************
Our kernel is loaded only through the signed chain of trust (signed shim ->
signed GRUB2 -> signed kernel), and it is built with the lockdown LSM compiled in
and forced to integrity mode:

    CONFIG_SECURITY_LOCKDOWN_LSM=y
    CONFIG_SECURITY_LOCKDOWN_LSM_EARLY=y
    CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY=y
    (CONFIG_LOCK_DOWN_KERNEL_FORCE_NONE and _FORCE_CONFIDENTIALITY are not set)

Because CONFIG_SECURITY_LOCKDOWN_LSM_EARLY is enabled, lockdown is active from
early boot, and CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY automatically places the
kernel in integrity lockdown mode whenever UEFI Secure Boot is detected - no
kernel command line option is required or can weaken it. Lockdown is the first
module in the LSM stack:

    CONFIG_LSM="lockdown,yama,integrity,apparmor,bpf"

In this mode the interfaces that could be used to modify the running kernel or
extract kernel memory (kexec of unsigned images, /dev/mem and /dev/kmem,
unsigned module loading, hibernation to an unverified image, BPF paths into
kernel memory, etc.) are blocked, and kernel modules must be signed:

    CONFIG_MODULE_SIG=y
    CONFIG_MODULE_SIG_FORCE=y
    CONFIG_MODULE_SIG_ALL=y
    CONFIG_MODULE_SIG_KEY="certs/kernel_key.pem"

so an unsigned or tampered module is refused. The three upstream lockdown
hardening commits are present in our 6.18.35 source (1957a85b efivar_ssdt_load,
75b0cea7 ACPI configfs table loading, eadb2f47 kgdb), closing the known
lockdown-bypass paths.

For three specific hardware-management use cases we apply narrowly-scoped,
compile-time exceptions to lockdown. Each permits only a single, tightly-filtered
operation and falls back to the normal security_locked_down() check for
everything else:

  - MSR writes (LOCKDOWN_MSR): only to the HWP/energy-management MSRs
    MSR_HWP_REQUEST, MSR_HWP_REQUEST_PKG, MSR_PM_ENABLE and MSR_IA32_MISC_ENABLE
    (write size <= 8 bytes), used by x86_energy_perf_policy for CPU power
    management. All other MSR writes remain blocked.
    (CONFIG_IGEL_ALLOW_ENERGY_POLICY, arch/x86/kernel/msr.c)

  - PCI config writes (LOCKDOWN_PCI_ACCESS): only to the AMD host bridge
    (vendor 0x1022, class 0x60000) at offsets 0xB8/0xBC (write size <= 4 bytes),
    used by ryzenadj to lower idle power draw. All other PCI config writes remain
    blocked. (CONFIG_IGEL_ALLOW_RYZENADJ, drivers/pci/pci-sysfs.c)

  - iopl() (LOCKDOWN_IOPORT): permitted only for the HP BIOS-configuration tool
    LnxBCU, used to read/write BIOS settings. All other iopl() callers remain
    blocked. (CONFIG_IGEL_ALLOW_HP_LNXBCU_IOPL, arch/x86/kernel/ioport.c)

These exceptions do not permit loading unsigned code or unsigned kernel modules
and do not disable the lockdown LSM; the signed-module and signed-boot-chain
guarantees above remain fully in force.

*******************************************************************************
### Do you build your signed kernel with additional local patches? What do they do?
*******************************************************************************
We generally backport fixes and features from newer development kernels to our LTS kernels. For example, we're currently on 6.18.x (kernel 6.18.35) and pull in backports from newer kernels where needed.

 * We apply various patches to support also the most recent hardware, e.g.
    * HP mt645
    * Surface tablets
    * MediaTek Wi-Fi adapters (e.g. MT7902/MT7925/MT7927)
 * We have IGEL OS-specific features in the kernel
    * IGEL Flash Driver, a kind of logical volume manager optimized for small flash memory devices providing checksum validation, encryption, etc.
 * For three hardware-management use cases we apply narrowly-scoped, compile-time
   exceptions to the kernel lockdown LSM. Each permits only a single,
   tightly-filtered operation and falls back to the normal
   security_locked_down() check for everything else (see the lockdown-enforcement
   answer above for details):
    * CONFIG_IGEL_ALLOW_ENERGY_POLICY (arch/x86/kernel/msr.c) - allows MSR writes
      only to the HWP/energy MSRs used by x86_energy_perf_policy for CPU power
      management; all other MSR writes stay blocked under lockdown.
    * CONFIG_IGEL_ALLOW_RYZENADJ (drivers/pci/pci-sysfs.c) - allows PCI config
      writes only to the AMD host bridge (vendor 0x1022, offsets 0xB8/0xBC) used
      by ryzenadj to lower idle power draw; all other PCI config writes stay
      blocked under lockdown.
    * CONFIG_IGEL_ALLOW_HP_LNXBCU_IOPL (arch/x86/kernel/ioport.c) - allows the
      iopl() syscall only for the HP LnxBCU BIOS-configuration tool; all other
      iopl() callers stay blocked under lockdown.
   None of these allow loading unsigned code or unsigned kernel modules, and none
   disable the lockdown LSM.


*******************************************************************************
### Do you use an ephemeral key for signing kernel modules?
### If not, please describe how you ensure that one kernel build does not load modules built for another kernel.
*******************************************************************************
No. The kernel loads only modules signed off by us. We're not using ephemeral keys, yet, but plan to use them in the future. In the meantime, loading kernel modules built for another kernel is almost impossible because both kernel and modules are delivered in one closed system. If additional modules are provided to the system, they will be loaded from a directory matching the kernel version, thereby preventing different versions from being loaded, too.

Other than that, only modules signed by us will be loaded, thus it's not possible to inject modules from other distributions.

*******************************************************************************
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
*******************************************************************************
No.

*******************************************************************************
### If you are re-using the CA certificate from your last shim binary, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs mentioned earlier to vendor_dbx in shim. Please describe your strategy.
This ensures that your new shim+GRUB2 can no longer chainload those older GRUB2 binaries with issues.

If this is your first application or you're using a new CA certificate, please say so here.
*******************************************************************************
We re-use our existing IGEL CA. Rather than listing old GRUB2 hashes in vendor_dbx, we revoke the old CVE-affected GRUB2 builds via SBAT: our new GRUB is grub,5 and the shim's SBAT level requires grub,5, so the previous grub,4 builds are refused by shim.

*******************************************************************************
### Is the Dockerfile in your repository the recipe for reproducing the building of your shim binary?
A reviewer should always be able to run `docker build .` to get the exact binary you attached in your application.

Hint: Prefer using *frozen* packages for your toolchain, since an update to GCC, binutils, gnu-efi may result in building a shim binary with a different checksum.

If your shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case, what the differences would be and what build environment (OS and toolchain) is being used to reproduce this build? In this case please write a detailed guide, how to setup this build environment from scratch.
*******************************************************************************
N/A. You can just use the provided Dockerfile.

*******************************************************************************
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
*******************************************************************************
build-amd64.log and build-arm64.log: attached are the full container logs (one per architecture, x86_64 and aarch64), including debuild with all build steps, comparing against upstream shim 16.1, and so on. The last step of each log outputs the resulting sha256sum of the submitted shimx64.efi / shimaa64.efi respectively.

*******************************************************************************
### What changes were made in the distro's secure boot chain since your SHIM was last signed?
For example, signing new kernel's variants, UKI, systemd-boot, new certs, new CA, etc..

Skip this, if this is your first application for having shim signed.
*******************************************************************************


 * Updated shim from 15.8 to 16.1 (confirmed: shim.igel SBAT = 16.1 in the binaries).
 * Updated GRUB from 2.06 to 2.12 (Debian trixie, 2.12-9+deb13u2, SBAT
   generation grub,5; confirmed from the rebuilt signed binaries in /work/grub2
   and folder 12_10).

 * Added aarch64 (arm64) support: this submission now covers both x86_64
   (shimx64.efi) and aarch64 (shimaa64.efi).
 * No new certificates this cycle: the existing IGEL CA (the self-signed IGEL
   Root CA embedded in shim) and the corresponding kernel/GRUB signing keys were
   reused - they are unchanged from the previous submission.

*******************************************************************************
### What is the SHA256 hash of your final shim binary?
*******************************************************************************
```
f3e341afc4fb3eee34f740a5c438bf1082800b05e23eec5a01e176a7811afd56  shimx64.efi
42185722a4f3f8f47f9b416fcab46be0269bc99d13e8cc9b838e879cc6ee7faf  shimaa64.efi
```

*******************************************************************************
### How do you manage and protect the keys used in your shim?
Describe the security strategy that is used for key protection. This can range from using hardware tokens like HSMs or Smartcards, air-gapped vaults, physical safes to other good practices.
*******************************************************************************
The keys are generated on a NitroKey HSM, which is stored in a safe in the company's facility.

*******************************************************************************
### Do you use EV certificates as embedded certificates in the shim?
A _yes_ or _no_ will do. There's no penalty for the latter.
*******************************************************************************
No.

*******************************************************************************
### Are you embedding a CA certificate in your shim?
A _yes_ or _no_ will do. There's no penalty for the latter. However,
if _yes_: does that certificate include the X509v3 Basic Constraints
to say that it is a CA? See the [docs](./docs/) for more guidance
about this.
*******************************************************************************
Yes. We embed a single CA certificate in the shim: `igel-uefi-ca.der`
(committed in this repository). It is a self-signed IGEL root CA
(Subject = Issuer = "C=DE, ST=Bremen, L=Bremen, O=IGEL Technology GmbH,
OU=IGEL Technology GmbH Certificate Authority, CN=IGEL Technology GmbH Root CA").

Yes, it carries the X509v3 Basic Constraints extension marked critical with
`CA:TRUE`. All of our GRUB2 and kernel binaries are signed by keys that chain
to this CA.

*******************************************************************************
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( GRUB2, fwupd, fwupdate, systemd-boot, systemd-stub, shim + all child shim binaries )?
### Please provide the exact SBAT entries for all binaries you are booting directly through shim.
Hint: The history of SBAT and more information on how it works can be found [here](https://github.com/rhboot/shim/blob/main/SBAT.md). That document is large, so for just some examples check out [SBAT.example.md](https://github.com/rhboot/shim/blob/main/SBAT.example.md)

If you are using a downstream implementation of GRUB2 (e.g. from Fedora or Debian), make sure you have their SBAT entries preserved and that you **append** your own (don't replace theirs) to simplify revocation.

**Remember to post the entries of all the binaries. Apart from your bootloader, you may also be shipping e.g. a firmware updater, which will also have these.**

Hint: run `objcopy --dump-section .sbat=/dev/stdout YOUR_EFI_BINARY` to get these entries. Paste them here. Preferably surround each listing with three backticks (\`\`\`), so they render well.
*******************************************************************************
shimx64.efi
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,4,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.igel,1,Igel,shim,16.1,https://www.igel.com
```

shimaa64.efi
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,4,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.igel,1,Igel,shim,16.1,https://www.igel.com
```

igelx64.efi
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,5,Free Software Foundation,grub,2.12,https://www.gnu.org/software/grub/
grub.debian,5,Debian,grub2,2.12-9+deb13u2,https://tracker.debian.org/pkg/grub2
grub.igel,5,Igel,grub2,2.12-9+deb13u2igel1787746502,https://www.igel.com
```

igelaa64.efi
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,5,Free Software Foundation,grub,2.12,https://www.gnu.org/software/grub/
grub.debian,5,Debian,grub2,2.12-9+deb13u2,https://tracker.debian.org/pkg/grub2
grub.igel,5,Igel,grub2,2.12-9+deb13u2igel1787746502,https://www.igel.com
```

fwupdx64.efi
```
sbat,1,UEFI shim,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
fwupd-efi,1,Firmware update daemon,fwupd-efi,1.8,https://github.com/fwupd/fwupd-efi
fwupd-efi.debian,1,Debian,fwupd,1:1.8-3,https://tracker.debian.org/pkg/fwupd
```

*******************************************************************************
### If shim is loading GRUB2 bootloader, which modules are built into your signed GRUB2 image?
Skip this, if you're not using GRUB2.

Hint: this is about those modules that are in the binary itself, not the `.mod` files in your filesystem.
*******************************************************************************
igelx64.efi (104 modules):
```
acpi all_video archelp bitmap bitmap_scale boot btrfs bufio cat chain
configfile cpuid crypto datetime disk diskfilter echo efi_gop efi_uga
efifwsetup efinet elf eval ext2 extcmd fat file find_udp_boot_id
find_win_boot_id font fshelp functional_test gcry_crc gcry_rsa gcry_sha1
gcry_sha256 gcry_sha512 gettext gfxmenu gfxterm gfxterm_background
gfxterm_menu gzio halt hashsum hfsplus igelfs jpeg keystatus linux linux16
loadenv ls lzopio macho memdisk minicmd mmap mpi msdospart net normal ntfs
offsetio part_gpt part_igel part_msdos parttool password_pbkdf2 pbkdf2
peimage pgp play png priority_queue procfs raid6rec regexp relocator search
search_fs_file search_fs_uuid search_label set_next_boot setjmp squash4
terminal test tpm tr trig true udf video video_bochs video_cirrus
video_colors video_fb videoinfo videotest winbootnext xzio yaml zstd
```

igelaa64.efi (94 modules):
```
all_video archelp bitmap bitmap_scale boot btrfs bufio cat chain configfile
crypto datetime disk diskfilter echo efi_gop efifwsetup efinet elf eval ext2
extcmd fat fdt file find_udp_boot_id find_win_boot_id font fshelp
functional_test gcry_crc gcry_rsa gcry_sha1 gcry_sha256 gcry_sha512 gettext
gfxmenu gfxterm gfxterm_background gfxterm_menu gzio halt hashsum hfsplus
jpeg keystatus linux loadenv ls lzopio macho memdisk minicmd mmap mpi
msdospart net normal ntfs offsetio part_gpt part_msdos parttool
password_pbkdf2 pbkdf2 peimage pgp png priority_queue procfs raid6rec regexp
search search_fs_file search_fs_uuid search_label set_next_boot setjmp
squash4 terminal test tr trig true udf video video_colors video_fb
videoinfo videotest winbootnext xzio yaml zstd
```

*******************************************************************************
### If you are using systemd-boot on arm64 or riscv, is the fix for [unverified Devicetree Blob loading](https://github.com/systemd/systemd/security/advisories/GHSA-6m6p-rjcq-334c) included?
*******************************************************************************
N/A

*******************************************************************************
### What is the origin and full version number of your bootloader (GRUB2 or systemd-boot or other)?
*******************************************************************************
GRUB2 2.12, Debian trixie (source package version 2.12-9+deb13u2).

*******************************************************************************
### If your shim launches any other components apart from your bootloader, please provide further details on what is launched.
Hint: The most common case here will be a firmware updater like fwupd.
*******************************************************************************
We launch fwupd during BIOS updates. This applies to the x86_64 platform only; the aarch64 platform does not ship fwupd, so its boot chain is shim → GRUB → kernel.

*******************************************************************************
### If your GRUB2 or systemd-boot launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
Skip this, if you're not using GRUB2 or systemd-boot.
*******************************************************************************
 * fwupd (x86_64 only; not shipped on aarch64)

*******************************************************************************
### How do the launched components prevent execution of unauthenticated code?
Summarize in one or two sentences, how your secure bootchain works on higher level.
*******************************************************************************
 * GRUB2 checks the launched components and only boots into kernels signed off by us.
 * Our kernel is built with security lockdown patches, and only boots from read-only partitions also signed by us.
 * Newer versions of IGEL OS containing the updated bootloader will have LOCKDOWN\_FORCE\_INTEGRITY enabled.

*******************************************************************************
### Does your shim load any loaders that support loading unsigned kernels (e.g. certain GRUB2 configurations)?
*******************************************************************************
No — no unsigned kernel can be booted under Secure Boot.

One patch may look like an exception at first glance and we want to call it out explicitly: `IGEL-disable-secure-boot-validation-in-failsafe.diff`. Despite its name, it does **not** disable kernel verification. Our custom IGEL-partition code (`grub-core/partmap/igel.c`) contained a *second, redundant* signature check performed while **selecting** which failsafe system partition to boot: it read the candidate kernel into a temporary buffer, called shim's verify protocol, and freed the buffer again. This patch removes that selection-time check.

The kernel that is actually booted is loaded afterwards by GRUB's normal `linux` command (`linux $device/vmlinuz ... failsafe`) from the IGEL filesystem. That load goes through the upstream shim_lock verifier (`GRUB_FILE_TYPE_LINUX_KERNEL` is not skipped), so the failsafe kernel is still verified by shim before it is executed. All boot paths — normal, verbose, emergency, reset-to-factory and failsafe — load the kernel with the `linux` command. No boot path uses `linux16`, `chainloader`, `kexec` or a direct `LoadImage` for the kernel.

Net effect of the patch: failsafe partition *selection* no longer pre-validates the signature, but an unsigned or tampered kernel is still refused by shim at load time.

*******************************************************************************
### What kernel are you using? Which patches and configuration does it include to enforce Secure Boot?
*******************************************************************************
Upstream 6.18.35. The following module configuration will be present in the version with the updated shim:
```
CONFIG_SECURITY_LOCKDOWN_LSM=y
CONFIG_SECURITY_LOCKDOWN_LSM_EARLY=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY=y
```

*******************************************************************************
### What contributions have you made to help us review the applications of other applicants?
The reviewing process is meant to be a peer-review effort and the best way to have your application reviewed faster is to help with reviewing others. We are in most cases volunteers working on this venue in our free time, rather than being employed and paid to review the applications during our business hours. 

A reasonable timeframe of waiting for a review can reach 2-3 months. Helping us is the best way to shorten this period. The more help we get, the faster and the smoother things will go.

For newcomers, the applications labeled as [*easy to review*](https://github.com/rhboot/shim-review/issues?q=is%3Aopen+is%3Aissue+label%3A%22easy+to+review%22) are recommended to start the contribution process.
*******************************************************************************
- [ZeronsoftN shim-x86_64_ia32_aarch64-20240730](https://github.com/rhboot/shim-review/issues/433#issuecomment-2503931398)
- [Shim 15.8 for UOS Linux (x86_64) by UnionTech](https://github.com/rhboot/shim-review/issues/431#issuecomment-2589423221)
- [Parted Magic shim 16.1 x64](https://github.com/rhboot/shim-review/issues/588#issuecomment-5629812137)
- [Shim 16.1 amd64 and arm64 for Pexip PexOS](https://github.com/rhboot/shim-review/issues/590#issuecomment-5829396839)

We plant to continue with community reviews but the list might not be up to date.

*******************************************************************************
### Add any additional information you think we may need to validate this shim signing application.
*******************************************************************************
N/A.
