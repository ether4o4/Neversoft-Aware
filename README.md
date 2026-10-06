# NeverSoft Aware


## Latest polish test APK

[Download the newest verified test APK — rolling release page](https://github.com/ether4o4/Neversoft-Aware/releases/tag/polish-test-latest)

This separate prerelease channel contains **test APKs**, with source commit, package/version, native ABI and SHA-256 recorded on the release page. Open **Download newest verified test APK** on that page. Phone runtime testing is incomplete; test signing may differ from an installed/store version. Private repository downloads require GitHub access.

While this PR remains unmerged, a successful **Polish verification** build on `polish/mobile-2026-10-05` refreshes the channel (remove/reapply the `polish-verify` PR label to run verification). The initial download reuses the already verified polish build. After merge, successful **Build Publish and Verify APK** builds on `main` also refresh it through `workflow_run`. Only trusted same-repository intended workflows/refs qualify; failed, older or diverging builds leave the working download intact. Versioned APK assets remain available, avoiding a replacement gap. Existing release channels keep their current behavior.

The stable link opens a release page; the highlighted APK filename changes after each accepted build. The channel tag anchors `main`; the release body identifies the actual APK source commit. These README additions and future `main` automation take effect on the default branch only after this PR is merged.


NeverSoft Aware is an Android-first local investigation workspace built for Termux users. It keeps case files and evidence in app-specific storage, hashes imported evidence, profiles CSV/JSON/text/media files, resolves domains, generates Termux reports, and connects to an Ollama-compatible local model endpoint.

## Install the APK

Open **Releases**, select **NeverSoft Aware — Latest APK**, and download `NeverSoft-Aware.apk`.

The release includes `NeverSoft-Aware.apk.sha256` for integrity verification.

## Core features

- Native Android case workspace
- Evidence import with SHA-256 manifest
- CSV, JSON, text, image, audio, and video profiling
- URL, email, IPv4, phone, and domain extraction
- Domain resolution and Termux report command generation
- Termux RUN_COMMAND integration
- One-tap CLI installation/update
- Ollama-compatible local AI analysis
- Report export to `Downloads/NeverSoft`
- Configurable support for `com.termux` and custom Termux package IDs

## Termux CLI

Install directly in Termux:

```bash
curl -fsSL https://raw.githubusercontent.com/ether4o4/Neversoft-Aware/main/termux/install.sh | bash
source ~/.bashrc
ns status
```

Useful commands:

```bash
ns doctor
ns case create account_recovery
ns case import account_recovery ~/storage/downloads/export.csv
ns case hash account_recovery
ns analyze ~/storage/downloads/nextdns.csv
ns extract domains ~/storage/downloads/log.txt
ns dns example.com --scan
ns ai --file ~/NeverSoft/Reports/report.txt
```

## Termux integration setup

NeverSoft Aware requests `com.termux.permission.RUN_COMMAND`. Termux also needs this line in `~/.termux/termux.properties`:

```text
allow-external-apps=true
```

The app can apply this setting from its Settings page.

## Data handling

File analysis, hashing, case management, and extraction run locally. Ollama prompts are sent only to the endpoint configured in the app. Use the toolkit only on data, systems, and accounts you own or are authorized to examine.

## Build

```bash
gradle assembleDebug
```

The GitHub Actions workflow builds and publishes an installable APK on every push to `main`.
