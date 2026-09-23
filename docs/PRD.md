# SmartSpend — Product Requirements Document (PRD)

**Version:** 1.0  
**Status:** Build-ready MVP specification  
**Project type:** Personal portfolio / full-stack web application  
**Primary market:** Indian college students and early-career users  
**Platform:** Responsive web application, mobile-first

## 1. Product summary

SmartSpend is a student-first personal finance companion that helps users record daily expenses, set monthly/category budgets, track savings goals, and understand their safe-to-spend amount. It is designed for people who make many small digital payments, often lose track of where money goes, and want simple saving habits without a complicated banking application.

**Tagline:** Know where your money goes. Spend smarter. Save without stress.

## 2. Problem statement

College students and first-time earners commonly receive a fixed allowance or income but make frequent small expenses on food, transport, recharge, subscriptions, college needs, shopping, and digital payments. These expenses are easy to forget and difficult to compare with a monthly limit. Existing finance tools can be complicated, expensive, generic, or focused on bank-linked financial management.

Users need a private, simple, INR-first tool that answers:

> How much have I spent, where did it go, how much can I safely spend today, and am I still progressing toward my savings goal?

## 3. Target users

### Primary persona — student budgeter

- Age: 17–24
- Context: College student, often lives with parents, in a hostel, PG, or shared flat
- Income source: Allowance, stipend, part-time income, scholarship, or small freelance income
- Payment habits: Frequent UPI/cash/card spending
- Pain points: Small purchases are forgotten; food/delivery and shopping spending rises without notice; saving for a laptop, trip, course, or emergency is difficult
- Goal: Stay within a monthly amount and save consistently

### Secondary persona — first-time earner

- Age: 21–28
- Context: Internship or first job
- Goal: Build a basic budgeting habit, handle recurring expenses, and save for personal goals

## 4. Product goals

1. Let a new user sign up and start tracking spending in under five minutes.
2. Let a user add an expense in under fifteen seconds.
3. Show clear month-to-date spending, remaining budget, and category breakdown.
4. Help the user create at least one measurable savings goal.
5. Provide useful budget alerts before the user overspends.
6. Keep every user’s financial data private and isolated.
7. Deliver a polished, responsive, deployable portfolio product.

## 5. Non-goals for MVP

The first version will not include:

- Bank-account, UPI, SMS, or email transaction scraping
- Real payments, money transfer, loans, investments, or stock recommendations
- Credit-score features
- Shared wallets or expense splitting
- Receipt scanning/OCR
- Tax filing or professional financial advice
- Full conversational AI chatbot

## 6. MVP scope

### A. Authentication and onboarding

- Email/password sign-up
- Login and logout
- Protected dashboard routes
- Onboarding form after registration
- Monthly income/allowance input
- Month start date preference, defaulting to the 1st
- Optional initial monthly budget and first savings goal

### B. Expense management

- Add expense: amount, category, date, note, payment method
- Default date to today
- List current and past expenses
- Edit an expense
- Delete an expense with confirmation
- Filter by month, category, and date range
- Categories: Food, Canteen/Mess, Food Delivery, Transport, Recharge, Education, Shopping, Entertainment, Health, Rent/Hostel, Bills, Subscription, Other

### C. Budgets

- Create/edit a total monthly budget
- Create/edit category budgets for a selected month
- Show spent amount, remaining amount, and percentage used
- Show warning at 80% and exceeded state at 100%

### D. Savings goals

- Create goal: title, target amount, target date, optional icon/color
- Add saved amount/contribution
- Display current progress and percentage
- Mark goal complete when saved amount reaches target amount
- Show required monthly/weekly saving estimate when a target date exists

### E. Dashboard

- Current-month total spending
- Monthly budget remaining
- Daily safe-to-spend amount
- Current savings-goal progress
- Recent expenses
- Category-wise spending chart
- Top spending category
- Actionable rule-based insight/warning

### F. Profile and data controls

- Update display name and monthly income/allowance
- Currency fixed to INR in MVP
- Delete expense records through the UI
- Account deletion/data export are post-MVP enhancements

## 7. Core calculations

### Monthly spending

`monthlySpending = sum(expenses.amount for current selected month)`

### Remaining monthly budget

`remainingBudget = monthlyBudget - monthlySpending`

### Days remaining

`daysRemaining = number of calendar days including today until month end`

