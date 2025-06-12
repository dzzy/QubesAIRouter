#!/bin/bash
# teardown.sh — Remove assets created by bootstrap script

set -e
source ./config.sh

if [[ ! -f "$ASSET_FILE" ]]; then
    echo "Asset file ($ASSET_FILE) not found!"
    exit 1
fi

echo "WARNING: This will permanently delete VMs/templates from assets.lst"
echo "Proceed? (y/N)"
read choice
[ "$choice" != "y" ] && echo "Aborted teardown." && exit 1

# Remove VMs and templates listed in assets.lst
while read -r asset; do
  [[ -z "$asset" || "$asset" == \#* ]] && continue
  if qvm-check "$asset" &>/dev/null; then
      echo "Removing: $asset"
      qvm-remove -f "$asset"
  else
      echo "Asset $asset does not exist, skipping."
  fi
done < "$ASSET_FILE"

rm -f "$ASSET_FILE"
echo "Teardown completed successfully."