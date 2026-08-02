# Setting up the backend (Supabase) — one-time setup

This connects your website to a real database so the admin panel, admission
form, and visit form actually save data.

## 1. Create a free Supabase account
Go to https://supabase.com → Sign up → **New project**.
- Give it a name (e.g. "school-website")
- Set a database password (save it somewhere safe)
- Choose the region closest to you (e.g. Mumbai / Singapore)
- Wait ~1 minute for the project to finish setting up

## 2. Run the database schema
1. In your Supabase project, open **SQL Editor** (left sidebar)
2. Click **New query**
3. Open `db/schema.sql` from this folder, copy all of it, paste it into the editor
4. Click **Run**

This creates all the tables (notices, gallery photos, admission inquiries,
visit requests), the security rules, and a storage bucket for photos.

## 3. Create your admin login
1. Go to **Authentication → Users** (left sidebar)
2. Click **Add user → Create new user**
3. Enter the email and password you want to log into `/admin.html` with
4. Leave "Auto Confirm User" checked, then click **Create user**

This is the only login the admin panel accepts — there's no public sign-up.

## 4. Connect the website to your project
1. Go to **Project Settings → API**
2. Copy the **Project URL**
3. Copy the **anon public** key (NOT the `service_role` key — never use that one here)
4. Open `config.js` in this folder and paste them in:

```js
const SUPABASE_URL = "https://xxxxxxxxxxxx.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOi...";
```

## 5. Deploy the site
Upload this whole folder to your host (Vercel, Netlify, or your web hosting
provider). No extra build step is needed — it's all plain HTML/CSS/JS.

## 6. Try it out
- Visit `admin.html` on your live site and log in with the account from step 3
- Add a notice → check it shows up on the homepage
- Upload a gallery photo → check it shows up on the gallery page
- Submit the admissions form and the visit form on the live site → check both
  show up under **Admissions** and **Visit requests** in the admin panel

## Notes
- `admin.html` is not linked from anywhere on the public site — bookmark the
  URL yourself. Anyone who guesses the URL still can't get in without your
  login (and can't see any data — that's enforced by the database, not just
  by hiding the page).
- If you ever need a second admin login, repeat step 3 for a new user.
