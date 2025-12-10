using SadRogue.Primitives;

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
}