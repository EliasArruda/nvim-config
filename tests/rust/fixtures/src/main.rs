fn answer_value() -> i32 {
    42
}

fn main() {
    let answer = answer_value();
    let values = vec![answer, 7];
    let count = values.capacity();
    println!("Rust OK: {}, capacity {}", values[0], count);
}

#[cfg(test)]
mod tests {
    #[test]
    fn answer_value_returns_forty_two() {
        assert_eq!(super::answer_value(), 42);
    }
}
