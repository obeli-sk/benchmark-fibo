package main

import (
	fiboaConcurrentbindings "github.com/obeli-sk/benchmark-fibo/fibow-go/gen/benchmark-fibo/activity-obelisk-ext/fiboa"
	fiboabindings "github.com/obeli-sk/benchmark-fibo/fibow-go/gen/benchmark-fibo/activity/fiboa"
	fibowbindings "github.com/obeli-sk/benchmark-fibo/fibow-go/gen/benchmark-fibo/workflow/fibow"
	obeliskWorkflowSupport "github.com/obeli-sk/benchmark-fibo/fibow-go/gen/obelisk/workflow/workflow-support"

	"go.bytecodealliance.org/cm"
)

func fiboa(n uint8, iterations uint32) (result cm.Result[uint64, uint64, struct{}]) {
	last := cm.OK[cm.Result[uint64, uint64, struct{}]](0)
	for i := 0; i < int(iterations); i++ {
		last = fiboabindings.Fibo(n)
	}
	return last
}

func fiboaConcurrent(n uint8, iterations uint32) (result cm.Result[uint64, uint64, struct{}]) {
	joinSet := obeliskWorkflowSupport.NewJoinSetGenerated(obeliskWorkflowSupport.ClosingStrategyComplete)
	for i := 0; i < int(iterations); i++ {
		fiboaConcurrentbindings.FiboSubmit(joinSet, n)
	}
	last := cm.OK[cm.Result[uint64, uint64, struct{}]](0)
	for i := 0; i < int(iterations); i++ {
		res := fiboaConcurrentbindings.FiboAwaitNext(joinSet)
		if res.IsErr() {
			panic("activity timed out")
		}
		res2 := res.OK()
		last = res2.F1

	}
	return last
}

func init() {
	fibowbindings.Exports.Fiboa = fiboa
	fibowbindings.Exports.FiboaConcurrent = fiboaConcurrent
}

func main() {
	panic("wasi:cli/run@0.2.0.run is exported only because of current TinyGo limitation")
}
