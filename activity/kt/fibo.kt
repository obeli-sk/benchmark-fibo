@file:OptIn(kotlin.wasm.unsafe.UnsafeWasmMemoryApi::class, kotlin.wasm.ExperimentalWasmInterop::class)

import kotlin.wasm.unsafe.Pointer
import kotlin.wasm.unsafe.withScopedMemoryAllocator

fun fibo(n: Int): Long = if (n <= 1) n.toLong() else fibo(n - 1) + fibo(n - 2)

// Canonical ABI export of `benchmark-fibo:activity/fiboa#fibo`, signature
// `fibo: func(n: u8) -> result<u64>`. `result<u64>` flattens to (i32 tag, i64
// value) = 2 core values, exceeding MAX_FLAT_RESULTS (1), so it is returned
// indirectly: the guest writes the 16-byte record {tag@0, u64@8} into linear
// memory and returns the pointer. wasmtime reads it synchronously before any
// other guest code runs, so reusing the scoped bump region after it is freed is
// safe here.
@WasmExport("benchmark-fibo:activity/fiboa#fibo")
fun fiboExport(n: Int): Int = withScopedMemoryAllocator { allocator ->
    val ptr = allocator.allocate(16)
    ptr.storeInt(0) // result tag 0 = ok
    Pointer((ptr.address + 8u)).storeLong(fibo(n))
    ptr.address.toInt()
}
