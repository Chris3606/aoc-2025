using System.Collections;
using System.Collections.Specialized;
using SadRogue.Primitives;

namespace AdventOfCode;

public sealed class Part2StateEqualityComparer 
    : IEqualityComparer<(int[] joltage, int depth)>
{
    public bool Equals((int[] joltage, int depth) x, (int[] joltage, int depth) y)
    {
        if (x.depth != y.depth)
            return false;
        
        if (x.joltage == null || y.joltage == null)
            return x.joltage == y.joltage;
        
        return x.joltage.AsSpan().SequenceEqual(y.joltage);
    }

    public int GetHashCode((int[] joltage, int depth) obj)
    {
        var hash = obj.depth;

        // Fold state contents into hash
        if (obj.joltage != null)
        {
            unchecked
            {
                foreach (var v in obj.joltage)
                    hash = (hash * 31) ^ v;
            }
        }

        return hash;
    }
}

class Machine
{

    public readonly BitVector32 IndicatorLights;
    public readonly BitVector32 DesiredState;
    public readonly List<List<int>> ButtonSchematics;
    public readonly List<int> JoltageRequirements;
    public int LightsCount;

    public Machine(string input)
    {
        var split = input.Split(' ');
        var indicatorData = split[0];

        IndicatorLights = new BitVector32(0);
        DesiredState = new BitVector32(0);
        LightsCount = indicatorData.Length - 2;

        for (int i = 1; i < indicatorData.Length - 1; i++)
            DesiredState[1 << (i - 1)] = indicatorData[i] == '#';


        ButtonSchematics = [];
        JoltageRequirements = [];
        foreach (var data in split.Skip(1))
        {
            if (data.StartsWith('('))
            {
                var parts = data.Trim('(', ')').Split(',');
                var curSchematic = parts.Select(int.Parse).ToList();
                ButtonSchematics.Add(curSchematic);
            }
            else
            {
                var parts = data.Trim('{', '}').Split(',');
                JoltageRequirements = parts.Select(int.Parse).ToList();
            }
        }
    }

    public override string ToString()
    {
        string result = "";
        
        result += "Indicators: " + IndicatorsToString(IndicatorLights) + "\n";
        result += "Desired:    " + IndicatorsToString(DesiredState) + "\n";
        result += "Schematics: " + ButtonSchematics.ExtendToString(elementStringifier: l => l.ExtendToString()) + "\n";
        result += "Joltage:    " + JoltageRequirements.ExtendToString()  + "\n";

        return result;
    }

    private string IndicatorsToString(BitVector32 indicatorLights)
    {
        var result = "";
        for (int i = 0; i < LightsCount; i++)
            result += indicatorLights[1 << i] ? "#" : ".";

        return result;
    }
}

public sealed class Day10 : BaseDay
{
    private readonly List<Machine> _input;

    public Day10()
    {
        _input = File.ReadLines(InputFilePath).Select(l => new Machine(l)).ToList();
        foreach (var m in _input)
            Console.WriteLine(m.ToString());
    }

    public override ValueTask<string> Solve_1()
        => new(_input.Select(DetermineFewestButtons).Sum().ToString());

    public override ValueTask<string> Solve_2()
        => new(_input.Select(DetermineFewestButtons2).Sum().ToString());
    // {
    //     return new(_input.Select(i =>
    //     {
    //         var memo = new Dictionary<(int[] joltage, int depth), int>(new Part2StateEqualityComparer());
    //         return DetermineFewestButtons2(i, (i.JoltageRequirements.Select(_ => 0).ToArray(), 0), memo, 15);
    //     }).Sum().ToString());
    // }

    private static int DetermineFewestButtons(Machine m)
    {
        var newStates = new Queue<(BitVector32 state, int depth)>();
        newStates.Enqueue((m.IndicatorLights, 0));
        while (newStates.Count != 0)
        {
            var (currentState, depth) = newStates.Dequeue();
            foreach (var schematic in m.ButtonSchematics)
            {
                var newState = new BitVector32(currentState.Data);
                foreach (var button in schematic)
                    newState[1 << button] = !newState[1 << button];

                if (newState.Data == m.DesiredState.Data)
                    return depth + 1;
                
                newStates.Enqueue((newState, depth + 1));
            }
        }

        throw new Exception("Couldn't achieve desired state.");

    }
    
