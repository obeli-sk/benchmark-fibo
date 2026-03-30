export default function fiboa(n, iterations) {
    let last = 0;
    for (let i = 0; i < iterations; i++) {
        last = obelisk.call('benchmark-fibo:activity/fiboa.fibo', [n]);
    }
    return last;
}
