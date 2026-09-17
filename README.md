# homebrew-galacius

Homebrew tap for [Galacius](https://github.com/galacius/galacius), a lightweight Kubernetes desktop dashboard.

> **Note:** `brew search galacius` will not find this tap — Homebrew doesn't index third-party taps. You must tap it explicitly first (see below).

## Install

```bash
brew tap galacius/homebrew-galacius
brew trust galacius/galacius/galacius
brew install galacius
```

## Upgrade

Galacius has a built-in self-updater that Homebrew is not aware of. If you installed via Homebrew, prefer:

```bash
brew upgrade galacius
```

over the in-app updater, to keep versions in sync.

## Supported platforms

macOS (Apple Silicon / arm64) only.

## About this tap

This tap is automatically updated by Galacius's CD pipeline on every release — the cask in `Casks/galacius.rb` is regenerated and published as part of `galacius/galacius`'s `job-build.yml` workflow. Manual edits will be overwritten on the next release.
