-- SmartSpend schema v1.1 patch
-- Run this AFTER SmartSpend_Supabase_Schema.sql.
-- It prevents duplicate system categories and ensures a user can contribute only to their own goal.

-- 1. Remove accidental duplicate system categories, keeping the earliest row.
delete from public.categories a
using public.categories b
where a.is_system = true
  and b.is_system = true
  and a.name = b.name
  and a.created_at > b.created_at;

-- 2. Enforce one system category with a given name.
create unique index if not exists unique_system_category_name
on public.categories (name)
where is_system = true;

-- 3. Replace the goal-contribution insert policy with ownership validation.
drop policy if exists "Users can insert own goal contributions" on public.goal_contributions;

create policy "Users can insert contributions only to own goals"
on public.goal_contributions for insert
to authenticated
with check (
  user_id = auth.uid()
  and exists (
    select 1
    from public.savings_goals g
    where g.id = goal_id
      and g.user_id = auth.uid()
  )
);

-- 4. A user must not be able to delete a contribution that belongs to a goal they do not own.
drop policy if exists "Users can delete own goal contributions" on public.goal_contributions;

create policy "Users can delete contributions only from own goals"
on public.goal_contributions for delete
to authenticated
using (
  user_id = auth.uid()
  and exists (
    select 1
    from public.savings_goals g
    where g.id = goal_id
      and g.user_id = auth.uid()
  )
);
