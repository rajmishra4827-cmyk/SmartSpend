-- SmartSpend MVP — Supabase PostgreSQL schema, indexes, triggers, and RLS policies
-- Run in Supabase Dashboard -> SQL Editor.
-- This script uses Supabase auth.users for authentication.

create extension if not exists "uuid-ossp";

-- 1. User profile created automatically after Supabase Auth signup
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'SmartSpend User' check (char_length(display_name) between 2 and 60),
  monthly_income numeric(12,2) check (monthly_income is null or monthly_income >= 0),
  month_start_day smallint not null default 1 check (month_start_day between 1 and 28),
  currency_code text not null default 'INR' check (currency_code = 'INR'),
  onboarding_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 2. Expense categories: system categories are visible to everyone; custom categories belong to one user
create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  name text not null check (char_length(name) between 2 and 50),
  icon text not null default 'Circle',
  color text not null default '#64748B',
  is_system boolean not null default false,
  created_at timestamptz not null default now(),
  unique (user_id, name)
);

-- 3. Expenses
create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  category_id uuid not null references public.categories(id) on delete restrict,
  amount numeric(12,2) not null check (amount > 0 and amount <= 1000000),
  expense_date date not null default current_date check (expense_date <= current_date + 1),
  note text check (note is null or char_length(note) <= 280),
  payment_method text not null default 'UPI' check (payment_method in ('UPI', 'Cash', 'Card', 'Bank Transfer', 'Other')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 4. One total budget per user/month
create table if not exists public.monthly_budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  budget_month date not null check (budget_month = date_trunc('month', budget_month)::date),
  amount numeric(12,2) not null check (amount > 0 and amount <= 10000000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, budget_month)
);

-- 5. One category budget per user/category/month
create table if not exists public.category_budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  category_id uuid not null references public.categories(id) on delete cascade,
  budget_month date not null check (budget_month = date_trunc('month', budget_month)::date),
  amount numeric(12,2) not null check (amount > 0 and amount <= 10000000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, category_id, budget_month)
);

-- 6. Savings goals
create table if not exists public.savings_goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 2 and 80),
  target_amount numeric(12,2) not null check (target_amount > 0 and target_amount <= 100000000),
  saved_amount numeric(12,2) not null default 0 check (saved_amount >= 0),
  target_date date,
  color text not null default '#16A34A',
  icon text not null default 'Target',
  status text not null default 'active' check (status in ('active', 'completed', 'archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (target_date is null or target_date >= created_at::date)
);

-- 7. Auditable goal contributions
create table if not exists public.goal_contributions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  goal_id uuid not null references public.savings_goals(id) on delete cascade,
  amount numeric(12,2) not null check (amount > 0 and amount <= 10000000),
  contribution_date date not null default current_date,
  note text check (note is null or char_length(note) <= 280),
  created_at timestamptz not null default now()
);

-- 8. Indexes for common user/month queries
create index if not exists idx_expenses_user_date on public.expenses (user_id, expense_date desc);
create index if not exists idx_expenses_user_category_date on public.expenses (user_id, category_id, expense_date desc);
create index if not exists idx_monthly_budgets_user_month on public.monthly_budgets (user_id, budget_month desc);
create index if not exists idx_category_budgets_user_month on public.category_budgets (user_id, budget_month desc);
create index if not exists idx_goals_user_status on public.savings_goals (user_id, status);
create index if not exists idx_goal_contributions_goal_date on public.goal_contributions (goal_id, contribution_date desc);

-- 9. Shared updated_at function and triggers
create or replace function public.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_profiles_updated_at on public.profiles;
create trigger set_profiles_updated_at before update on public.profiles
for each row execute function public.set_updated_at();

drop trigger if exists set_expenses_updated_at on public.expenses;
create trigger set_expenses_updated_at before update on public.expenses
for each row execute function public.set_updated_at();

drop trigger if exists set_monthly_budgets_updated_at on public.monthly_budgets;
create trigger set_monthly_budgets_updated_at before update on public.monthly_budgets
for each row execute function public.set_updated_at();

drop trigger if exists set_category_budgets_updated_at on public.category_budgets;
create trigger set_category_budgets_updated_at before update on public.category_budgets
for each row execute function public.set_updated_at();

drop trigger if exists set_savings_goals_updated_at on public.savings_goals;
create trigger set_savings_goals_updated_at before update on public.savings_goals
for each row execute function public.set_updated_at();

-- 10. Create profile automatically after Auth user is created
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'display_name', split_part(new.email, '@', 1), 'SmartSpend User')
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- 11. Keep goal total and status correct after a contribution
create or replace function public.apply_goal_contribution()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  current_target numeric(12,2);
begin
  update public.savings_goals
  set saved_amount = saved_amount + new.amount,
      updated_at = now()
  where id = new.goal_id and user_id = new.user_id
  returning target_amount into current_target;

  update public.savings_goals
  set status = 'completed', updated_at = now()
  where id = new.goal_id and user_id = new.user_id and saved_amount >= target_amount;

  return new;
