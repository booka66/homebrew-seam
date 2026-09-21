class Seam < Formula
  desc "Read a change by definition rather than by file"
  homepage "https://github.com/booka66/seam"
  url "https://github.com/booka66/seam/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "565659af8a80783d175200267a1d8187f949da2de58b274601dc7bf48c9bfb2b"

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
