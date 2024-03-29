class KubernetesCliAT1204 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.20.4",
      revision: "e87da0bd6e03ec3fea7933c4b5263d151aafd07c"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go@1.16" => :build

  uses_from_macos "rsync" => :build

  # ARM support, remove for next release and reinstate test
  patch do
    url "https://github.com/kubernetes/kubernetes/commit/f719624654c68d143cad4e4af2f21cca0bfde8fd.patch?full_index=1"
    sha256 "3d40308a2f639c1a45a2105889776f0d02dd97000c188bc4cc78de739d5f0776"
  end

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    # Make binary
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kubectl", "completion", "bash")
    (bash_completion/"kubectl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kubectl", "completion", "zsh")
    (zsh_completion/"_kubectl").write output

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/generate-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")

    # Due to ARM patch reinstate for next release
    # assert_match "GitTreeState:\"clean\"", version_output

    if build.stable?
      assert_match stable.instance_variable_get(:@resource)
                         .instance_variable_get(:@specs)[:revision],
                   version_output
    end
  end
end
