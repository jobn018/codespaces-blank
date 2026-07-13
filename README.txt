INVENTORY APP SETUP

This repository contains a mobile-friendly inventory web app that uses Supabase for authentication, storage, and data.

FILES
index.html          Mobile inventory app
schema.sql          Supabase database and security setup
manifest.json       Installable web-app settings
service-worker.js   Basic app-shell caching
vercel.json         Static deployment settings

QUICK SETUP

1. Create a Supabase project.
2. Open the SQL Editor and run `schema.sql`.
3. Open Project Settings > API.
4. Copy the Project URL and anon/public key.
5. Open `index.html` in a text editor.
6. Replace:
   - `PASTE_YOUR_SUPABASE_URL`
   - `PASTE_YOUR_SUPABASE_ANON_KEY`
   - `admin@yourdomain.com` with your admin email.
7. Save `index.html`.
8. Upload this folder to GitHub.
9. Import the GitHub repository into Vercel and deploy.
10. Open the Vercel URL.
11. Create the admin account using your admin email.
12. Confirm the email if Supabase asks.
13. Add the website to your phone home screen.

IMPORTANT SECURITY
Use only the anon/public key in `index.html`.
Never use the service-role key in browser code.
Row Level Security allows only your admin email to manage inventory.

FEATURES
Mobile login
Add product
Phone camera/image upload
Stock In
Stock Out
Live inventory
Dashboard
Low-stock count
CSV export for Excel
