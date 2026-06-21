-- Blog posts table for 001-site public blog + admin portal management.
-- Apply in Supabase SQL editor (or migration pipeline) before using the UI.

create extension if not exists pgcrypto;

create table if not exists public.blog_posts (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique,
  excerpt text not null,
  content text not null,
  category text not null,
  tags text[] not null default '{}',
  image_url text not null,
  author_name text not null,
  author_role text not null,
  author_bio text not null,
  author_image_url text not null,
  read_minutes integer not null default 1 check (read_minutes > 0),
  views_count integer not null default 0 check (views_count >= 0),
  comments_count integer not null default 0 check (comments_count >= 0),
  is_featured boolean not null default false,
  is_published boolean not null default false,
  published_at timestamptz,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint blog_posts_publish_consistency
    check ((is_published = false) or (published_at is not null))
);

create index if not exists idx_blog_posts_published_at
  on public.blog_posts (published_at desc);

create index if not exists idx_blog_posts_is_published
  on public.blog_posts (is_published);

create index if not exists idx_blog_posts_updated_at
  on public.blog_posts (updated_at desc);

create or replace function public.set_blog_posts_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_blog_posts_updated_at on public.blog_posts;
create trigger trg_blog_posts_updated_at
before update on public.blog_posts
for each row
execute procedure public.set_blog_posts_updated_at();

alter table public.blog_posts enable row level security;

drop policy if exists "blog_posts_public_read_published" on public.blog_posts;
create policy "blog_posts_public_read_published"
on public.blog_posts
for select
using (
  is_published = true
);

drop policy if exists "blog_posts_admin_read_all" on public.blog_posts;
create policy "blog_posts_admin_read_all"
on public.blog_posts
for select
to authenticated
using (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

drop policy if exists "blog_posts_admin_insert" on public.blog_posts;
create policy "blog_posts_admin_insert"
on public.blog_posts
for insert
to authenticated
with check (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
  and created_by = auth.uid()
);

drop policy if exists "blog_posts_admin_update" on public.blog_posts;
create policy "blog_posts_admin_update"
on public.blog_posts
for update
to authenticated
using (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
)
with check (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

drop policy if exists "blog_posts_admin_delete" on public.blog_posts;
create policy "blog_posts_admin_delete"
on public.blog_posts
for delete
to authenticated
using (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);
