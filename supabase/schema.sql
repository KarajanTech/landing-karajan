-- Karajan landing — briefing request capture
-- Run this once in the Supabase dashboard → SQL Editor → New query → Run.
-- It creates the table the contact form writes to, and locks it down with
-- row-level security: anonymous visitors can INSERT a request but can never
-- read, update, or delete. You read submissions in the dashboard (Table editor).

create table if not exists public.briefing_requests (
  id          uuid primary key default gen_random_uuid(),
  email       text not null,
  note        text,
  created_at  timestamptz not null default now()
);

-- Keep the table closed by default…
alter table public.briefing_requests enable row level security;

-- …then allow ONLY anonymous inserts (no select/update/delete for anon).
drop policy if exists "anon can submit briefing requests" on public.briefing_requests;
create policy "anon can submit briefing requests"
  on public.briefing_requests
  for insert
  to anon
  with check (
    char_length(email) between 3 and 320
    and (note is null or char_length(note) <= 4000)
  );
