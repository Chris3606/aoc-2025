using GoRogue;

namespace AdventOfCode;

enum Turn {Left, Right}

record struct Instruction(Turn Turn, int Amount);

public sealed class Day01 : BaseDay
{
    private readonly List<Instruction> _input;

    public Day01()
    {
        _input = File.ReadLines(InputFilePath).Select(ParseInstruction).ToList();
    }

    public override ValueTask<string> Solve_1()
    {
        int result = 0;
        int dial = 50;
        foreach (var val in _input.Select(GetInstructionValue))
        {
            dial = MathHelpers.WrapAround(dial + val, 100);
            if (dial == 0)
                result++;
        }

        return new(result.ToString());
    }

    public override ValueTask<string> Solve_2()
    {
        int result = 0;
        int dial = 50;
        foreach (int val in _input.Select(GetInstructionValue))
        {
            // Count full rotations
            result += Math.Abs(val) / 100;
            
            // Update current value
            var oldDial = dial;
            dial = MathHelpers.WrapAround(dial + val, 100);

            // Find if we passed 0 during the remaining wrap.  We ignore if we're _on_ zero; that's captured later.
            if (oldDial != 0 && dial != 0) 
            {
                if ((val < 0 && dial > oldDial) || (val > 0 && dial < oldDial))
                    result += 1; // In this case we have wrapped around during the uncounted, <100 turn
                
            }
            
            if (dial == 0)
                result++;
        }

        return new(result.ToString());
    }

    private static Instruction ParseInstruction(string line)
    {
        var amount = int.Parse(line[1..]);
        return line[0] switch
        {
            'L' => new Instruction(Turn.Left, amount),
            'R' => new Instruction(Turn.Right, amount),
            _ => throw new Exception($"Unknown instruction {line}")
        };
    }
    
    private static int GetInstructionValue(Instruction instr) => instr.Turn switch
    {
        Turn.Left => -instr.Amount,
        Turn.Right => instr.Amount,
        _ => throw new Exception($"Unknown turn {instr.Turn}")
    };
}
