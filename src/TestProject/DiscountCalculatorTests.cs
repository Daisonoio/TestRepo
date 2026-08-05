using Xunit;

namespace TestProject;

public class DiscountCalculatorTests
{
    [Fact]
    public void ApplyDiscount_CapsAtMax()
    {
        var calc = new DiscountCalculator();
        Assert.Equal(50, calc.ApplyDiscount(100, 90));
    }
}
