require "language/haskell"

class ElmFormat < Formula
  include Language::Haskell::Cabal
  desc "Elm source code formatter, inspired by gofmt."
  homepage "https://github.com/avh4/elm-format"

  head "https://github.com/avh4/elm-format.git"

  devel do
    url "https://github.com/avh4/elm-format/archive/0.2.0-alpha.tar.gz"
    version "0.2.0-alpha"
    sha256 "b965ba2a1633524da7fd2bc16eb07b2855c9f9b929024450dbc4256b3a127997"
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    (buildpath/"elm-format").install Dir["*"]

    # GHC 8 compat
    (buildpath/"cabal.config").write("allow-newer aeson,base,transformers\n")

    cabal_sandbox do
      cabal_sandbox_add_source "elm-format"
      cabal_install "--only-dependencies", "elm-format"
      cabal_install "--prefix=#{prefix}", "elm-format"
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<-EOS.undent
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format", testpath/"Hello.elm", "--yes"
  end
end
