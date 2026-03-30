export default function fiboa_concurrent(n, iterations) {
    const js = obelisk.createJoinSet();
    for (let i = 0; i < iterations; i++) {
        js.submit('benchmark-fibo:activity/fiboa.fibo', [n]);
    }
    let last = 0;
    for (let i = 0; i < iterations; i++) {
        const response = js.joinNext();
        if (!response.ok) throw 'activity failed';
        last = obelisk.getResult(response.id).ok;
    }
    return last;
}
