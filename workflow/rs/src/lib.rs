use benchmark_fibo::{
    activity::fiboa::fibo as fibo_activity,
    activity_obelisk_ext::fiboa::{fibo_await_next, fibo_submit},
};
use exports::benchmark_fibo::workflow::fibow::Guest;
use obelisk::workflow::workflow_support::join_set_create;
use wit_bindgen::generate;

generate!({ generate_all });
struct Component;
export!(Component);

impl Guest for Component {
    fn fiboa(n: u8, iterations: u32) -> Result<u64, ()> {
        let mut last = 0;
        for _ in 0..iterations {
            last = fibo_activity(n).unwrap();
        }
        Ok(last)
    }

    fn fiboa_concurrent(n: u8, iterations: u32) -> Result<u64, ()> {
        let join_set = join_set_create();
        for _ in 0..iterations {
            fibo_submit(&join_set, n);
        }
        let mut last = 0;
        for _ in 0..iterations {
            last = fibo_await_next(&join_set).unwrap().1.unwrap();
        }
        Ok(last)
    }
}
