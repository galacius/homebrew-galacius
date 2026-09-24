cask "galacius" do
  version "1.1.4"
  sha256 "3eeb9850e90c9f5e2882ca31862edc1ee316a4332026b4ea3d9c7b3b817482e9"

  url "https://github.com/galacius/galacius/releases/download/v#{version}/galacius-darwin-arm64.zip"
  name "Galacius"
  desc "Lightweight Kubernetes desktop dashboard"
  homepage "https://github.com/galacius/galacius"

  app "galacius.app"

  depends_on arch: :arm64

  postflight_steps do
    # The app is ad-hoc signed, not notarized. Homebrew preserves the
    # com.apple.quarantine xattr on extraction, which makes Gatekeeper
    # refuse to open it at all (no "Open Anyway" override). Strip
    # quarantine and re-sign ad-hoc, mirroring scripts/install.sh.
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/galacius.app"]
    run "/usr/bin/codesign",
        args: ["--force", "--deep", "--sign", "-", "{{appdir}}/galacius.app"]

    # Record that this install came from Homebrew, so the app's own
    # runtime detection (which can be fooled by app translocation or
    # a  binary missing from a GUI process's PATH) doesn't have
    # to guess. Read by internal/storage.ReadInstallSource, which
    # internal/updater.DetectInstallSource consults before falling
    # back to its own heuristics. Reruns (upgrade/reinstall) simply
    # overwrite this with the same value.
    mkdir_p ".galacius", base: :home
    write_file ".galacius/install-source", "homebrew", base: :home
  end

  uninstall trash: [
    "~/.galacius/install-source",
  ]

  caveats do
    <<~EOS
      Galacius is ad-hoc signed, not notarized. This cask strips the
      quarantine attribute and re-signs the app after install so
      Gatekeeper won't block it. If macOS still shows a warning on
      first launch, open System Settings > Privacy & Security and
      click "Open Anyway" next to Galacius.

      Galacius's built-in self-updater is disabled for Homebrew installs.
      To upgrade, run:
        brew update && brew upgrade galacius

      `brew update` refreshes Homebrew's local tap cache; `brew upgrade` alone
      may report "already installed" if that cache is stale.
    EOS
  end

  livecheck do
    url :url
    strategy :github_latest_release
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end
end