### Safe-to-spend today

`dailySafeToSpend = max(0, remainingBudget / daysRemaining)`

If no monthly budget is defined, show a setup prompt instead of a calculated value.

### Category budget usage

`usagePercent = (categorySpent / categoryBudget) × 100`

### Goal progress

`goalProgressPercent = min(100, (savedAmount / targetAmount) × 100)`

## 8. Rule-based smart insights (MVP)

These are deterministic rules, not AI advice:

- If a category reaches 80% of its budget: show a warning.
- If a category exceeds its budget: show an exceeded alert.
- If total spending is greater than the monthly budget: show a spending-limit alert.
- If the user’s current month spending is at least 15% above the previous month at the same point: show a comparative insight.
- If goal progress is behind the weekly saving estimate: show a gentle goal reminder.
- If no expense has been added for seven days: show a neutral reminder to update records.

## 9. Future AI feature

A future optional feature called **SmartSpend Insights** will generate short, non-judgmental summaries from an aggregated financial snapshot. It will not receive passwords, payment credentials, raw bank data, or any other user’s data.

Example output:

> Food spending is your largest category this month. Staying ₹150 below your food budget this week would keep your monthly plan on track.

AI constraints:

- Educational budgeting insights only
- No investment, tax, credit, loan, legal, or medical advice
- No claim that advice is personalized professional financial advice
- Server-side API calls only; never expose API keys in browser code
- User must actively request an AI insight in the first version

## 10. User stories and acceptance criteria

| ID | User story | Acceptance criteria |
|---|---|---|
| US-01 | As a user, I want to create an account so I can keep my data private. | User can sign up, verify session, and cannot access protected pages while logged out. |
| US-02 | As a user, I want to log an expense quickly. | Amount, category, and date are required; valid expense appears in history and dashboard totals after save. |
| US-03 | As a user, I want to edit/delete an expense so my records stay correct. | User can edit/delete only their own expense; totals recalculate after changes. |
| US-04 | As a user, I want a monthly budget so I know my spending limit. | User can save one monthly budget per month; remaining amount is visible. |
| US-05 | As a user, I want category budgets so I can control problem areas like food. | User can set a category limit and see spent/remaining/usage percentage. |
| US-06 | As a user, I want a safe-to-spend figure so I can make a daily decision. | Dashboard calculates remaining budget divided by days remaining; explains when budget is missing. |
| US-07 | As a user, I want a savings goal so I can track progress toward something meaningful. | User can create goal, add contribution, see percentage and completion state. |
| US-08 | As a user, I want charts and summaries so I can understand my spending. | Dashboard displays current-month totals, recent expenses, category chart, and top category. |
| US-09 | As a user, I want my data private. | Database security policies prevent users from reading/modifying any other user’s rows. |

## 11. Screen list

1. Landing page
2. Sign up page
3. Login page
4. Onboarding page
5. Dashboard
6. Expense list
7. Add/edit expense modal or page
8. Budget page
9. Savings goals page
10. Profile/settings page
11. Empty states and error/not-found screens

## 12. Success metrics for portfolio demo

- A new user can sign up, complete onboarding, and reach dashboard.
- An expense is added, updated, deleted, and reflected in dashboard totals correctly.
- A category budget reaches warning/exceeded state correctly.
- A savings goal contribution changes progress correctly.
- Two test users cannot see each other’s records.
- App works on desktop and mobile-width screens.
- App is deployed and accessible through Vercel.

## 13. Product differentiation

SmartSpend differentiates itself as a low-friction, India-aware, student-first budgeting product. Its most important user value is not a large set of financial charts; it is the simple daily decision support of a safe-to-spend amount, category alerts, and goal-linked saving.

## 14. Risks and mitigations

| Risk | Mitigation |
|---|---|
| Feature overload | Finish authentication, expenses, dashboard, budgets, and goals before any advanced feature. |
| Incorrect financial calculations | Use centralized calculation helpers and manually test known sample cases. |
| Data privacy issue | Use Supabase Auth, Row Level Security, and per-user foreign keys from day one. |
| AI cost/complexity | Build rules first; make Gemini insight optional and post-MVP. |
| Poor manual-entry retention | Use short forms, default date/category, recent categories, and helpful empty states. |
| Deployment failure | Deploy early after authentication and test each major release. |
