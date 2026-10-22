-- À coller dans Supabase : SQL Editor > New query > Run.
-- Table des profils publics (amis, échanges, statut en ligne).
create table if not exists public.players (
  user_id uuid primary key references auth.users(id) on delete cascade,
  cd text,
  fr text[] not null default '{}',
  data jsonb not null,
  seen timestamptz not null default now()
);
create index if not exists players_cd_idx on public.players (cd);
create index if not exists players_fr_idx on public.players using gin (fr);
alter table public.players enable row level security;
create policy "voir les joueurs"     on public.players for select to authenticated using (true);
create policy "creer son profil"     on public.players for insert to authenticated with check (auth.uid() = user_id);
create policy "changer son profil"   on public.players for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "supprimer son profil" on public.players for delete to authenticated using (auth.uid() = user_id);
