# One ERP (Supabase + GitHub)

هذا المستودع هو الجذر المرجعي لمشروعي على Supabase (أونلاين).
- `web/index.html`: واجهة دخول تعمل بـ Supabase Auth (GitHub OAuth).
- `supabase/migrations/000-init.sql`: إنشاء جدول `profiles` وسياسات RLS + التريغر.
- `docs/auth-github.md`: توثيق إعداد OAuth.

## مفاتيح Supabase للواجهة
Supabase Studio → Settings → API
- Project URL
- anon public key

توضع داخل `web/index.html` في:
`SUPABASE_URL`, `SUPABASE_ANON`.
