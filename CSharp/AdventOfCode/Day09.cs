using GoRogue;
using GoRogue.MapGeneration;
using SadRogue.Primitives;
using SadRogue.Primitives.GridViews;

namespace AdventOfCode;

public sealed class Day09 : BaseDay
{
    private readonly List<Point> _input;

    public Day09()
    {
        _input = File.ReadLines(InputFilePath).Select(Utilities.ParsePoint).ToList();
    }

    public override ValueTask<string> Solve_1()
    {
        
        return new(FindMaxArea(_input).ToString());
    }

    public override ValueTask<string> Solve_2()
    {
        // long result = 0;
        // var area = new PolygonArea(_input);
        //
        // var redOrGreen = area.OuterPoints.Concat(area.InnerPoints).ToHashSet();
        //
        // var eligiblePoints = new List<Point>();
        // int i = 0;
        // foreach (var p1 in _input)
        // {
        //     foreach (var p2 in _input[(i + 1)..])
        //     {
        //         var rect = RectFromTwoCorners(p1, p2);
        //         bool include = rect.Positions().All(redOrGreen.Contains);
        //         if (!include) break;
        //         
        //         long areaCalc = ((long)Math.Abs(p1.X - p2.X) + 1) * ((long)Math.Abs(p1.Y - p2.Y) + 1);
        //         result = Math.Max(result, areaCalc);
        //     }
        //     i++;
        // }

        //var areas = GetAreas(_input).OrderBy(i => i.Area).Reverse();

        var lines = new List<(Point, Point)>();
        for (int i = 0; i < _input.Count - 1; i++)
            lines.Add((_input[i], _input[i + 1]));
        
        lines.Add((_input[^1], _input[0]));

        foreach (var area in GetAreas(_input).OrderBy(i => i.Area).Reverse())
        {
            if (lines.All(tuple =>
                {
                    // Conditions that establish where the line is relative to the rect
                    var leftOf = area.MaxExtentX <= Math.Min(tuple.Item1.X, tuple.Item2.X);
                    var rightOf = area.MinExtentX >= Math.Max(tuple.Item1.X, tuple.Item2.X);
                    var above = area.MaxExtentY <= Math.Min(tuple.Item1.Y, tuple.Item2.Y);
                    var below = area.MinExtentY >= Math.Max(tuple.Item1.Y, tuple.Item2.Y);

                    return leftOf || rightOf || above || below;
                }))
                return new(area.Area.ToString());;
        }

        throw new Exception("No rectangles were composed entirely of green points...");
    }

    private Rectangle RectFromTwoCorners(Point p1, Point p2)
    {
        var minExtent = new Point(Math.Min(p1.X, p2.X), Math.Min(p1.Y, p2.Y));
        var maxExtent = new Point(Math.Max(p1.X, p2.X), Math.Max(p1.Y, p2.Y));
        return new Rectangle(minExtent, maxExtent);
    }

    private IEnumerable<Rectangle> GetAreas(List<Point> points)
    {
        int i = 0;
        foreach (var p1 in points)
        {
            foreach (var p2 in points[(i + 1)..])
                yield return RectFromTwoCorners(p1, p2);
            
            i++;
        }
    }

    private long FindMaxArea(IReadOnlyList<Point> points)
    {
        long result = 0;
        int i = 0;
        foreach (var p1 in _input)
        {
            foreach (var p2 in _input[(i + 1)..])
            {
                long area = ((long)Math.Abs(p1.X - p2.X) + 1) * ((long)Math.Abs(p1.Y - p2.Y) + 1);
                result = Math.Max(result, area);
            }
            i++;
        }

        return result;
    }
}
