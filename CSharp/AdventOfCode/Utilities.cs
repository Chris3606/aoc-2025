using SadRogue.Primitives;
using SadRogue.Primitives.GridViews;

namespace AdventOfCode;

record struct InclusiveRange(int Start, int End)
{
    public static InclusiveRange Parse(string str)
    {
        var parts = str.Split('-');
        var start = int.Parse(parts[0]);
        var end = int.Parse(parts[1]);
        return new InclusiveRange(start, end);
    }
};

static class Utilities
{
    public static Point ParsePoint(string data)
    {
        var split = data.Split(",");
        return new Point(int.Parse(split[0]), int.Parse(split[1]));
    }

    public static T[] ParseList<T>(string source, char separator, Func<string, T> parseFunc)
        => source.Split(separator).Select(parseFunc).ToArray();
    
    public static ArrayView<char> ParseCharGrid(this string value)
    {
        var str = value.Replace("\r", "");
        int width = str.IndexOf('\n');
        return new ArrayView<char>(str.Replace("\n", "").ToCharArray(), width);
    }
}