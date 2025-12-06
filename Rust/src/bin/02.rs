use advent_of_code::{IDRange, ParseError};

advent_of_code::solution!(2);

pub fn parse_input(input: &str) -> Result<Vec<IDRange>, ParseError> {
    input.split(',').map(str::parse::<IDRange>).collect()
}

fn is_basic_silly_id(num: u64) -> bool {
    // Convert number to string
    let s = num.to_string();
    let len = s.len();

    if len % 2 != 0 {
        return false;
    }

    let (a, b) = s.split_at(len / 2);

    a == b
}

fn is_advanced_silly_id(num: u64) -> bool {
    // Convert number to string
    let num_data = num.to_string();
    let len = num_data.len();

    // Step over substrings of length 1 to size / 2, check if the string is repeats of that substring.
    for step in 1..=len / 2 {
        if len % step != 0 {
            continue;
        }

        let (first, rest) = num_data.split_at(step);
        if rest
            .as_bytes()
            .chunks(step)
            .all(|chunk| chunk == first.as_bytes())
        {
            return true;
        }
    }

    false
}

pub fn part_one(input: &str) -> Option<u64> {
    let input = parse_input(input).ok()?;

    let result = input
        .into_iter()
        .flatten()
        .filter(|&n| is_basic_silly_id(n))
        .sum();

    return Some(result);
}

pub fn part_two(input: &str) -> Option<u64> {
    let input = parse_input(input).ok()?;

    let result = input
        .into_iter()
        .flatten()
        .filter(|&n| is_advanced_silly_id(n))
        .sum();

    return Some(result);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(1227775554));
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(4174379265));
    }
}
