#!/bin/bash

set -euo pipefail

source "../../../bin/util/confirm.sh"

cd exported

for domain in *.plist; do
    # Remove the .plist extension
    domain="${domain%.plist}"
    confirm "About to import settings for $domain. It will overwrite existing settings. Are you sure" || continue
    defaults import $domain "$domain.plist"
done