end;
$$;

drop trigger if exists on_goal_contribution_created on public.goal_contributions;
create trigger on_goal_contribution_created
after insert on public.goal_contributions
for each row execute function public.apply_goal_contribution();

-- 12. Row Level Security
alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.expenses enable row level security;
alter table public.monthly_budgets enable row level security;
alter table public.category_budgets enable row level security;
alter table public.savings_goals enable row level security;
alter table public.goal_contributions enable row level security;

-- Profiles
create policy "Users can view their own profile"
on public.profiles for select
to authenticated
using (auth.uid() = id);

create policy "Users can update their own profile"
on public.profiles for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

-- Categories: all authenticated users can read system categories; users can manage their own custom categories
create policy "Authenticated users can view system and own categories"
on public.categories for select
to authenticated
using (is_system = true or user_id = auth.uid());

create policy "Users can create own custom categories"
on public.categories for insert
to authenticated
with check (user_id = auth.uid() and is_system = false);

create policy "Users can update own custom categories"
on public.categories for update
to authenticated
using (user_id = auth.uid() and is_system = false)
with check (user_id = auth.uid() and is_system = false);

create policy "Users can delete own custom categories"
on public.categories for delete
to authenticated
using (user_id = auth.uid() and is_system = false);

-- Generic own-row policies
create policy "Users can view own expenses"
on public.expenses for select to authenticated
using (user_id = auth.uid());
create policy "Users can insert own expenses"
on public.expenses for insert to authenticated
with check (user_id = auth.uid());
create policy "Users can update own expenses"
on public.expenses for update to authenticated
using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "Users can delete own expenses"
on public.expenses for delete to authenticated
using (user_id = auth.uid());

create policy "Users can view own monthly budgets"
on public.monthly_budgets for select to authenticated
using (user_id = auth.uid());
create policy "Users can insert own monthly budgets"
on public.monthly_budgets for insert to authenticated
with check (user_id = auth.uid());
create policy "Users can update own monthly budgets"
on public.monthly_budgets for update to authenticated
using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "Users can delete own monthly budgets"
on public.monthly_budgets for delete to authenticated
using (user_id = auth.uid());

create policy "Users can view own category budgets"
on public.category_budgets for select to authenticated
using (user_id = auth.uid());
create policy "Users can insert own category budgets"
on public.category_budgets for insert to authenticated
with check (user_id = auth.uid());
create policy "Users can update own category budgets"
on public.category_budgets for update to authenticated
using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "Users can delete own category budgets"
on public.category_budgets for delete to authenticated
using (user_id = auth.uid());

create policy "Users can view own goals"
on public.savings_goals for select to authenticated
using (user_id = auth.uid());
create policy "Users can insert own goals"
on public.savings_goals for insert to authenticated
with check (user_id = auth.uid());
create policy "Users can update own goals"
on public.savings_goals for update to authenticated
using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "Users can delete own goals"
on public.savings_goals for delete to authenticated
using (user_id = auth.uid());

create policy "Users can view own goal contributions"
on public.goal_contributions for select to authenticated
using (user_id = auth.uid());
create policy "Users can insert own goal contributions"
on public.goal_contributions for insert to authenticated
with check (user_id = auth.uid());
create policy "Users can delete own goal contributions"
on public.goal_contributions for delete to authenticated
using (user_id = auth.uid());

-- 13. System categories. System category user_id is NULL and cannot be modified by normal users.
insert into public.categories (user_id, name, icon, color, is_system) values
  (null, 'Food', 'Utensils', '#F97316', true),
  (null, 'Canteen / Mess', 'Soup', '#EA580C', true),
  (null, 'Food Delivery', 'Bike', '#EF4444', true),
  (null, 'Transport', 'Bus', '#3B82F6', true),
  (null, 'Recharge', 'Smartphone', '#8B5CF6', true),
  (null, 'Education', 'GraduationCap', '#0EA5E9', true),
  (null, 'Shopping', 'ShoppingBag', '#EC4899', true),
  (null, 'Entertainment', 'Popcorn', '#A855F7', true),
  (null, 'Health', 'HeartPulse', '#10B981', true),
  (null, 'Rent / Hostel', 'House', '#64748B', true),
  (null, 'Bills', 'ReceiptIndianRupee', '#D97706', true),
  (null, 'Subscription', 'Repeat2', '#6366F1', true),
  (null, 'Other', 'CircleEllipsis', '#94A3B8', true)
on conflict (user_id, name) do nothing;

-- Important implementation note:
-- When inserting expense/budget/goal data from Next.js, set user_id from the authenticated
-- Supabase session. Never accept another user's ID from URL/form data.
