namespace TestProject;

/// <summary>
/// Defines a basic calculator interface for arithmetic operations.
/// </summary>
public interface ICalculator
{
    /// <summary>
    /// Adds two numbers and returns the result.
    /// </summary>
    int Add(int a, int b);

    /// <summary>
    /// Subtracts b from a and returns the result.
    /// </summary>
    int Subtract(int a, int b);

    /// <summary>
    /// Multiplies two numbers and returns the result.
    /// </summary>
    int Multiply(int a, int b);

    /// <summary>
    /// Divides a by b and returns the result.
    /// </summary>
    int Divide(int a, int b);
}
