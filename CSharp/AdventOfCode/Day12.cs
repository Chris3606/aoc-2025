using SadRogue.Primitives;
using SadRogue.Primitives.GridViews;

namespace AdventOfCode;

class TreeArea
{
    public int Width;
    public int Height;

    public int[] PresentsToPlace;
}

class Input
{
    public readonly List<IGridView<char>> Presents = new();
    public readonly List<TreeArea> Areas = new();
}



public sealed class Day12 : BaseDay
{
    private readonly Input _input;

    public Day12()
    {
        _input = new Input();
        
        var parts = File.ReadAllText(InputFilePath).Split(Environment.NewLine + Environment.NewLine);

        foreach (var present in parts[..^1])
            _input.Presents.Add(present[(present.IndexOf('\n') + 1)..].ParseCharGrid());

        foreach (var line in parts[^1].Split(Environment.NewLine))
        {
            var areaParts = line.Split(": ");
            var sizeParts = areaParts[0].Split('x');
            var area = new TreeArea
            {
                Width = int.Parse(sizeParts[0]),
                Height = int.Parse(sizeParts[1]),
                PresentsToPlace = Utilities.ParseList(areaParts[1], ' ', int.Parse)
            };
            _input.Areas.Add(area);
        }
    }

    public override ValueTask<string> Solve_1()
    {
        // The problem is NP-hard.  It appears, though, that on the real input, it is crafted such that you can
        // Simply see if the sum of the areas of the shapes can fit.
        
        // So first, we count the area of each present
        var presentAreas = _input.Presents.Select(CountHashes).ToArray();
        
        // Then, we simply count the number of areas that can fit their selected presents
        int areas = 0;
        foreach (var treeArea in _input.Areas)
        {
            var area = treeArea.Width *  treeArea.Height;
            
            int presentArea = treeArea.PresentsToPlace.Select((x, i) => x * presentAreas[i]).Sum();
            if (presentArea <= area)
                areas++;
        }

        return new(areas.ToString());
    }

    public override ValueTask<string> Solve_2() => throw new NotImplementedException();

    private static int CountHashes(IGridView<char> grid)
        => grid.Positions().Select(i => grid[i]).Count(i => i == '#');

}
