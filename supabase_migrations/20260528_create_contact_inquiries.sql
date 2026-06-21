-- Contact inquiries submitted from the public marketing site contact form.
-- Public (anon) visitors may INSERT; only admins may SELECT (mirrors the
-- blog_posts admin RLS convention: auth.jwt() user_metadata.role = 'admin').
--
-- Applied to live Supabase on 2026-05-28 as part of the contact-form slice.
-- Forward-only / additive; safe to re-run (guards with IF NOT EXISTS).

create extension if not exists pgcrypto;

create table if not exists public.contact_inquiries (
  id                uuid primary key default gen_random_uuid(),
  name              text        not null,
  email             text        not null,
  phone             text,
  company           text,
  consultation_type text,
  preferred_office  text,
  message           text        not null,
  is_urgent         boolean     not null default false,
  contact_method    text        not null default 'email',
  created_at        timestamptz not null default now()
);

create index if not exists contact_inquiries_created_at_idx
  on public.contact_inquiries (created_at desc);

alter table public.contact_inquiries enable row level security;

-- Public contact form: anyone (anon or signed-in) may submit.
drop policy if exists "public can submit contact inquiries" on public.contact_inquiries;
create policy "public can submit contact inquiries"
  on public.contact_inquiries
  for insert
  to anon, authenticated
  with check (true);

-- Only admins may read submissions.
drop policy if exists "admins read contact inquiries" on public.contact_inquiries;
create policy "admins read contact inquiries"
  on public.contact_inquiries
  for select
  to authenticated
  using ((auth.jwt() -> 'user_metadata' ->> 'role') = 'admin');

grant insert on public.contact_inquiries to anon, authenticated;
grant select on public.contact_inquiries to authenticated;
