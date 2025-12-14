using SadRogue.Primitives;

namespace AdventOfCode;

record Node(string Id, string[] Neighbors)
{
    public override string ToString()
     => $"{Id} => {Neighbors.ExtendToString()}";
};

public sealed class Day11 : BaseDay
{
    private readonly Dictionary<string, Node> _input;

    public Day11()
    {
        _input = new Dictionary<string, Node>();
        
        foreach (var line in File.ReadLines(InputFilePath))
        {
            var parts =  line.Split(": ");
            var nodeId = parts[0];

            _input[nodeId] = new Node(nodeId, Utilities.ParseList(parts[1], ' ', i => i));
        }
    }

    public override ValueTask<string> Solve_1()
    {
        int paths = 0;
        var queue = new Queue<string>();
        queue.Enqueue("you");

        while (queue.Count != 0)
        {
            var nodeId = queue.Dequeue();
            if (nodeId == "out")
                paths++;
            else
            {
                foreach (var neighbor in _input[nodeId].Neighbors)
                    queue.Enqueue(neighbor);
            }
        }
        return new(paths.ToString());
    }

    public override ValueTask<string> Solve_2()
        => new(CountPaths("svr", false, false, new()).ToString());
    
    long CountPaths(string node, bool hasDac, bool hasFft, Dictionary<(string node, bool hasDac, bool hasFft), long> memo)
    {
        var key = (node, hasDac, hasFft);
        if (node == "out")
        {
            var result = hasDac && hasFft ? 1 : 0;
            memo[key] = result;
            return result;
        }
        
        if (memo.TryGetValue(key, out var cached))
            return cached;
    
        bool nextHasDac = hasDac || node == "dac";
        bool nextHasFft = hasFft || node == "fft";
    
        long paths = 0;
        foreach (var n in _input[node].Neighbors)
            paths += CountPaths(n, nextHasDac, nextHasFft, memo);
        
        memo[key] = paths;
        return paths;
    }
}
