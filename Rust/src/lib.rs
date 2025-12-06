pub mod template;

use std::ops::RangeInclusive;
use std::str::FromStr;

// Use this file to add helper functions and additional modules.

/// Errors commonly returned from parsing functions to indicate bad input.
pub enum ParseError {
    InvalidInput,
}

/// A type representing an inclusive numerical range, with some parsing helpers and other functions.
#[derive(Debug, Clone)]
pub struct IDRange(pub RangeInclusive<u64>);

impl IntoIterator for IDRange {
    type Item = u64;
    type IntoIter = RangeInclusive<u64>;

    /// Returns an owned variant of the underlying RangeInclusive, which is iterable.
    fn into_iter(self) -> Self::IntoIter {
        self.0
    }
}

impl FromStr for IDRange {
    type Err = ParseError;

    /// Parses an IDRange from a string formatted in the form "<min>-<max>".
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (begin, end) = s.split_once('-').ok_or(ParseError::InvalidInput)?;
        let begin = begin.parse().map_err(|_| ParseError::InvalidInput)?;
        let end = end.parse().map_err(|_| ParseError::InvalidInput)?;

        Ok(IDRange(begin..=end))
    }
}
