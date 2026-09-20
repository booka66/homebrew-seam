class Seam < Formula
  desc "Read a change by definition rather than by file"
  homepage "https://github.com/booka66/seam"
  url "https://github.com/booka66/seam/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "87ec4f8662c2ef37bd0db41117e527c3444233dfa82402a09e2a44d71f68e7f1"

  depends_on "ast-grep"
  depends_on "jq"

  def install
    # seam finds share/ next to its own bin/, so keep the two together in
    # libexec and put a wrapper on PATH rather than a symlink.
    libexec.install "bin", "share"
    bin.write_exec_script libexec/"bin/seam"
  end

  test do
    system "git", "init", "-q", "."
    system "git", "config", "user.email", "t@t"
    system "git", "config", "user.name", "t"
    (testpath/"a.ts").write "export function f(x: number) { return x }\n"
    system "git", "add", "."
    system "git", "commit", "-qm", "a"
    File.write testpath/"a.ts", "export function f(x: string) { return x }\n"
    system "git", "commit", "-qam", "b"
    assert_match "f", shell_output("#{bin}/seam HEAD~..HEAD")
    assert_match "typescript", shell_output("#{bin}/seam --languages")
  end
end
