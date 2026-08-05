using TestProject;

var calculator = Config.CreateDefaultCalculator();
var discounter = new DiscountCalculator();

int price = 200;
Console.WriteLine($"Original: {price}");
Console.WriteLine($"Discounted 20%: {discounter.ApplyDiscount(price, 20)}");
Console.WriteLine($"Sanity: {calculator.Add(1, 2)}");
