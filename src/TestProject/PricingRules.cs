namespace TestProject;

/// <summary>Domain rules for discount percentages.</summary>
public static class PricingRules
{
    public const int MaxDiscountPercent = 50;

    public static int Clamp(int percent) =>
        percent < 0 ? 0 : percent > MaxDiscountPercent ? MaxDiscountPercent : percent;
}
