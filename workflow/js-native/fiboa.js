import { fibo } from 'benchmark-fibo:activity/fiboa';

export default function fiboa(n, iterations) {
    let last = 0;
    for (let i = 0; i < iterations; i++) {
        last = fibo(n);
    }
    return last;
}
