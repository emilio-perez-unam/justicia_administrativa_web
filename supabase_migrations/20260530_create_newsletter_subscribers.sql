-- Public blog newsletter subscribers.
-- Backs the newsletter sign-up card in the public blog sidebar so the form
-- persists real intent instead of showing a fake success message.

create table if not exists public.newsletter_subscribers (
  id uuid primary key default gen_random_uuid(),
  email text not null unique,
  created_at timestamptz not null default now()
);

alter table public.newsletter_subscribers enable row level security;

-- Anyone (anon or authenticated visitor) may subscribe. No SELECT policy is
-- defined, so the list is not readable through the public API; admin/export
-- reads happen out-of-band via the service role.
drop policy if exists newsletter_subscribers_public_insert
  on public.newsletter_subscribers;
create policy newsletter_subscribers_public_insert
  on public.newsletter_subscribers
  for insert
  to anon, authenticated
  with check (true);
