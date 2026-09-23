# SmartSpend — Technical Requirements Document (TRD)

**Version:** 1.0  
**Status:** MVP build specification  
**Architecture:** Full-stack Next.js web application with Supabase backend

## 1. Technical objective

Build a secure, responsive, deployable personal-finance web application for individual users. The application must provide authentication, private per-user financial records, expense CRUD, budgets, savings goals, dashboard calculations, and rule-based insights.

## 2. Approved technology stack

| Layer | Technology | Purpose |
|---|---|---|
| Frontend and server | Next.js with App Router | Pages, server logic, routing, deployment-ready application |
| Language | TypeScript | Type safety and clearer code |
| Styling | Tailwind CSS | Responsive UI and reusable visual styles |
| UI components | shadcn/ui or small reusable local components | Accessible, consistent controls; use only if it reduces work |
| Forms | React Hook Form + Zod | Input handling and shared validation |
| Database | Supabase PostgreSQL | Hosted relational database |
| Authentication | Supabase Auth | Email/password signup, login, session management |
| Authorization | Supabase Row Level Security (RLS) | Enforces per-user data isolation at database level |
| Charts | Recharts | Category-spending and trend chart |
| Date utilities | date-fns | Date/month calculations |
| Hosting | Vercel | Deploy Next.js application |
| Source control | Git and GitHub | Version history, collaboration, portfolio evidence |
| Future AI | Gemini API via server-side route only | Optional insights after MVP |

## 3. Architecture overview

```text
Browser
  ↓ HTTPS
Next.js application on Vercel
  ├── React UI / App Router pages
  ├── Server Actions or Route Handlers for protected mutations
  ├── Shared validation and calculation utilities
  └── Optional future Gemini server route
        ↓
Supabase
  ├── Auth: user accounts and sessions
  ├── PostgreSQL: financial data
  └── RLS: every query restricted to authenticated owner
```

## 4. Major technical rules

1. TypeScript strict mode must remain enabled.
2. Use Next.js App Router; do not mix with legacy Pages Router.
3. Use Supabase Auth rather than custom password storage.
4. Every user-owned table has a `user_id` that references `auth.users(id)`.
5. Enable RLS for every user-owned table.
6. Client requests may use the Supabase anonymous key only; it is safe only when RLS is correct.
7. The Supabase service-role key must never be included in browser code, committed to GitHub, or placed in `NEXT_PUBLIC_*` variables.
8. Validate input in the browser for user experience and on the server/database boundary for correctness.
9. Store money as `numeric(12,2)` in PostgreSQL and use integer/decimal-safe handling in TypeScript; never depend on uncontrolled floating-point arithmetic for financial totals.
10. All financial information is private; no public tables or unrestricted select policies.
11. Use environment variables; commit only `.env.example`, never `.env.local`.
12. Use mock/demo data only for development seed data, never as a replacement for real queries after database integration.

## 5. Application routes

| Route | Access | Purpose |
|---|---|---|
| `/` | Public | Landing page |
| `/login` | Public | Login form |
| `/signup` | Public | Registration form |
| `/auth/callback` | Public/Auth callback | Session exchange/callback if needed |
| `/onboarding` | Authenticated | Initial allowance/budget setup |
| `/dashboard` | Authenticated | Summary, safe-to-spend, insights, recent expenses |
| `/expenses` | Authenticated | Expense list, filters, create/edit/delete |
| `/budgets` | Authenticated | Monthly/category budget management |
| `/goals` | Authenticated | Savings goal management and contributions |
| `/settings` | Authenticated | Profile and preferences |
| `/api/insights` | Authenticated, future | Protected optional AI insight endpoint |

Unauthenticated users attempting a protected route must be redirected to `/login`.

## 6. Proposed folder structure

```text
smartspend/
├── app/
│   ├── (auth)/
│   │   ├── login/page.tsx
│   │   └── signup/page.tsx
│   ├── (protected)/
│   │   ├── dashboard/page.tsx
│   │   ├── expenses/page.tsx
│   │   ├── budgets/page.tsx
│   │   ├── goals/page.tsx
│   │   ├── onboarding/page.tsx
│   │   └── settings/page.tsx
│   ├── api/insights/route.ts
│   ├── auth/callback/route.ts
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/
│   ├── auth/
│   ├── dashboard/
│   ├── expenses/
│   ├── budgets/
│   ├── goals/
│   ├── layout/
│   └── ui/
├── lib/
│   ├── supabase/
│   │   ├── client.ts
│   │   ├── server.ts
│   │   └── middleware.ts
│   ├── calculations.ts
│   ├── constants.ts
│   ├── validations.ts
│   └── utils.ts
├── types/
│   ├── database.ts
│   ├── expense.ts
│   ├── budget.ts
│   └── goal.ts
├── supabase/
│   ├── schema.sql
│   ├── policies.sql
│   └── seed.sql
├── docs/
│   ├── PRD.md
│   ├── TRD.md
│   ├── DATABASE_SCHEMA.md
│   └── UI_UX_SPEC.md
├── public/
├── .env.example
├── README.md
├── middleware.ts
├── next.config.ts
├── package.json
└── tsconfig.json
```

