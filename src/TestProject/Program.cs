using TestProject;

Console.WriteLine($"{Config.AppName} v{Config.Version}");
Console.WriteLine("---");

var calculator = Config.CreateDefaultCalculator();

Console.WriteLine($"5 + 3 = {calculator.Add(5, 3)}");
Console.WriteLine($"10 - 4 = {calculator.Subtract(10, 4)}");
Console.WriteLine($"6 * 7 = {calculator.Multiply(6, 7)}");
Console.WriteLine($"20 / 4 = {calculator.Divide(20, 4)}");

Console.WriteLine();
Console.WriteLine("Calculator demonstration complete!");
