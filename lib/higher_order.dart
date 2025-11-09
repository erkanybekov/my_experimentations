// high order functino
// Best practice example of a higher-order function in Dart:

// A higher-order function that takes another function as an argument
void repeat(int times, void Function() action) {
  for (var i = 0; i < times; i++) {
    action();
  }
}

void inner(void Function(String) name) {
  final innerName = "inner func";
  name(innerName);
}

// Cool tips & tricks with higher-order functions!

// 1. Return a function from a function (function factory)
Function makeMultiplier(int factor) {
  return (int x) => x * factor;
}

// Usage: 
// final triple = makeMultiplier(3);
// print(triple(5)); // 15

// 2. Higher-order math: apply a function to a value
T apply<T>(T value, T Function(T) f) => f(value);

// Usage:
// print(apply(9, (n) => n * n)); // 81

// 3. Function composition: compose(f, g) => f(g(x))
T Function(T) compose<T>(T Function(T) f, T Function(T) g) {
  return (T x) => f(g(x));
}

// Usage example:
// final sqThenTriple = compose((n) => n * 3, (n) => n * n);
// print(sqThenTriple(4)); // (4*4)*3 = 48

// 4. Currying example: 
Function adder(int x) => (int y) => x + y;

// Usage:
// final add10 = adder(10);
// print(add10(5)); // 15


// ============================================

void main() {
  inner((name) {
    print(name);
  });
  // Both of these lines will result in the same behavior: printing "Hello!" three times.
  // However, there is a subtle difference in how the function is passed:
  // Usage example:
  void sayHello() {}
  repeat(3, () => sayHello());
  // Here, we are passing an *anonymous function* (a lambda) that calls sayHello().
  // This can be useful if you want to add extra logic, e.g.:
  // () { print('Before'); sayHello(); print('After'); }
  repeat(3, () {
    print('before');
    sayHello();
    print('after');
  });

  repeat(3, sayHello);
  // Here, we are passing the *function itself* as a reference. It's shorter and more idiomatic when no extra logic is needed.

  // In this context, both work the same, but if you want to add extra steps, use the first style.
}
