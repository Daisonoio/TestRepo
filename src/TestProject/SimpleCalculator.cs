namespace TestProject;

/// <summary>
/// A simple implementation of the ICalculator interface.
/// </summary>
public class SimpleCalculator : ICalculator
{
    private readonly int _decimalPlaces;

    /// <summary>
    /// Initializes a new instance of the SimpleCalculator class.
    /// </summary>
    public SimpleCalculator(int decimalPlaces = 0)
    {
        if (decimalPlaces < 0)
            throw new ArgumentException("Decimal places must be non-negative", nameof(decimalPlaces));
        _decimalPlaces = decimalPlaces;
    }

    public int Add(int a, int b) => a + b;

    public int Subtract(int a, int b) => a - b;

    public int Multiply(int a, int b) => a * b;

    public int Divide(int a, int b)
    {
        if (b == 0)
            throw new DivideByZeroException("Cannot divide by zero");
        return a / b;
    }
}
