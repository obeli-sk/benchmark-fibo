use exports::benchmark_fibo::activity::fiboa::Guest;
use wit_bindgen::generate;

generate!({ generate_all });
struct Component;
export!(Component);

fn fibo(n: u8) -> u64 {
    if n <= 1 {
        n.into()
    } else {
        fibo(n - 1) + fibo(n - 2)
    }
}

impl Guest for Component {
    fn fibo(n: u8) -> Result<u64, ()> {
        Ok(fibo(n))
    }
}
