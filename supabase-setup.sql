-- Nithin Portfolio CMS setup
-- 1) Replace YOUR_ADMIN_EMAIL with the email you will use to log in.
-- 2) Run the entire script in Supabase SQL Editor.

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null default '',
  company text default '',
  category text default '',
  problem text default '',
  solution text default '',
  results text default '',
  metrics text default '',
  start_date text default '',
  end_date text default '',
  skills jsonb not null default '[]'::jsonb,
  cover_url text default '',
  gallery jsonb not null default '[]'::jsonb,
  featured boolean not null default false,
  published boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.projects enable row level security;

drop policy if exists "Public can read published projects" on public.projects;
create policy "Public can read published projects"
  on public.projects for select
  using (published = true);

drop policy if exists "Admin can manage projects" on public.projects;
create policy "Admin can manage projects"
  on public.projects for all
  using ((auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL')
  with check ((auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL');

insert into storage.buckets (id, name, public)
values ('project-images', 'project-images', true)
on conflict (id) do update set public = true;

drop policy if exists "Public can view project images" on storage.objects;
create policy "Public can view project images"
  on storage.objects for select
  using (bucket_id = 'project-images');

drop policy if exists "Admin can upload project images" on storage.objects;
create policy "Admin can upload project images"
  on storage.objects for insert
  with check (bucket_id = 'project-images' and (auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL');

drop policy if exists "Admin can update project images" on storage.objects;
create policy "Admin can update project images"
  on storage.objects for update
  using (bucket_id = 'project-images' and (auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL')
  with check (bucket_id = 'project-images' and (auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL');

drop policy if exists "Admin can delete project images" on storage.objects;
create policy "Admin can delete project images"
  on storage.objects for delete
  using (bucket_id = 'project-images' and (auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL');

create or replace function public.set_project_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists projects_updated_at on public.projects;
create trigger projects_updated_at
before update on public.projects
for each row execute function public.set_project_updated_at();
