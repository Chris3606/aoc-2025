namespace AdventOfCode;

public sealed class Day02 : BaseDay
{
    private readonly List<InclusiveRange> _input;

    public Day02()
    {
        _input = File.ReadAllText(InputFilePath).Split(',').Select(InclusiveRange.Parse).ToList();
    }

    public override ValueTask<string> Solve_1()
        => new(FindBadIDs().Sum().ToString());

    public override ValueTask<string> Solve_2() => throw new NotImplementedException();

    private IEnumerable<int> FindBadIDs()
    {
        foreach (var range in _input)
        {
            for (int i = range.Start; i <= range.End; i++)
            {
                var str = i.ToString();
                if (str.Length % 2 != 0) continue;

                if (str[..(str.Length / 2)].Equals(str[(str.Length / 2)..]))
                    yield return i;
            }
        }
    }
}
