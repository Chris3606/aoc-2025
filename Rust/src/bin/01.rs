use advent_of_code::ParseError;
use std::str::FromStr;

advent_of_code::solution!(1);

#[derive(Debug, Clone, Copy)]
enum Instruction {
    Left(u32),
    Right(u32),
}

impl Instruction {
    fn shifts(self) -> i32 {
        match self {
            Self::Left(val) => -(val as i32),
            Self::Right(val) => val as i32,
        }
    }
}

impl FromStr for Instruction {
    type Err = ParseError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let value = s[1..]
            .parse::<u32>()
            .map_err(|_| ParseError::InvalidInput)?;

        return match s.chars().nth(0) {
            Some('L') => Ok(Instruction::Left(value)),
            Some('R') => Ok(Instruction::Right(value)),
            _ => Err(ParseError::InvalidInput),
        };
    }
}

fn parse_input(input: &str) -> Result<Vec<Instruction>, ParseError> {
    return input.lines().map(str::parse::<Instruction>).collect();
}

pub fn part_one(input: &str) -> Option<u64> {
    let input = parse_input(input).ok()?;

    let mut result = 0;
    let mut current_dial: i32 = 50;
    for instr in input {
        current_dial = (current_dial + instr.shifts()).rem_euclid(100);

        if current_dial == 0 {
            result += 1;
        }
    }

    return Some(result);
}

pub fn part_two(input: &str) -> Option<u64> {
    let input = parse_input(input).ok()?;

    let mut result: u64 = 0;
    let mut current_dial: i32 = 50;
    for instr in input {
        let shifts = instr.shifts();
        // Count full wraps
        result += (shifts.abs() / 100) as u64;

        // Update current value
        let old_current = current_dial;
        current_dial = (current_dial + instr.shifts()).rem_euclid(100);

        // Find if we passed 0 during the remaining wrap.  We ignore if we're _on_ zero; that's captured later.
        if old_current != 0 && current_dial != 0 {
            if (shifts < 0 && current_dial > old_current)
                || (shifts > 0 && current_dial < old_current)
            {
                result += 1; // In this case we have wrapped around during the uncounted, <100 turn
            }
        }

        // Now count if we stopped at zero
        if current_dial == 0 {
            result += 1;
        }
    }

    return Some(result);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(3));
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(6));
    }
}
