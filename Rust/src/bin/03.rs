use advent_of_code::ParseError;

advent_of_code::solution!(3);

fn index_of_max(battery_bank: &[char]) -> Option<usize> {
    if battery_bank.is_empty() {
        return None;
    }
    let mut max = 0;

    for (idx, ch) in battery_bank.iter().enumerate().skip(1) {
        if *ch > battery_bank[max] {
            max = idx;
        }
    }

    Some(max)
}

fn find_max_joltage(battery_bank: &str, batteries_to_activate: u32) -> Result<u64, ParseError> {
    if battery_bank.len() < batteries_to_activate as usize {
        return Err(ParseError::InvalidInput);
    }

    let mut digits = String::new();
    let chars: Vec<_> = battery_bank.chars().collect();
    let mut remaining_batteries = chars.as_slice();
    for num_batteries_remaining in (1..=batteries_to_activate).rev() {
        let num_batteries_remaining = num_batteries_remaining as usize;

        let max_battery_idx = index_of_max(
            &remaining_batteries[0..remaining_batteries.len() - num_batteries_remaining + 1],
        )
        .unwrap();

        digits.push(remaining_batteries[max_battery_idx]);

        // The next digits we select must come after the one we just selected, since we can't re-order
        remaining_batteries = &remaining_batteries[max_battery_idx + 1..];
    }

    return digits.parse().map_err(|_| ParseError::InvalidInput);
}

pub fn part_one(input: &str) -> Option<u64> {
    let input: Vec<_> = input.lines().collect();
    let result = input
        .into_iter()
        .map(|bank| find_max_joltage(bank, 2))
        .sum::<Result<_, _>>()
        .ok()?;

    Some(result)
}

pub fn part_two(input: &str) -> Option<u64> {
    let input: Vec<_> = input.lines().collect();
    let result = input
        .into_iter()
        .map(|bank| find_max_joltage(bank, 12))
        .sum::<Result<_, _>>()
        .ok()?;

    Some(result)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(357));
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(3121910778619));
    }
}
