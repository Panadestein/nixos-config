#!/usr/bin/env fish
# This script fetches the commit hashes of the CBQN repository and its submodules
# and uses nix-prefetch-url to fetch the tarballs of the main repository and submodules.
# It then prints the filled Nix expressions for the fetchFromGitHub function.

begin
    # Clone the CBQN repository and navigate into it.
    git clone https://github.com/dzaima/CBQN.git >/dev/null
    cd CBQN
    set main_commit (git log -1 --format=%H)

    # Extract submodule commit hashes from the tree.
    set submodules (git ls-tree -r HEAD | grep '^160000' | awk '{print $3}')

    # Use nix-prefetch-url to fetch the tarballs and capture their outputs.
    set output_cbqn (nix-prefetch-url --unpack "https://github.com/dzaima/CBQN/archive/$main_commit.tar.gz")
    set output_bytecode (nix-prefetch-url --unpack "https://github.com/dzaima/cbqnBytecode/archive/$submodules[1].tar.gz")
    set output_replxx (nix-prefetch-url --unpack "https://github.com/dzaima/replxx/archive/$submodules[2].tar.gz")
    set output_singeli (nix-prefetch-url --unpack "https://github.com/mlochbaum/Singeli/archive/$submodules[3].tar.gz")

    # Convert the fetched hashes to sha256.
    set hash_cbqn (nix hash convert --hash-algo sha256 $output_cbqn)
    set hash_bytecode (nix hash convert --hash-algo sha256 $output_bytecode)
    set hash_replxx (nix hash convert --hash-algo sha256 $output_replxx)
    set hash_singeli (nix hash convert --hash-algo sha256 $output_singeli)
end &>/dev/null

# Print the filled Nix expressions.
echo ""
echo "  cbqnSrc = fetchFromGitHub {"
echo "    owner = \"dzaima\";"
echo "    repo = \"CBQN\";"
echo "    rev = \"$main_commit\";"
echo "    hash = \"$hash_cbqn\";"
echo "  };"
echo ""
echo "  cbqnBytecode = fetchFromGitHub {"
echo "    owner = \"dzaima\";"
echo "    repo = \"cbqnBytecode\";"
echo "    rev = \"$submodules[1]\";"
echo "    hash = \"$hash_bytecode\";"
echo "  };"
echo ""
echo "  replxx = fetchFromGitHub {"
echo "    owner = \"dzaima\";"
echo "    repo = \"replxx\";"
echo "    rev = \"$submodules[2]\";"
echo "    hash = \"$hash_replxx\";"
echo "  };"
echo ""
echo "  singeli = fetchFromGitHub {"
echo "    owner = \"mlochbaum\";"
echo "    repo = \"Singeli\";"
echo "    rev = \"$submodules[3]\";"
echo "    hash = \"$hash_singeli\";"
echo "  };"

# Clean up by removing the cloned repository.
cd ..
rm -rf CBQN
