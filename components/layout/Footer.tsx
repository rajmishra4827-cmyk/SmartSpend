import { ShieldCheck } from "lucide-react";

export function Footer() {
  return (
    <footer className="mt-auto border-t border-slate-200 bg-white py-8 text-sm text-slate-600">
      <div className="mx-auto flex max-w-6xl flex-col items-center justify-between gap-4 px-4 sm:flex-row sm:px-6">
        <div className="flex items-center gap-2 text-slate-700 font-medium">
          <ShieldCheck className="h-4 w-4 text-emerald-600" />
          <span>Private by design. Your financial data stays yours.</span>
        </div>
        <p className="text-slate-500 text-xs sm:text-sm">
          © {new Date().getFullYear()} SmartSpend. Built for Indian college students & early earners.
        </p>
      </div>
    </footer>
  );
}
