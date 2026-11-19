# Portfolio CMS setup

## 1. Supabase
Create a project. In Project Settings > API, copy Project URL and anon/public key into `supabase-config.js`.

## 2. Database and image storage
In Supabase SQL Editor, open `supabase-setup.sql`, replace every `YOUR_ADMIN_EMAIL` with the exact email used for admin login, and run the SQL.

## 3. Create admin login
Supabase > Authentication > Users > Add user. Use your email and a password. Confirm the user (or disable email confirmation for initial setup). This must match the email in the SQL policies.

## 4. Deploy
Files are designed for static hosting (GitHub Pages). Admin is at `/admin.html`. Configure the project URL and anon key. Never place the Supabase service-role key in browser code.

## Files
- `admin.html` / `admin.js` / `admin.css`: authenticated project manager
- `portfolio.js`: public projects renderer
- `supabase-config.js`: public project URL and anon key
- `supabase-setup.sql`: tables, RLS policies, and public image bucket
