import { fibo } from 'benchmark-fibo:activity/fiboa';
import { fiboSubmit, fiboAwaitNext } from 'benchmark-fibo:activity-obelisk-ext/fiboa';
import { joinSetCreate as joinSetCreateWit } from 'obelisk:workflow/workflow-support@6.0.0';

function unwrapWitResult(obj) {
    if (obj.tag === 'ok') {
        return obj.val;
    } else {
        throw obj.val;
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
        const joinSet = joinSetCreateWit(undefined);
        for (let i = 0; i < iterations; i++) {
            fiboSubmit(joinSet, n);
        }
        let last = 0;
        for (let i = 0; i < iterations; i++) {
            last = unwrapWitResult(fiboAwaitNext(joinSet));
        }
        return last;
    }
}
