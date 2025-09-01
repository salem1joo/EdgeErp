-- إنشاء جدول بروفايل المستخدم وربطه بمستخدم Supabase Auth
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text check (role in ('tenant','owner','tech','collector','admin')) default 'tenant',
  avatar_url text,
  created_at timestamp with time zone default now()
);

-- تفعيل سياسات الصفوف (RLS)
alter table public.profiles enable row level security;

-- سياسة: كل مستخدم يقرأ سجله فقط
create policy if not exists profiles_select_own
on public.profiles for select
using ( auth.uid() = id );

-- سياسة: كل مستخدم يحدّث سجله فقط
create policy if not exists profiles_update_own
on public.profiles for update
using ( auth.uid() = id );

-- تريغر: عند إنشاء مستخدم جديد في auth.users أضف له سجل بروفايل
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>'name', new.raw_user_meta_data->>'avatar_url')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
