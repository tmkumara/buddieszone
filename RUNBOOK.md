# Deploying buddieszone.lk

Run these steps yourself over SSH on the VPS (no automated access from
the assistant session that built this).

1. SSH into the VPS.
2. Clone the repo:
   ```
   cd /opt
   git clone https://github.com/tmkumara/buddieszone.git buddieszone
   ```
3. Open `/etc/nginx/sites-enabled/buddiescraft` and replace the two
   `buddieszone.lk` / `www.buddieszone.lk` server blocks (the ones with
   the inline `return 200 '<html>...'` placeholder) with the contents
   of `deploy/nginx-buddieszone.conf` from this repo. Leave the
   `craft.buddieszone.lk` server block untouched.
4. Test and reload nginx:
   ```
   sudo nginx -t
   sudo systemctl reload nginx
   ```
5. Visit https://buddieszone.lk and confirm the new hub page is live.
6. For future updates, pull the latest content and reload:
   ```
   cd /opt/buddieszone
   bash deploy.sh
   ```
