Sufi Thread Inventory

Run locally with:
python3 -m http.server 5000

Open http://localhost:5000/

This app expects:
- Supabase project with the SQL from schema.sql applied
- A public storage bucket named product-images
- The Supabase URL and anon key configured in index.html

Netlify deployment:
- Publish the repository root `.`
- No build command is needed
- After deploy, open the Netlify URL over HTTPS so the service worker can register
