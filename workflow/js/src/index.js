import { fibo } from 'benchmark-fibo:activity/fiboa';
import { fiboSubmit, fiboAwaitNext } from 'benchmark-fibo:activity-obelisk-ext/fiboa';
import { newJoinSetGenerated } from 'obelisk:workflow/workflow-support@3.0.0';

const ClosingStrategy = {
    Complete: "complete",
};

function unwrap(obj) {
    if (obj.tag === 'ok') {
        return obj.val;
    } else {
        throw info.val;
    }
}

export const fibow = {
    fiboa(n, iterations) {
        let last = 0;
        for (let i = 0; i < iterations; i++) {
            last = fibo(n);
        }
        return last;
    },
    fiboaConcurrent(n, iterations) {
        const joinSet = newJoinSetGenerated(ClosingStrategy.Complete);
        for (let i = 0; i < iterations; i++) {
            fiboSubmit(joinSet, n);
        }
        let last = 0;
        for (let i = 0; i < iterations; i++) {
            let [_execId, res] = fiboAwaitNext(joinSet);
            last = unwrap(res);
        }
        return last;
    }
}
