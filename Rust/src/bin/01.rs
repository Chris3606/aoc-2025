use advent_of_code::ParseError;
use std::str::FromStr;

advent_of_code::solution!(1);

enum Instruction {
    Left(u32),
    Right(u32),
}

impl FromStr for Instruction {
    type Err = ParseError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let value = s[1..]
            .parse::<u32>()
            .map_err(|_| ParseError::InvalidInput)?;

        return match s.bytes().nth(0) {
            Some(b'L') => Ok(Instruction::Left(value)),
            Some(b'R') => Ok(Instruction::Right(value)),
            _ => Err(ParseError::InvalidInput),
        };
    }
}

fn parse_input(input: &str) -> Result<Vec<Instruction>, ParseError> {
    let mut vec = vec![];
    for line in input.lines() {
        vec.push(line.parse::<Instruction>()?);
    }

    return Ok(vec);
}

pub fn part_one(input: &str) -> Option<u64> {}

pub fn part_two(input: &str) -> Option<u64> {
    None
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, None);
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, None);
    }
}
