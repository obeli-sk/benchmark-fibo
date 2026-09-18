import { fiboSubmit, fiboAwaitNext } from 'benchmark-fibo:activity-obelisk-ext/fiboa';
import * as obelisk from 'obelisk:workflow@1.0.0';

export default function fiboa_concurrent(n, iterations) {
    const js = obelisk.createJoinSet();
    for (let i = 0; i < iterations; i++) {
        fiboSubmit(js, n);
    }
    let last = 0;
    for (let i = 0; i < iterations; i++) {
        last = fiboAwaitNext(js);
    }
    return last;
}
