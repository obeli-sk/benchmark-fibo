from wit_world import exports

class Fiboa(exports.Fiboa):

    def fibo(self, n: int) -> int:
        if n <= 1:
            return n
        return self.fibo(n - 1) + self.fibo(n - 2)
