#! /bin/sh

set -eu

LINKERD2_VERSION=${LINKERD2_VERSION:-stable-2.0.0}

if [ "$(uname -s)" = "Darwin" ]; then
  OS=darwin
else
  OS=linux
fi

tmp=$(mktemp -d /tmp/linkerd2.XXXXXX)
filename="linkerd2-cli-${LINKERD2_VERSION}-${OS}"
url="https://github.com/linkerd/linkerd2/releases/download/${LINKERD2_VERSION}/${filename}"
(
  cd "$tmp"

  echo "Downloading ${filename}..."

  SHA=$(curl -sL "${url}.sha256")
  curl -LO "${url}"
  echo ""
  echo "Download complete!, validating checksum..."
  checksum=$(openssl dgst -sha256 "${filename}" | awk '{ print $2 }')
  if [ "$checksum" != "$SHA" ]; then
    echo "Checksum validation failed." >&2
    exit 1
  fi
  echo "Checksum valid."
  echo ""
)

(
  cd "$HOME"
  mkdir -p ".linkerd2/bin"
  mv "${tmp}/${filename}" ".linkerd2/bin/linkerd"
  chmod +x ".linkerd2/bin/linkerd"
)

rm -r "$tmp"

echo "Linkerd was successfully installed 🎉"
echo ""
echo "Add the linkerd CLI to your path with:"
echo ""
echo "  export PATH=\$PATH:\$HOME/.linkerd2/bin"
echo ""
echo "Now run:"
echo ""
echo "  linkerd check --pre                     # validate that Linkerd can be installed"
echo "  linkerd install | kubectl apply -f -    # install the control plane into the 'linkerd' namespace"
echo "  linkerd check                           # validate everything worked!"
echo "  linkerd dashboard                       # launch the dashboard"
echo ""
echo "Looking for more? Visit https://linkerd.io/2/next-steps"
echo ""
