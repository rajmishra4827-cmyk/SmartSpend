# SmartSpend Agent Rules

You are working on a real, deployable portfolio project with limited AI usage.

## Required reading

Before making any decision, read:

- docs/PRD.md
- docs/TRD.md
- docs/STATUS.md
- this file: docs/AGENT_RULES.md

## Main working rules

1. Work only on the exact task that the user requests.
2. Do not generate the whole application in one request.
3. Do not create features that are not included in the PRD or requested by the user.
4. Do not redesign, rename, delete, refactor, or modify unrelated files.
5. Before coding, first give a concise plan that includes:
   - Files to create or edit
   - Libraries/packages required
   - Assumptions or risks
6. Create a maximum of 3–5 implementation files in one task unless the user explicitly approves more.
7. After a feature is completed, stop and wait for the next task.
8. Update docs/STATUS.md after every completed milestone.

## Approved technology

Use only the approved SmartSpend technology stack:

- Next.js with App Router
- TypeScript
- Tailwind CSS
- Supabase Authentication
- Supabase PostgreSQL
- Supabase Row Level Security
- GitHub
- Vercel

Do not add a new framework, database, UI library, payment provider, or paid API unless the user explicitly approves it.

## Security rules

1. Never expose API keys, passwords, or secret values.
2. Never commit `.env.local` to GitHub.
3. Add only `.env.example` with placeholder variable names.
4. Never put a Supabase service-role key in browser/client code.
5. Use Supabase Row Level Security for every user-owned table.
6. Users must only access their own expenses, budgets, goals, profile, and contributions.
7. Do not add bank credentials, UPI PINs, payment processing, or real bank integration.

## Development rules

1. Use TypeScript strict mode.
2. Use reusable components and clear file names.
3. Use real Supabase data once the related database feature is connected.
4. Do not keep mock financial data after integration.
5. Add loading, error, validation, and empty states for every major feature.
6. Keep business calculations in reusable utility functions.
7. Do not add AI/Gemini features until authentication, expenses, budgets, goals, dashboard, testing, and deployment work.

## Reporting format

After each task, report only:

1. What changed
2. Files created or changed
3. Command(s) run
4. Result
5. What the user should test in the browser
6. Known issue, if any
7. Exact next recommended task