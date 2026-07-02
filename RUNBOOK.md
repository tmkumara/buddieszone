# Deploying buddieszone.lk

Run these steps yourself over SSH on the VPS (no automated access from
the assistant session that built this).

1. SSH into the VPS.
2. Clone the repo (skip if already cloned):
   ```
   cd /opt
   git clone https://github.com/tmkumara/buddieszone.git buddieszone
   cd /opt/buddieszone
   git pull
   ```
3. Confirm SSL certs exist for buddieszone.lk. The old placeholder block
   already referenced `/etc/letsencrypt/live/buddieszone.lk/fullchain.pem`,
   so a cert was likely already issued via certbot. Check with:
   ```
   sudo certbot certificates
   ```
   If `buddieszone.lk` isn't listed (or is missing `www.buddieszone.lk` as
   a SAN), issue/expand it before continuing — DNS for both names already
   points at this server:
   ```
   sudo certbot --nginx -d buddieszone.lk -d www.buddieszone.lk
   ```
4. Replace the old config file with the new combined one, and rename it
   from `buddiescraft` to `buddieszone` so the filename matches what it
   actually configures (both buddieszone.lk and craft.buddieszone.lk):
   ```
   sudo cp /etc/nginx/sites-enabled/buddiescraft /etc/nginx/sites-enabled/buddiescraft.bak
   sudo cp /opt/buddieszone/deploy/nginx-buddieszone.conf /etc/nginx/sites-enabled/buddieszone
   sudo rm /etc/nginx/sites-enabled/buddiescraft
   ```
5. Test and reload nginx:
   ```
   sudo nginx -t
   sudo systemctl reload nginx
   ```
6. Verify both sites:
   - https://buddieszone.lk shows the new hub page (not the old "coming soon" placeholder)
   - https://craft.buddieszone.lk still shows the OMS dashboard exactly as before
7. If both check out, remove the backup:
   ```
   sudo rm /etc/nginx/sites-enabled/buddiescraft.bak
   ```
8. For future content updates, pull the latest and reload:
   ```
   cd /opt/buddieszone
   bash deploy.sh
   ```
