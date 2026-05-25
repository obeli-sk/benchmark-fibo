import { fiboSubmit, fiboAwaitNext } from 'benchmark-fibo:activity-obelisk-ext/fiboa';

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
