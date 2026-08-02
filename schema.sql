-- ============================================================
-- School Website — Supabase schema
-- Run this once in your Supabase project's SQL Editor
-- (Project → SQL Editor → New query → paste all of this → Run)
-- ============================================================

-- Needed for gen_random_uuid()
create extension if not exists pgcrypto;

-- ------------------------------------------------------------
-- 1. NOTICES  (shown on the homepage, managed from the admin panel)
-- ------------------------------------------------------------
create table if not exists notices (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  published boolean not null default true,
  created_at timestamptz not null default now()
);

alter table notices enable row level security;

-- Anyone visiting the site can read published notices
create policy "public can read published notices"
  on notices for select
  using (published = true);

-- Only a logged-in admin can create/edit/delete
create policy "admin can manage notices"
  on notices for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');


-- ------------------------------------------------------------
-- 2. GALLERY PHOTOS  (uploaded from the admin panel)
-- ------------------------------------------------------------
create table if not exists gallery_photos (
  id uuid primary key default gen_random_uuid(),
  title text,
  image_url text not null,
  created_at timestamptz not null default now()
);

alter table gallery_photos enable row level security;

create policy "public can read gallery photos"
  on gallery_photos for select
  using (true);

create policy "admin can manage gallery photos"
  on gallery_photos for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');


-- ------------------------------------------------------------
-- 3. ADMISSION INQUIRIES  (from the admissions.html form)
-- ------------------------------------------------------------
create table if not exists admission_inquiries (
  id uuid primary key default gen_random_uuid(),
  parent_name text not null,
  phone text not null,
  email text not null,
  child_class text,
  academic_year text,
  source text,
  message text,
  status text not null default 'new',   -- new / contacted / enrolled / closed
  created_at timestamptz not null default now()
);

alter table admission_inquiries enable row level security;

-- Any website visitor can submit the form (insert only — cannot read others' data)
create policy "public can submit admission inquiry"
  on admission_inquiries for insert
  with check (true);

-- Only the logged-in admin can view / update / delete
create policy "admin can manage admission inquiries"
  on admission_inquiries for select
  using (auth.role() = 'authenticated');

create policy "admin can update admission inquiries"
  on admission_inquiries for update
  using (auth.role() = 'authenticated');

create policy "admin can delete admission inquiries"
  on admission_inquiries for delete
  using (auth.role() = 'authenticated');


-- ------------------------------------------------------------
-- 4. VISIT REQUESTS  (from the visit.html form)
-- ------------------------------------------------------------
create table if not exists visit_requests (
  id uuid primary key default gen_random_uuid(),
  parent_name text not null,
  phone text not null,
  email text not null,
  child_class text,
  num_visitors text,
  preferred_date date,
  preferred_time text,
  notes text,
  status text not null default 'new',   -- new / confirmed / completed / cancelled
  created_at timestamptz not null default now()
);

alter table visit_requests enable row level security;

create policy "public can submit visit request"
  on visit_requests for insert
  with check (true);

create policy "admin can manage visit requests"
  on visit_requests for select
  using (auth.role() = 'authenticated');

create policy "admin can update visit requests"
  on visit_requests for update
  using (auth.role() = 'authenticated');

create policy "admin can delete visit requests"
  on visit_requests for delete
  using (auth.role() = 'authenticated');


-- ============================================================
-- 5. STORAGE — bucket for gallery photo uploads
-- ============================================================
-- Run this part too. It creates a public bucket called "gallery".
insert into storage.buckets (id, name, public)
values ('gallery', 'gallery', true)
on conflict (id) do nothing;

create policy "public can view gallery bucket"
  on storage.objects for select
  using (bucket_id = 'gallery');

create policy "admin can upload to gallery bucket"
  on storage.objects for insert
  with check (bucket_id = 'gallery' and auth.role() = 'authenticated');

create policy "admin can delete from gallery bucket"
  on storage.objects for delete
  using (bucket_id = 'gallery' and auth.role() = 'authenticated');

-- ============================================================
-- Done. Next steps (see SETUP.md):
--   1. Authentication → Users → Add user (this becomes your admin login)
--   2. Project Settings → API → copy the Project URL and anon public key
--      into config.js
-- ============================================================
