package main

import (
	fiboabindings "github.com/obeli-sk/benchmark-fibo/fiboa-go/gen/benchmark-fibo/activity/fiboa"
	"go.bytecodealliance.org/cm"
)

func fibo(n uint8) uint64 {
	if n <= 1 {
		return uint64(n)
	}
	return fibo(n-1) + fibo(n-2)
}

func fibo_export(n uint8) (result cm.Result[uint64, uint64, struct{}]) {
	res := fibo(n)
	return cm.OK[cm.Result[uint64, uint64, struct{}]](res)
}

func init() {
	// benchmark-fibo:activity/fiboa.fibo
	fiboabindings.Exports.Fibo = fibo_export
}

func main() {
	panic("wasi:cli/run@0.2.0.run is exported only because of current TinyGo limitation")
}
