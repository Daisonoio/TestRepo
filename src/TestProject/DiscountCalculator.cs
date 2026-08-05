namespace TestProject;

/// <summary>Applies a bounded percentage discount to a price.</summary>
public class DiscountCalculator
{
    public int ApplyDiscount(int price, int percent)
    {
        var safe = PricingRules.Clamp(percent);
        return price - (price * safe / 100);
    }
}
