using BlazorSmoke.Services;
namespace BlazorSmoke.Tests;
public class GreetingTests
{
    [Fact]
    public void GreetsTheRequestedName() => Assert.Equal("Hello, Blazor!", new GreetingService().Greet("Blazor"));
}
