#!/usr/bin/env bash
set -euo pipefail
cd /opt/buddieszone
git pull origin main
sudo nginx -t
sudo systemctl reload nginx
echo "buddieszone.lk deployed."
