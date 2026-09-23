import Link from "next/link";
import {
  ArrowRight,
  Shield,
  Target,
  TrendingUp,
  Clock,
  Sparkles,
  AlertTriangle,
} from "lucide-react";

export default function Home() {
  return (
    <div className="flex flex-col items-center">
      {/* Hero Section */}
      <section className="w-full max-w-6xl px-4 pt-12 pb-16 sm:px-6 sm:pt-20 sm:pb-24">
        <div className="mx-auto flex max-w-3xl flex-col items-center text-center">
          <div className="mb-4 inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white px-3.5 py-1.5 text-xs font-semibold text-slate-800 shadow-sm">
            <Sparkles className="h-3.5 w-3.5 text-emerald-600" />
            <span>Built for real student spending: food, transport, subscriptions & goals</span>
          </div>

          <h1 className="text-4xl font-extrabold tracking-tight text-slate-900 sm:text-5xl lg:text-6xl">
            Know where your money goes. <br className="hidden sm:inline" />
            <span className="text-slate-900">Spend smarter in ₹.</span>
          </h1>

          <p className="mt-6 text-lg text-slate-600 sm:text-xl max-w-2xl leading-relaxed">
            The student-first personal finance companion designed for Indian college life and early careers. Track UPI and cash spending, set category limits, and see your daily safe-to-spend amount.
          </p>

          <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-3.5 w-full sm:w-auto">
            <Link
              href="/signup"
              className="inline-flex w-full sm:w-auto items-center justify-center gap-2 rounded-xl bg-slate-900 px-6 py-3.5 text-base font-semibold text-white shadow-sm hover:bg-slate-800 transition"
            >
              Get Started Free
              <ArrowRight className="h-4 w-4" />
            </Link>
            <Link
              href="/login"
              className="inline-flex w-full sm:w-auto items-center justify-center gap-2 rounded-xl border border-slate-300 bg-white px-6 py-3.5 text-base font-semibold text-slate-800 shadow-sm hover:bg-slate-50 transition"
            >
              Log in to account
            </Link>
          </div>

          <div className="mt-6 flex items-center justify-center gap-2 text-xs font-medium text-slate-500">
            <Shield className="h-4 w-4 text-emerald-600" />
            <span>Private by design. Your financial data stays yours.</span>
          </div>
        </div>

        {/* Dashboard Static Preview Component */}
        <div className="mt-14 sm:mt-16 w-full">
          <div className="relative mx-auto max-w-4xl rounded-2xl border border-slate-200 bg-white p-4 shadow-xl sm:p-6 lg:p-8">
            {/* Preview Label */}
            <div className="mb-4 flex items-center justify-between border-b border-slate-100 pb-3">
              <div className="flex items-center gap-2">
                <div className="h-2.5 w-2.5 rounded-full bg-emerald-500"></div>
                <span className="text-xs font-semibold uppercase tracking-wider text-slate-500">
                  Preview dashboard
                </span>
              </div>
              <span className="text-xs font-medium text-slate-400">
                Example monthly overview
              </span>
            </div>

            {/* Static Overview Cards */}
            <div className="grid grid-cols-2 gap-3 sm:grid-cols-4 sm:gap-4 mb-6">
              <div className="rounded-xl border border-slate-100 bg-slate-50/80 p-3.5">
                <span className="text-xs font-medium text-slate-500">Monthly Budget</span>
                <p className="mt-1 text-lg sm:text-xl font-bold text-slate-900">₹12,500</p>
              </div>
              <div className="rounded-xl border border-slate-100 bg-slate-50/80 p-3.5">
                <span className="text-xs font-medium text-slate-500">Spent Month-to-Date</span>
                <p className="mt-1 text-lg sm:text-xl font-bold text-slate-900">₹8,200</p>
              </div>
              <div className="rounded-xl border border-emerald-200 bg-emerald-50/60 p-3.5">
                <span className="text-xs font-medium text-emerald-800">Remaining Budget</span>
                <p className="mt-1 text-lg sm:text-xl font-bold text-emerald-700">₹4,300</p>
              </div>
              <div className="rounded-xl border border-slate-900 bg-slate-900 p-3.5 text-white">
                <span className="text-xs font-medium text-slate-300">Daily Safe-to-Spend</span>
                <p className="mt-1 text-lg sm:text-xl font-bold text-emerald-400">₹215 / day</p>
              </div>
            </div>

            {/* Category Progress & Goal Mock */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="rounded-xl border border-slate-100 bg-white p-4 shadow-sm">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-xs font-semibold text-slate-700">Food & Canteen</span>
                  <span className="text-xs font-bold text-amber-600">₹3,400 / ₹4,000 (85%)</span>
                </div>
                <div className="h-2 w-full rounded-full bg-slate-100">
                  <div className="h-2 rounded-full bg-amber-500" style={{ width: "85%" }}></div>
                </div>
                <div className="mt-2 flex items-center gap-1.5 text-xs text-amber-700 bg-amber-50 p-2 rounded-lg border border-amber-100">
                  <AlertTriangle className="h-3.5 w-3.5 shrink-0" />
                  <span>Approaching budget limit (80%+ used)</span>
                </div>
              </div>

              <div className="rounded-xl border border-slate-100 bg-white p-4 shadow-sm">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-xs font-semibold text-slate-700">Goal: New Laptop Fund</span>
                  <span className="text-xs font-bold text-emerald-700">₹18,000 / ₹45,000 (40%)</span>
                </div>
                <div className="h-2 w-full rounded-full bg-slate-100">
                  <div className="h-2 rounded-full bg-emerald-500" style={{ width: "40%" }}></div>
                </div>
                <div className="mt-2 flex items-center justify-between text-xs text-slate-500">
                  <span>Target date: Nov 2026</span>
                  <span className="font-semibold text-slate-700">₹4,500/mo needed</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Core Features Grid */}
      <section className="w-full bg-white border-y border-slate-200 py-16 sm:py-20">
        <div className="mx-auto max-w-6xl px-4 sm:px-6">
          <div className="text-center max-w-2xl mx-auto mb-12">
            <h2 className="text-2xl font-bold tracking-tight text-slate-900 sm:text-3xl">
              Designed for simple, stress-free money management
            </h2>
            <p className="mt-3 text-sm sm:text-base text-slate-600">
              No complex bank connections. No confusing financial jargon. Just the tools you need to stay on track.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="rounded-2xl border border-slate-200 bg-slate-50/50 p-6">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white mb-4 shadow-sm">
                <Clock className="h-5 w-5 text-emerald-400" />
              </div>
              <h3 className="text-lg font-bold text-slate-900">15-Second Expense Logging</h3>
              <p className="mt-2 text-sm text-slate-600 leading-relaxed">
                Log purchases quickly by amount, category, date, and payment method (UPI, cash, or card) right after paying.
              </p>
            </div>

            <div className="rounded-2xl border border-slate-200 bg-slate-50/50 p-6">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white mb-4 shadow-sm">
                <TrendingUp className="h-5 w-5 text-emerald-400" />
              </div>
              <h3 className="text-lg font-bold text-slate-900">Daily Safe-to-Spend Figure</h3>
              <p className="mt-2 text-sm text-slate-600 leading-relaxed">
                Know instantly how much you can spend today without exceeding your total monthly allowance.
              </p>
            </div>

            <div className="rounded-2xl border border-slate-200 bg-slate-50/50 p-6">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white mb-4 shadow-sm">
                <Target className="h-5 w-5 text-emerald-400" />
              </div>
              <h3 className="text-lg font-bold text-slate-900">Goal-Based Savings</h3>
              <p className="mt-2 text-sm text-slate-600 leading-relaxed">
                Set targets for course fees, laptops, trips, or emergency funds, and watch your contribution progress grow.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Step Guide Section */}
      <section className="w-full max-w-6xl px-4 py-16 sm:px-6 sm:py-20">
        <div className="text-center max-w-2xl mx-auto mb-12">
          <h2 className="text-2xl font-bold tracking-tight text-slate-900 sm:text-3xl">
            How SmartSpend works in 3 simple steps
          </h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="flex flex-col items-center text-center p-6 rounded-xl border border-slate-200 bg-white">
            <span className="flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 font-bold text-slate-900 text-sm mb-4">
              1
            </span>
            <h3 className="font-bold text-slate-900 text-base">Set Monthly Allowance</h3>
            <p className="mt-2 text-xs sm:text-sm text-slate-600">
              Input your monthly allowance or income and set optional category limits for canteen, transport, and recharge.
            </p>
          </div>

          <div className="flex flex-col items-center text-center p-6 rounded-xl border border-slate-200 bg-white">
            <span className="flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 font-bold text-slate-900 text-sm mb-4">
              2
            </span>
            <h3 className="font-bold text-slate-900 text-base">Log Expenses Easily</h3>
            <p className="mt-2 text-xs sm:text-sm text-slate-600">
              Record daily payments on mobile or desktop in seconds to keep your month-to-date totals up to date.
            </p>
          </div>

          <div className="flex flex-col items-center text-center p-6 rounded-xl border border-slate-200 bg-white">
            <span className="flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 font-bold text-slate-900 text-sm mb-4">
              3
            </span>
            <h3 className="font-bold text-slate-900 text-base">Spend & Save Safely</h3>
            <p className="mt-2 text-xs sm:text-sm text-slate-600">
              Check your daily safe-to-spend limit anytime to avoid month-end shortages and hit your savings goals.
            </p>
          </div>
        </div>
      </section>
    </div>
  );
}
