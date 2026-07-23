namespace TestProject;

/// <summary>
/// Application configuration for the calculator.
/// </summary>
public static class Config
{
    /// <summary>
    /// The default number of decimal places for calculations.
    /// </summary>
    public const int DefaultDecimalPlaces = 2;

    /// <summary>
    /// Gets the application name.
    /// </summary>
    public static string AppName => "SimpleCalculator";

    /// <summary>
    /// Gets the application version.
    /// </summary>
    public static string Version => "1.0.0";

    /// <summary>
    /// Gets the default calculator instance.
    /// </summary>
    public static ICalculator CreateDefaultCalculator() =>
        new SimpleCalculator(DefaultDecimalPlaces);
}