    private static int DetermineFewestButtons2(Machine m)
    {
        var newStates = new Queue<(int[] state, int depth)>();
        newStates.Enqueue((m.JoltageRequirements.Select(_ => 0).ToArray(), 0));
        while (newStates.Count != 0)
        {
            var (currentState, depth) = newStates.Dequeue();
            foreach (var schematic in m.ButtonSchematics)
            {
                var newState = new int[currentState.Length];
                currentState.CopyTo(newState, 0);
                foreach (var button in schematic)
                    newState[button]++;

                if (m.JoltageRequirements.SequenceEqual(newState))
                {
                    Console.WriteLine("Solved one.");
                    return depth + 1;
                }

                bool possible = true;
                for (int i = 0; i < m.JoltageRequirements.Count; i++)
                {
                    if (newState[i] > m.JoltageRequirements[i])
                    {
                        possible = false;
                        break;
                    }
                }

                if (!possible)
                    continue;
                newStates.Enqueue((newState, depth + 1));
            }
        }
    
        throw new Exception("Couldn't achieve desired state.");
    
    }

    // private static (int[] joltage, int depth) CloneState((int[] joltage, int depth) state)
    // {
    //     var joltage = new int[state.joltage.Length];
    //     Array.Copy(state.joltage, joltage, state.joltage.Length);
    //     return  (joltage, state.depth);
    // }
    //
    // private static int DetermineFewestButtons2(Machine m, (int[] joltage, int depth) currentState, Dictionary<(int[] joltage, int depth), int> memo, int depthLimit)
    // {
    //     if (memo.TryGetValue(currentState, out var presses))
    //     {
    //         memo[CloneState(currentState)] = presses;
    //         return presses;
    //     }
    //
    //     // Ignore results over max depth
    //     if (currentState.depth > depthLimit)
    //     {
    //         memo[CloneState(currentState)] = int.MaxValue;
    //         return int.MaxValue;
    //     }
    //
    //     List<int> options = [];
    //     foreach (var schematic in m.ButtonSchematics)
    //     {
    //         // Apply button press
    //         foreach (var button in schematic)
    //             currentState.joltage[button]++;
    //         
    //         // If we've equaled, none of the children can be the right answer since we're a lower depth.
    //         if (m.JoltageRequirements.SequenceEqual(currentState.joltage))
    //         {
    //             memo[CloneState((currentState.joltage, currentState.depth + 1))] = currentState.depth + 1;
    //             
    //             // Reverse the button press
    //             foreach (var button in schematic)
    //                 currentState.joltage[button]--;
    //             
    //             return currentState.depth + 1;
    //         }
    //         
    //         // Otherwise, calculate result based on this new state, and add it to the list of possible resolves.
    //         var result = DetermineFewestButtons2(m, (currentState.joltage, currentState.depth + 1), memo, depthLimit);
    //         options.Add(result);
    //         
    //         // Reverse the button press
    //         foreach (var button in schematic)
    //             currentState.joltage[button]--;
    //     }
    //
    //     // Whatever the minimum option at this depth is, is the right one.
    //     return options.Min();
    //     
    //     // var newStates = new Queue<(int[] state, int depth)>();
    //     // newStates.Enqueue((m.JoltageRequirements.Select(_ => 0).ToArray(), 0));
    //     // while (newStates.Count != 0)
    //     // {
    //     //     var (currentState, depth) = newStates.Dequeue();
    //     //     foreach (var schematic in m.ButtonSchematics)
    //     //     {
    //     //         var newState = new int[currentState.Length];
    //     //         currentState.CopyTo(newState, 0);
    //     //         foreach (var button in schematic)
    //     //             newState[button]++;
    //     //         
    //     //         if (m.JoltageRequirements.SequenceEqual(newState))
    //     //             return depth + 1;
    //     //
    //     //         newStates.Enqueue((newState, depth + 1));
    //     //     }
    //     // }
    //     //
    //     // throw new Exception("Couldn't achieve desired state.");
    //
    // }
    // private static int DetermineFewestButtons(Machine m, BitVector32 currentState)
    // {
    //     if (currentState.Data == m.DesiredState.Data)
    //         return 0;
    //     
    //     var newStates = new List<BitVector32>();
    //     foreach (var schematic in m.ButtonSchematics)
    //     {
    //         var newState = new  BitVector32(currentState.Data);
    //         foreach (var button in schematic)
    //             newState[1 << button] = !newState[1 << button];
    //
    //         if (newState.Data == m.DesiredState.Data)
    //             return 1;
    //         
    //         newStates.Add(newState);
    //     }
    //     
    //     int minPresses = int.MaxValue;
    //     foreach (var newState in newStates)
    //     {
    //         minPresses = Math.Min(minPresses, DetermineFewestButtons(m, newState));
    //         if (minPresses == 1)
    //             break;
    //     }
    //
    //     return minPresses + 1;
    // }
}
