
from wit_world import exports
from wit_world.imports import benchmark_fibo_activity_fiboa
from wit_world.imports import benchmark_fibo_activity_obelisk_ext_fiboa
from wit_world.imports import workflow_support
from wit_world.types import Result, Ok, Err

class Fibow(exports.Fibow):

    def fiboa(self, n: int, iterations: int) -> int:
        last = 0
        for i in range(iterations):
            last = benchmark_fibo_activity_fiboa.fibo(n)
        return last

    def fiboa_concurrent(self, n: int, iterations: int) -> int:
        join_set = workflow_support.new_join_set_generated(workflow_support.ClosingStrategy.COMPLETE)
        for i in range(iterations):
            benchmark_fibo_activity_obelisk_ext_fiboa.fibo_submit(join_set, n)
        last = 0
        for i in range(iterations):
            exec, last = benchmark_fibo_activity_obelisk_ext_fiboa.fibo_await_next(join_set)
        return unwrap(last)

def unwrap(result: Result[int, None]) -> int:
    if isinstance(result, Ok):
        return result.value
    elif isinstance(result, Err):
        raise result
    else:
        raise TypeError("Invalid Result type")
