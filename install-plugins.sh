#!/bin/bash

SHELL_PROFILE=$(. ./which-shell.sh)

echo "Detected shell: $SHELL"
echo "Installing kubectl-plugins to ~/${SHELL_PROFILE}"

# Move plugins and add location to path (required for kubectl 1.12+)
chmod +x ./kubectl-*
rm -rf ~/.kube/plugins/jordanwilson230/kubectl-*
mkdir -p ~/.kube/plugins/jordanwilson230/config
touch ~/.kube/plugins/jordanwilson230/config/namespaces
touch ~/.kube/plugins/jordanwilson230/config/clusters
cp -r ./kubectl-* ~/.kube/plugins/jordanwilson230/
grep 'PATH=$PATH:~/.kube/plugins/jordanwilson230' ~/${SHELL_PROFILE} 1>/dev/null
[ $? -ne 0 ] && echo 'export PATH=$PATH:~/.kube/plugins/jordanwilson230' >> ~/${SHELL_PROFILE}


# Removes old installer function if exists
ex '+g/function kubectl()/d' -cwq ~/${SHELL_PROFILE} >/dev/null 2>&1

# Add function to check user context when kubectl is invoked.
ex '+g/function kubectl/d' -cwq ~/${SHELL_PROFILE}
echo 'function kubectl() { command kubectl prompt "$@" && command kubectl "$@" }' >> ~/${SHELL_PROFILE}

# Finished
echo -e "\nDone.\nPlease open a new terminal or run: source ~/${SHELL_PROFILE}\n"
kubectl plugin list --name-only | sed 's|-| |g'
