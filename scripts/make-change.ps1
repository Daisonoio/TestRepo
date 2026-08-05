<#
.SYNOPSIS
    Generates a realistic, multi-file change in TestProject so you have something to review with
    ReviewCheck. Run it, then open Claude Code here and run /reviewcheck.agent.

.DESCRIPTION
    Adds a small "discount pricing" feature across several seams:
      - PricingRules.cs        (new) a MaxDiscountPercent constant + a Clamp() helper
      - DiscountCalculator.cs   (new) ApplyDiscount(), which USES PricingRules.Clamp
      - Program.cs            (edit) a couple of lines that USE DiscountCalculator
    The result is an interesting diff with cross-file links (a "seam" to check), exactly the shape
    ReviewCheck is built to walk you through.

.PARAMETER Reset
    Reverts the change (deletes the new files, restores Program.cs) so you can run a clean test again.

.EXAMPLE
    ./scripts/make-change.ps1
    ./scripts/make-change.ps1 -Reset
#>
[CmdletBinding()]
param([switch]$Reset)

$ErrorActionPreference = 'Stop'
$root     = Split-Path -Parent $PSScriptRoot          # repo root (this script lives in scripts/)
$proj     = Join-Path $root 'src/TestProject'
$pricing  = Join-Path $proj 'PricingRules.cs'
$discount = Join-Path $proj 'DiscountCalculator.cs'
$program  = Join-Path $proj 'Program.cs'
$marker   = '// >>> reviewcheck-sample-change (added by scripts/make-change.ps1)'

if ($Reset) {
    Remove-Item -Force -ErrorAction SilentlyContinue $pricing, $discount
    git -C $root checkout -- 'src/TestProject/Program.cs'
    Write-Host 'Reverted the sample change. `git status` should be clean.' -ForegroundColor Green
    return
}

@'
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
'@ | Set-Content -Path $pricing -Encoding UTF8

@'
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
'@ | Set-Content -Path $discount -Encoding UTF8

if ((Get-Content -Raw $program) -notmatch [regex]::Escape($marker)) {
    @"

$marker
Console.WriteLine();
var discounts = new DiscountCalculator();
Console.WriteLine($"100.00 with 20% off        = {discounts.ApplyDiscount(100.00m, 20)}");
Console.WriteLine($"100.00 with 80% off (capped) = {discounts.ApplyDiscount(100.00m, 80)}");
"@ | Add-Content -Path $program -Encoding UTF8
}

Write-Host 'Sample change generated. Review it with:' -ForegroundColor Green
Write-Host '  git status        # 2 new files + Program.cs modified'
Write-Host '  /reviewcheck.agent  (inside Claude Code)'
