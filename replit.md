# Sufi Thread Inventory

A single-page inventory management app for Sufi Thread. Uses Supabase for authentication and data storage.

## Stack
- Pure HTML/CSS/JS (no build step)
- Supabase (auth + database, credentials hardcoded in `index.html`)

## How to run
The app is served via Python's built-in HTTP server on port 5000:
```
python3 -m http.server 5000
```

## Features
- Admin login via Supabase Auth
- Dashboard with KPIs (total products, units, low-stock count)
- Stock In/Out transactions
- Add products
- Inventory list view
- Export inventory to CSV
- PWA-ready (manifest + service worker references)

## User preferences