## 7. Authentication design

- Use Supabase email/password authentication.
- On successful signup, create a row in `profiles` via database trigger.
- Require an authenticated user ID for every data query/mutation.
- Use Next.js middleware or server checks to protect application routes.
- Log out must end the Supabase session and return user to public landing/login route.
- Email confirmation may be enabled for production, but for development it can be configured according to Supabase project settings.

## 8. Data access design

### Browser/client

- Reads user-safe data through Supabase client or server-rendered queries.
- May use only `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`.
- RLS is the security boundary, not hidden UI buttons.

### Server

- Performs complex aggregates, protected mutation workflows, and future AI calls.
- Validates input using Zod.
- Never returns another user’s data.
- Future AI endpoint receives only an aggregated, minimized summary.

## 9. Validation requirements

| Input | Validation |
|---|---|
| Expense amount | Required; numeric; greater than 0; maximum 1,000,000 for MVP guardrail |
| Expense category | Required; must be valid category ID owned/available to user |
| Expense date | Required; valid ISO date; should not be implausibly far in future |
| Expense note | Optional; maximum 280 characters |
| Monthly budget | Greater than 0; valid selected month |
| Category budget | Greater than 0; one budget per category/month/user |
| Goal title | Required; 2–80 characters |
| Goal target amount | Required; greater than 0 |
| Goal contribution | Required; greater than 0; cannot exceed target without confirmation/normalization |
| Profile display name | Required; 2–60 characters |

## 10. Calculation module

Implement pure reusable functions inside `lib/calculations.ts`:

- `calculateMonthlySpent(expenses)`
- `calculateRemainingBudget(monthlyBudget, monthlySpent)`
- `calculateDaysRemaining(date)`
- `calculateDailySafeToSpend(remainingBudget, daysRemaining)`
- `calculateBudgetUsage(spent, budget)`
- `calculateGoalProgress(saved, target)`
- `calculateRequiredWeeklySaving(target, saved, targetDate, currentDate)`

Each function needs unit tests using predictable input/output examples.

## 11. Dashboard query/data requirements

The dashboard must request only the current user’s selected-month data:

- Profile allowance/income
- Monthly budget
- Current-month expenses
- Category aggregates
- Recent five expenses
- Active goals
- Category budgets

Avoid downloading unnecessary all-time records for a simple dashboard.

## 12. Error, loading, and empty states

Required UX states:

- Loading skeleton while dashboard data loads
- Friendly error when a save action fails
- Retry action when possible
- Empty expense state with “Add your first expense” call-to-action
- Empty budget state with “Set a monthly budget” call-to-action
- Empty goals state with “Create your first saving goal” call-to-action
- Unauthorized route redirect
- Form-specific validation message beside the field

## 13. Security requirements

- Supabase RLS enabled on `profiles`, `expenses`, `monthly_budgets`, `category_budgets`, `savings_goals`, and `goal_contributions`.
- SQL policies must compare `auth.uid()` to row `user_id`.
- Never trust a client-provided user ID; use authenticated identity.
- Do not expose database/service keys.
- Add Content Security Policy later if project scope allows.
- Do not store bank credentials, card data, UPI PINs, or payment secrets.
- Never describe SmartSpend as providing professional financial advice.

## 14. Performance and scalability baseline

MVP expectations:

- Mobile-first responsive UI
- Pagination or date-limited query for large expense histories after MVP
- Index `user_id` and common month/date query fields
- Use SQL aggregates or controlled client calculations rather than repeated redundant queries
- Keep components small and reusable
- Separate UI, data-access, validation, and calculations so future migration or growth is manageable

## 15. Deployment requirements

### Local development

- Node.js LTS installed
- `npm install`
- Create `.env.local` from `.env.example`
- `npm run dev`
- Run SQL schema and policies inside Supabase SQL Editor

### Vercel production

- GitHub repository connected to Vercel
- Add production environment variables in Vercel dashboard
- Deploy from main branch
- Confirm production Supabase URL/key values are correct
- Test signup/login and all protected routes on deployed URL

## 16. Test plan

### Functional tests

- Signup, login, logout
- Protected route redirect
- Add/edit/delete expense
- Filter expenses
- Create/edit budgets
- Budget threshold states at 80%, 100%, and above 100%
- Create goal and add contribution
- Dashboard totals and charts
- Mobile-width layout

### Security tests

- User A cannot select/update/delete User B data through UI or direct query attempt
- Anonymous user cannot access protected data
- No service-role key in repo or client bundle

### Calculation tests

- Zero expenses
- Budget missing
- Budget equal to spending
- Budget exceeded
- Month-end day calculation
- Goal at zero, partial, and 100% completion

## 17. Future Gemini integration

Add only after MVP passes all core tests.

- Endpoint: `/api/insights`
- Authenticate user before generating insight
- Aggregate current user’s selected-month data server-side
- Send minimized summary to Gemini
- Add explicit educational disclaimer
- Rate limit future requests
- Do not make AI output responsible for calculations; calculations stay deterministic in code
