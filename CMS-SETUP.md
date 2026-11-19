# Portfolio CMS — connected to Supabase

**Supabase project:** `nithin-portfolio` (`yusnszhzcshfdzkawyal`)

The following have already been deployed to Supabase:
- `public.projects` with published/draft project data
- `public.portfolio_admins` for explicit user-UUID admin access
- Row-level security for published project reads and admin-only changes
- Public `project-images` storage bucket with authenticated admin-only upload permissions
- Original eight portfolio projects seeded and published

The public Supabase URL and publishable key are already in `supabase-config.js`.

## Finish admin authentication
1. Open Supabase Dashboard > Authentication > Users > Add user.
2. Create the admin account with your own email and strong password. Confirm the email.
3. Use the created user's UUID to grant admin access with this one-time statement in the SQL Editor:

```sql
insert into public.portfolio_admins (user_id)
values ('YOUR_AUTH_USER_UUID')
on conflict (user_id) do nothing;
```

You can also ask ChatGPT to grant admin access after creating the user, if the Supabase connection is enabled.

## Deploy
This code is on the `cms-admin` development branch. Merge its pull request into `main` **after** admin access is configured and tested. Once deployed, log in at `/admin.html`.

Important: only use the publishable key in browser code. Never commit a secret/service-role key to the repository.
