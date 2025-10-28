fn fibo(n: u8) -> u64 {
    if n <= 1 {
        n.into()
    } else {
        fibo(n - 1) + fibo(n - 2)
    }
}

fn main() {
    let n = std::env::var("N").unwrap().parse().unwrap();
    let o = fibo(n);
    print!("{o}");
}
