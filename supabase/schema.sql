-- Gastos Mensais: tabela de lançamentos com acesso restrito ao dono.
-- Rode este arquivo inteiro no Supabase: SQL Editor > New query > colar > Run.

create table if not exists public.lancamentos (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  type        text not null check (type in ('in', 'out')),
  amount      numeric(12, 2) not null check (amount > 0),
  date        date not null,
  description text not null check (char_length(description) between 1 and 160),
  category    text not null default 'Outros',
  method      text not null default 'Outro',
  status      text not null default 'ok' check (status in ('ok', 'pending')),
  notes       text check (notes is null or char_length(notes) <= 300),
  created_at  timestamptz not null default now()
);

create index if not exists lancamentos_user_date_idx on public.lancamentos (user_id, date);

-- Row Level Security: cada usuário só lê e altera os próprios lançamentos.
alter table public.lancamentos enable row level security;

drop policy if exists "ver os proprios" on public.lancamentos;
drop policy if exists "criar os proprios" on public.lancamentos;
drop policy if exists "editar os proprios" on public.lancamentos;
drop policy if exists "excluir os proprios" on public.lancamentos;

create policy "ver os proprios" on public.lancamentos
  for select to authenticated using ((select auth.uid()) = user_id);

create policy "criar os proprios" on public.lancamentos
  for insert to authenticated with check ((select auth.uid()) = user_id);

create policy "editar os proprios" on public.lancamentos
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

create policy "excluir os proprios" on public.lancamentos
  for delete to authenticated using ((select auth.uid()) = user_id);
