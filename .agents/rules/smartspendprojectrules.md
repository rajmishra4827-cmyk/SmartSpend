---
trigger: always_on
---

# SmartSpend Workspace Rules

## Product context

SmartSpend is a student-first, privacy-first personal finance web application
for Indian college students and early-career users.

Before planning or coding, read:

- @docs/PRD.md
- @docs/TRD.md
- @docs/STATUS.md
- @docs/AGENT_RULES.md

## Approved technology only

Use only:

- Next.js App Router
- TypeScript with strict mode
- Tailwind CSS
- Supabase Authentication
- Supabase PostgreSQL
- Supabase Row Level Security
- GitHub
- Vercel

Do not add another framework, database, paid API, bank API, UPI integration,
payment gateway, or UI library unless the user explicitly approves it.

## Token-saving rules

1. Never generate the full application in one task.
2. Work only on the exact requested milestone.
3. Before writing code, give a concise plan.
4. Create or modify a maximum of 3–5 implementation files per task unless approved.
5. Do not refactor, rename, delete, or modify unrelated files.
6. Stop after the requested milestone works.
7. Update @docs/STATUS.md after every finished milestone.
8. Never use multi-agent teamwork mode unless explicitly requested.

## Security rules

1. Never expose API keys, passwords, or secrets.
2. Never commit `.env.local`.
3. Create `.env.example` with placeholder names only.
4. Never use a Supabase service-role key in browser/client code.
5. All user-owned data must use Supabase Row Level Security.
6. Users can access only their own profiles, expenses, budgets, goals,
   and goal contributions.
7. Do not implement bank credentials, UPI PINs, payment transfers,
   investments, loans, or professional financial advice.

## UI and design rules

1. Design mobile-first, then desktop.
2. Create a calm, premium, modern student-fintech experience.
3. Do not use generic AI-dashboard styling.
4. Do not use excessive gradients, neon colours, clutter, unnecessary animations,
   huge rounded cards, or too many charts.
5. Prefer deep navy, warm off-white/light slate, emerald savings green,
   amber warnings, and soft red over-budget states.
6. Use clear typography, whitespace, subtle borders, accessible contrast,
   and simple financial hierarchy.
7. Format Indian currency correctly, for example: ₹1,250.
8. On the dashboard, show monthly spend, remaining budget,
   daily safe-to-spend amount, and active savings goal without excessive scrolling.
9. Add polished loading, empty, success, validation, and error states.
10. Use non-judgmental copy. Never shame users for spending.

## Development rules

1. Use real Supabase data after the related database feature is connected.
2. Keep calculations in reusable TypeScript utility functions.
3. Validate every form with a shared schema.
4. Do not add Gemini/AI features until authentication, expenses, budgets,
   goals, dashboard, testing, and deployment are complete.
5. Test every requested feature before declaring it complete.

## Required response format

After every task, respond only with:

1. What changed
2. Files created or changed
3. Commands run
4. Result
5. What I should test in the browser
6. Known issue, if any
7. Exact next recommended task