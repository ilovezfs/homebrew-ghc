require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "http://darcs.net/releases/darcs-2.12.0.tar.gz"
  sha256 "54616b826bfb1d0d999d2e8050338052a82b427e888c14d57625168eff83bb3e"

  bottle do
    sha256 "a65c9d857fd868ff6768c3076511b6bfe5d11f893b58a3d943ae7b0319db73d3" => :el_capitan
    sha256 "7e76c59e699d4941880fea6986d13d62ceb4d0b60736e54f813f4d79ec4810da" => :yosemite
    sha256 "c7f60a61ab519b61d7ea229e3e67c9d1c75b1c39d49da5b07dfcdf8fe4e11658" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    # GHC 8 compat
    (buildpath/"cabal.config").write("allow-newer: base\n")

    install_cabal_package
  end

  test do
    mkdir "my_repo" do
      system "darcs", "init"
      (Pathname.pwd/"foo").write "hello homebrew!"
      system "darcs", "add", "foo"
      system "darcs", "record", "-am", "add foo", "--author=homebrew"
    end
    system "darcs", "get", "my_repo", "my_repo_clone"
    Dir.chdir "my_repo_clone" do
      assert_match "hello homebrew!", (Pathname.pwd/"foo").read
    end
  end
end
