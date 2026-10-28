# Anywhere Vault

A responsive, single-page personal cloud notebook for saving notes, text, URLs, tasks, and code snippets from any device.

## Architecture

- **Frontend:** static HTML, CSS, JavaScript
- **Hosting:** GitHub Pages (free for public repositories)
- **Database + authentication:** Supabase
- **Security:** Supabase Auth + Row Level Security (each signed-in user can access only their own rows)

This is a ready-to-configure deployable starter, not a live hosted site yet. You must connect your own Supabase project and publish it to get a live URL.

## Setup (one-time)

### 1. Create your database

1. Open https://supabase.com and create a project.
2. Open **SQL Editor** in the Supabase dashboard.
3. Paste the full contents of `schema.sql` and run it.
4. Open **Project Settings → API** (or API Keys).
5. Copy the **Project URL** and the **publishable/anon public key**.

Never use the `service_role` or secret key in the browser.

### 2. Configure the website

1. Open `index.html` in a code editor.
2. Near the bottom, find:
   ```js
   const SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL";
   const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
   ```
3. Replace the placeholders with your Supabase Project URL and public anon/publishable key.
4. Save the file.

The public key is designed to be used by the browser. Data protection depends on the SQL policies; do not remove Row Level Security.

### 3. Publish with GitHub Pages

1. Create a GitHub repository, e.g. `anywhere-vault`.
2. Upload `index.html`, `schema.sql`, and `README.md` to the repository root.
3. Open **Settings → Pages**.
4. Under build/deployment, choose **Deploy from a branch**, select `main` and `/ (root)`, then save.
5. Wait for GitHub Pages to publish. Your site URL will appear in the Pages settings.
6. Open that URL on phone/laptop and sign in with the same email/password.

### 4. Authentication notes

- Create an account in the app. Depending on your Supabase Auth settings, you may need to confirm your email before signing in.
- In Supabase **Authentication → URL Configuration**, add your GitHub Pages URL to the allowed redirect URLs if using email magic links.
- For a personal-only vault, disable public sign-ups after creating your account if you do not want others to register. Existing users can still sign in. Check the current Supabase Auth dashboard labels because they may change.

## What it does

- Save and edit notes, links, tasks, text, and code snippets
- Search saved items
- Delete items
- Access the same cloud data across devices after signing in
- Enforce per-user data isolation with database RLS

## Important limitations

- This stores text and URLs, not arbitrary file uploads. File uploads need a storage bucket and additional UI.
- It is not an encrypted password manager. Do not store passwords, API keys, recovery codes, financial secrets, or highly sensitive personal information.
- Free-tier services have limits and may change; this setup is suitable for personal use and prototypes, not a guaranteed zero-downtime production service.
- Keep an independent export/backup of anything important.
