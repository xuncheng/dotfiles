# ssh-agent starts empty after a reboot, and `ssh-keygen -Y sign` consults
# neither ssh_config nor the keychain, so committing would prompt for the
# signing key's passphrase. `ssh-add -l` exits non-zero only while the agent
# holds nothing, so the reload runs once per boot.
ssh-add -l >/dev/null 2>&1 || ssh-add --apple-load-keychain >/dev/null 2>&1
