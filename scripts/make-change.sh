#!/usr/bin/env bash
# Generates a realistic, multi-file change in TestProject so you have something to review with
# ReviewCheck. Run it, then open Claude Code here and run /reviewcheck.agent.
#
# Adds a small "discount pricing" feature across several seams:
#   - PricingRules.cs        (new) a MaxDiscountPercent constant + a Clamp() helper
#   - DiscountCalculator.cs  (new) ApplyDiscount(), which USES PricingRules.Clamp
#   - Program.cs             (edit) a couple of lines that USE DiscountCalculator
# The result is an interesting diff with cross-file links (a "seam" to check) — exactly the shape
# ReviewCheck is built to walk you through.
#
# Usage:
#   ./scripts/make-change.sh            # generate the change
#   ./scripts/make-change.sh --reset    # revert it (clean slate for another test)
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
proj="$root/src/TestProject"
pricing="$proj/PricingRules.cs"
discount="$proj/DiscountCalculator.cs"
program="$proj/Program.cs"
marker="// >>> reviewcheck-sample-change (added by scripts/make-change.sh)"

if [[ "${1:-}" == "--reset" ]]; then
  rm -f "$pricing" "$discount"
  git -C "$root" checkout -- src/TestProject/Program.cs
  echo "Reverted the sample change. 'git status' should be clean."
  exit 0
fi

cat > "$pricing" <<'CS'
namespace TestProject;

/// <summary>
/// Rules that constrain how discounts may be applied.
/// </summary>
public static class PricingRules
{
    /// <summary>The largest discount, as a percentage, that may ever be applied.</summary>
    public const int MaxDiscountPercent = 50;

    /// <summary>
    /// Clamps a requested discount percentage into the allowed range [0, MaxDiscountPercent].
    /// </summary>
    public static int Clamp(int percent) =>
        percent < 0 ? 0 : percent > MaxDiscountPercent ? MaxDiscountPercent : percent;
}
CS

cat > "$discount" <<'CS'
namespace TestProject;

/// <summary>
/// Applies discounts to prices, honouring <see cref="PricingRules"/>.
/// </summary>
public class DiscountCalculator
{
    /// <summary>
    /// Applies <paramref name="requestedPercent"/> off <paramref name="price"/>, capped by the rules.
    /// </summary>
    public decimal ApplyDiscount(decimal price, int requestedPercent)
    {
        var percent = PricingRules.Clamp(requestedPercent);
        return price - price * percent / 100m;
    }
}
CS

if ! grep -qF "$marker" "$program"; then
  cat >> "$program" <<CS

$marker
Console.WriteLine();
var discounts = new DiscountCalculator();
Console.WriteLine(\$"100.00 with 20% off        = {discounts.ApplyDiscount(100.00m, 20)}");
Console.WriteLine(\$"100.00 with 80% off (capped) = {discounts.ApplyDiscount(100.00m, 80)}");
CS
fi

echo "Sample change generated. Review it with:"
echo "  git status          # 2 new files + Program.cs modified"
echo "  /reviewcheck.agent   (inside Claude Code)"
