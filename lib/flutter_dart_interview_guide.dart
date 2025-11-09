/// ============================================================================
/// FLUTTER & DART INTERVIEW GUIDE
/// Structured explanations with practical usage examples
/// Based on: https://github.com/p0dyakov/flutter_interview
/// ============================================================================
library;

// ignore_for_file: unused_local_variable, prefer_const_constructors, unused_element

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_experimentations/main.dart';
import 'package:provider/provider.dart';

/// ============================================================================
/// DART FUNDAMENTALS
/// ============================================================================

/// ----------------------------------------------------------------------------
/// 1. FINAL vs CONST
/// ----------------------------------------------------------------------------
/// 
/// FINAL: Runtime constant - value assigned once, known at runtime
/// CONST: Compile-time constant - value must be known at compile time
/// 
/// Usage:
class FinalVsConstExample {
  // ✅ final - can use runtime values
  final DateTime timestamp = DateTime.now();
  String get apiResponse => fetchData(); // Runtime value
  
  // ✅ const - must be compile-time constant
  static const String appName = 'MyApp';
  static const int maxRetries = 3;
  
  // ❌ ERROR: const needs compile-time value
  // const DateTime now = DateTime.now();
  
  String fetchData() => 'data';
}

void finalConstWidgets() {
  // const widget - created once, reused (better performance)
  const Text('Hello'); // Compile-time constant widget
  
  // final widget - created at runtime
  final greeting = Text('Hello ${DateTime.now()}');
  
  // Prefer const for static widgets
  const Column(
    children: [
      Text('Static text'),
      Icon(Icons.star),
    ],
  );
}

/// ----------------------------------------------------------------------------
/// 2. JIT vs AOT
/// ----------------------------------------------------------------------------
/// 
/// JIT (Just-In-Time): 
/// - Used during development (Hot Reload/Restart)
/// - Compiles code on-the-fly
/// - Slower execution, faster development
/// 
/// AOT (Ahead-Of-Time):
/// - Used in production builds
/// - Compiles to native machine code
/// - Faster execution, optimized binary
/// 
/// Hot Reload vs Hot Restart:
/// - Hot Reload: Injects updated source code, preserves state (JIT)
/// - Hot Restart: Restarts app, loses state (JIT)

/// ----------------------------------------------------------------------------
/// 3. HASHCODE & EQUALITY
/// ----------------------------------------------------------------------------
/// 
/// HashCode: Integer representing object's state
/// Rule: If a == b, then a.hashCode == b.hashCode
/// 
/// Usage:
class Person {
  final String name;
  final int age;
  
  Person(this.name, this.age);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person && other.name == name && other.age == age;
  }
  
  @override
  int get hashCode => Object.hash(name, age);
}

void hashCodeExample() {
  final p1 = Person('John', 30);
  final p2 = Person('John', 30);
  
  print(p1 == p2); // true
  print(p1.hashCode == p2.hashCode); // true
  
  // Used in collections
  final Set<Person> people = {p1, p2}; // Only stores one (same hashCode)
  final Map<Person, String> roles = {p1: 'Developer'};
}

/// ----------------------------------------------------------------------------
/// 4. EXTENSION METHODS
/// ----------------------------------------------------------------------------
/// 
/// Add functionality to existing classes without modifying them
/// 
/// Usage:
extension StringExtensions on String {
  String get capitalizeFirst => 
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  
  bool get isEmail => contains('@') && contains('.');
  
  String truncate(int maxLength) => 
      length > maxLength ? '${substring(0, maxLength)}...' : this;
}

extension IntExtensions on int {
  bool get isEven => this % 2 == 0;
  Duration get seconds => Duration(seconds: this);
  String get ordinal {
    if (this % 10 == 1 && this % 100 != 11) return '${this}st';
    if (this % 10 == 2 && this % 100 != 12) return '${this}nd';
    if (this % 10 == 3 && this % 100 != 13) return '${this}rd';
    return '${this}th';
  }
}

void extensionExample() {
  print('hello'.capitalizeFirst); // 'Hello'
  print('test@email.com'.isEmail); // true
  print('Long text here'.truncate(8)); // 'Long tex...'
  
  print(5.isEven); // false
  print(3.ordinal); // '3rd'
  
  // Wait for duration
  Future.delayed(5.seconds, () => print('Done'));
}

/// ----------------------------------------------------------------------------
/// 5. MIXINS
/// ----------------------------------------------------------------------------
/// 
/// Reusable code blocks for multiple classes
/// Can't be instantiated, used with 'with' keyword
/// 
/// Usage:
mixin LoggerMixin {
  void log(String message) => print('[${runtimeType}] $message');
}

mixin ValidationMixin {
  bool validateEmail(String email) => email.contains('@');
  bool validatePassword(String pwd) => pwd.length >= 8;
}

class AuthService with LoggerMixin, ValidationMixin {
  void login(String email, String password) {
    log('Attempting login');
    
    if (!validateEmail(email)) {
      log('Invalid email');
      return;
    }
    
    if (!validatePassword(password)) {
      log('Invalid password');
      return;
    }
    
    log('Login successful');
  }
}

// Mixin with requirements
mixin NetworkMixin on StatefulWidget {
  Future<void> fetchData() async {
    print('Fetching for ${runtimeType}');
  }
}

/// ----------------------------------------------------------------------------
/// 6. NULL SAFETY
/// ----------------------------------------------------------------------------
/// 
/// Sound Null Safety: Compiler guarantees no null reference errors
/// 
/// Usage:
class NullSafetyExample {
  // Non-nullable (must have value)
  String name = 'John';
  
  // Nullable (can be null)
  String? nickname;
  
  // Late: Initialize later (before use)
  late String description;
  
  void example() {
    // ✅ Safe access
    print(name.length);
    
    // ✅ Null-aware operators
    print(nickname?.length); // null if nickname is null
    print(nickname ?? 'No nickname'); // Default value
    print(nickname ??= 'Default'); // Assign if null
    
    // ✅ Null assertion (use carefully!)
    String definiteName = nickname!; // Throws if null
    
    // ✅ Type promotion
    if (nickname != null) {
      print(nickname?.length); // nickname promoted to String
    }
  }
}

/// ----------------------------------------------------------------------------
/// 7. LATE KEYWORD
/// ----------------------------------------------------------------------------
/// 
/// Delays initialization, must be set before first read
/// Use cases: DI, expensive initialization, circular dependencies
/// 
/// Usage:
class LateExample {
  // Initialize later in constructor
  late final String userId;
  
  // Lazy initialization (computed on first access)
  late final String expensiveValue = _computeExpensive();
  
  LateExample(String id) {
    userId = id;
  }
  
  String _computeExpensive() {
    print('Computing...');
    return 'Result';
  }
}

class MyWidget2 extends StatefulWidget {
  const MyWidget2({super.key});
  
  @override
  State<MyWidget2> createState() => _MyWidget2State();
}

class _MyWidget2State extends State<MyWidget2> {
  // Can't initialize in declaration (no context)
  late final String userId;
  
  @override
  void initState() {
    super.initState();
    // Initialize here with context
    userId = getUserId();
  }
  
  String getUserId() => 'user123';
  
  @override
  Widget build(BuildContext context) {
    return Text(userId);
  }
}

/// ----------------------------------------------------------------------------
/// 8. GENERICS
/// ----------------------------------------------------------------------------
/// 
/// Type parameters for reusable code with type safety
/// 
/// Usage:
class Box<T> {
  final T value;
  Box(this.value);
  
  T getValue() => value;
}

class Pair<K, V> {
  final K key;
  final V value;
  Pair(this.key, this.value);
}

// Generic with constraints
class NumberBox<T extends num> {
  final T value;
  NumberBox(this.value);
  
  T add(T other) => (value + other) as T;
}

// Generic functions
T getFirst<T>(List<T> items) => items.first;

E? find<E>(List<E> items, bool Function(E) test) {
  for (var item in items) {
    if (test(item)) return item;
  }
  return null;
}

void genericsExample() {
  final stringBox = Box<String>('Hello');
  final intBox = Box<int>(42);
  
  final pair = Pair<String, int>('age', 30);
  
  final numBox = NumberBox<int>(10);
  print(numBox.add(5)); // 15
  
  final first = getFirst<String>(['a', 'b', 'c']); // 'a'
  
  final found = find<int>([1, 2, 3, 4], (n) => n > 2); // 3
}

/// ----------------------------------------------------------------------------
/// 9. ASYNC PROGRAMMING
/// ----------------------------------------------------------------------------
/// 
/// Future: Single async value
/// Stream: Multiple async values
/// async/await: Syntactic sugar for Futures
/// 
/// Usage:

// FUTURES
Future<String> fetchUser() async {
  await Future.delayed(2.seconds);
  return 'John Doe';
}

Future<void> futureExample() async {
  // Sequential execution
  final user = await fetchUser();
  print(user);
  
  // Parallel execution
  final results = await Future.wait([
    fetchUser(),
    Future.value('Data'),
  ]);
  
  // Error handling
  try {
    await fetchUser();
  } catch (e) {
    print('Error: $e');
  }
  
  // Timeout
  await fetchUser().timeout(5.seconds);
}

// STREAMS
Stream<int> countStream(int max) async* {
  for (int i = 0; i < max; i++) {
    await Future.delayed(1.seconds);
    yield i; // Emit value
  }
}

Stream<String> userStream() {
  return Stream.periodic(Duration(seconds: 1), (count) => 'User $count');
}

void streamExample() async {
  // Listen to stream
  final subscription = countStream(5).listen(
    (value) => print(value),
    onError: (error) => print('Error: $error'),
    onDone: () => print('Done'),
  );
  
  // Cancel subscription
  await Future.delayed(3.seconds);
  subscription.cancel();
  
  // Transform stream
  countStream(5)
      .where((n) => n.isEven)
      .map((n) => n * 2)
      .listen(print);
  
  // async for
  await for (final value in countStream(3)) {
    print(value);
  }
}

// STREAM CONTROLLERS
class CounterBloc {
  final _controller = StreamController<int>();
  int _count = 0;
  
  Stream<int> get stream => _controller.stream;
  
  void increment() {
    _count++;
    _controller.sink.add(_count);
  }
  
  void dispose() {
    _controller.close();
  }
}

/// ----------------------------------------------------------------------------
/// 10. ISOLATES
/// ----------------------------------------------------------------------------
/// 
/// Independent workers with own memory
/// For CPU-intensive tasks without blocking UI
/// 
/// Usage:
Future<int> heavyComputation(int n) async {
  // Simulating heavy work
  int sum = 0;
  for (int i = 0; i < n; i++) {
    sum += i;
  }
  return sum;
}

void isolateExample() async {
  // Run in separate isolate
  final result = await compute(heavyComputation, 1000000);
  print(result);
}

R compute<Q, R>(R Function(Q) callback, Q message) {
  // Simplified - Flutter's compute runs in isolate
  return callback(message);
}

/// ============================================================================
/// FLUTTER FUNDAMENTALS
/// ============================================================================

/// ----------------------------------------------------------------------------
/// 11. WIDGET TREE, ELEMENT TREE, RENDER TREE
/// ----------------------------------------------------------------------------
/// 
/// Widget Tree: Immutable configuration (rebuild on state change)
/// Element Tree: Mutable, manages widget lifecycle, holds state
/// Render Tree: Actual rendering, layout, painting
/// 
/// Flow: Widget → Element → RenderObject
/// 
/// Usage:
class TreeExample extends StatefulWidget {
  const TreeExample({super.key});
  
  @override
  State<TreeExample> createState() => _TreeExampleState();
}

class _TreeExampleState extends State<TreeExample> {
  int _counter = 0;
  
  @override
  Widget build(BuildContext context) {
    // Widget tree rebuilt on setState
    // Element tree reused if widget type matches 
    // RenderObject updated only if needed
    return Column(
      children: [
        Text('Count: $_counter'), // Widget recreated
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}

/// ----------------------------------------------------------------------------
/// 12. STATELESS vs STATEFUL vs INHERITED WIDGET
/// ----------------------------------------------------------------------------
/// 
/// StatelessWidget: Immutable, no internal state
/// StatefulWidget: Has mutable state, can rebuild
/// InheritedWidget: Share data down the tree efficiently
/// 
/// Usage:

// STATELESS - No changing data
class GreetingWidget extends StatelessWidget {
  final String name;
  const GreetingWidget({super.key, required this.name});
  
  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}

// STATEFUL - Has changing data
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});
  
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;
  
  void _increment() {
    setState(() => _count++); // Triggers rebuild
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_count'),
        ElevatedButton(
          onPressed: _increment,
          child: Text('Add'),
        ),
      ],
    );
  }
}

// INHERITED WIDGET - Share data without passing props
class ThemeData2 {
  final Color primaryColor;
  final TextStyle textStyle;
  
  const ThemeData2({
    required this.primaryColor,
    required this.textStyle,
  });
}

class MyTheme extends InheritedWidget {
  final ThemeData2 theme;
  
  const MyTheme({
    super.key,
    required this.theme,
    required super.child,
  });
  
  static ThemeData2? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyTheme>()?.theme;
  }
  
  @override
  bool updateShouldNotify(MyTheme oldWidget) {
    return theme != oldWidget.theme;
  }
}

// Usage
class ThemedButton extends StatelessWidget {
  const ThemedButton({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    return Container(
      color: theme?.primaryColor,
      child: Text('Button', style: theme?.textStyle),
    );
  }
}

/// ----------------------------------------------------------------------------
/// 13. KEYS
/// ----------------------------------------------------------------------------
/// 
/// Preserve widget state when tree changes
/// Types: ValueKey, ObjectKey, UniqueKey, GlobalKey
/// 
/// Usage:
class KeysExample extends StatefulWidget {
  const KeysExample({super.key});
  
  @override
  State<KeysExample> createState() => _KeysExampleState();
}

class _KeysExampleState extends State<KeysExample> {
  List<String> items = ['A', 'B', 'C'];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ❌ Without keys - state can be mixed up
        ...items.map((item) => StatefulTile(label: item)),
        
        // ✅ With keys - state preserved correctly
        ...items.map((item) => StatefulTile(
          key: ValueKey(item),
          label: item,
        )),
      ],
    );
  }
}

class StatefulTile extends StatefulWidget {
  final String label;
  const StatefulTile({super.key, required this.label});
  
  @override
  State<StatefulTile> createState() => _StatefulTileState();
}

class _StatefulTileState extends State<StatefulTile> {
  bool _selected = false;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      selected: _selected,
      onTap: () => setState(() => _selected = !_selected),
    );
  }
}

// GLOBAL KEY - Access widget from anywhere
class GlobalKeyExample extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  GlobalKeyExample({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print('Valid!');
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------------
/// 14. BUILD CONTEXT
/// ----------------------------------------------------------------------------
/// 
/// Handle to widget's location in widget tree
/// Used to access InheritedWidgets, Theme, MediaQuery, Navigator
/// 
/// Usage:
class ContextExample extends StatelessWidget {
  const ContextExample({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Access theme
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    
    // Access media query
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    
    // Navigation
    void navigateToNext() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => NextScreen()),
      );
    }
    
    // Show dialog
    void showAlert() {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Alert'),
          content: Text('Message'),
        ),
      );
    }
    
    // Show snackbar
    void showMessage() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message')),
      );
    }
    
    return Container();
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Next')),
      body: Center(child: Text('Next Screen')),
    );
  }
}

/// ----------------------------------------------------------------------------
/// 15. LIFECYCLE METHODS
/// ----------------------------------------------------------------------------
/// 
/// StatefulWidget lifecycle hooks
/// 
/// Usage:
class LifecycleExample extends StatefulWidget {
  const LifecycleExample({super.key});
  
  @override
  State<LifecycleExample> createState() => _LifecycleExampleState();
}

class _LifecycleExampleState extends State<LifecycleExample> {
  late StreamSubscription _subscription;
  
  // 1. Constructor
  _LifecycleExampleState() {
    print('1. Constructor');
  }
  
  // 2. initState - Called once when widget inserted
  @override
  void initState() {
    super.initState();
    print('2. initState');
    
    // Initialize controllers, subscriptions, listeners
    _subscription = Stream.periodic(Duration(seconds: 1))
        .listen((_) => print('tick'));
  }
  
  // 3. didChangeDependencies - After initState, when InheritedWidget changes
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('3. didChangeDependencies');
    
    // Access InheritedWidgets here
    final theme = Theme.of(context);
  }
  
  // 4. build - Builds widget tree
  @override
  Widget build(BuildContext context) {
    print('4. build');
    return Container();
  }
  
  // 5. didUpdateWidget - When parent rebuilds with new widget
  @override
  void didUpdateWidget(LifecycleExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('5. didUpdateWidget');
  }
  
  // 6. setState - Triggers rebuild
  void updateState() {
    setState(() {
      print('6. setState');
    });
  }
  
  // 7. deactivate - When widget removed from tree (temporarily)
  @override
  void deactivate() {
    print('7. deactivate');
    super.deactivate();
  }
  
  // 8. dispose - Called once when widget removed permanently
  @override
  void dispose() {
    print('8. dispose');
    
    // Clean up: controllers, subscriptions, listeners
    _subscription.cancel();
    
    super.dispose();
  }
}

/// ----------------------------------------------------------------------------
/// 16. setState, setState(() {})
/// ----------------------------------------------------------------------------
/// 
/// Notifies framework that state changed, triggers rebuild
/// Callback updates state synchronously before rebuild
/// 
/// Usage:
class SetStateExample extends StatefulWidget {
  const SetStateExample({super.key});
  
  @override
  State<SetStateExample> createState() => _SetStateExampleState();
}

class _SetStateExampleState extends State<SetStateExample> {
  int _counter = 0;
  bool _loading = false;
  
  void _increment() {
    // ✅ Correct - modify state in callback
    setState(() {
      _counter++;
    });
  }
  
  void _incorrectIncrement() {
    // ❌ Wrong - state changed outside setState
    _counter++;
    setState(() {}); // Build won't reflect change reliably
  }
  
  Future<void> _loadData() async {
    setState(() => _loading = true);
    
    await Future.delayed(Duration(seconds: 2));
    
    // ✅ Check if still mounted
    if (!mounted) return;
    
    setState(() => _loading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $_counter'),
        ElevatedButton(
          onPressed: _increment,
          child: Text('Increment'),
        ),
        if (_loading) CircularProgressIndicator(),
      ],
    );
  }
}

/// ----------------------------------------------------------------------------
/// 17. INHERITED WIDGET vs PROVIDER
/// ----------------------------------------------------------------------------
/// 
/// InheritedWidget: Low-level, manual implementation
/// Provider: High-level, easier state management built on InheritedWidget
/// 
/// Usage example (conceptual - requires provider package):

// With Provider
class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners(); // Rebuilds listening widgets
  }
}

// Provide at root
// ChangeNotifierProvider(
//   create: (_) => Counter(),
//   child: MyApp(),
// )

// Consume anywhere
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>();
    return Text('${counter.count}');
  }
}

class CounterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.read<Counter>();
    return ElevatedButton(
      onPressed: counter.increment,
      child: Text('Add'),
    );
  }
}

/// ----------------------------------------------------------------------------
/// 18. CONSTRAINTS & LAYOUT
/// ----------------------------------------------------------------------------
/// 
/// Layout rule: Constraints go down, sizes go up, parent sets position
/// Tight constraint: min == max
/// Loose constraint: min < max
/// 
/// Usage:
class ConstraintsExample extends StatelessWidget {
  const ConstraintsExample({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container respects constraints
        Container(
          width: 100,
          height: 100,
          color: Colors.blue,
          child: Container(
            width: 200, // Ignored! Parent constrains to 100
            height: 200,
            color: Colors.red,
          ),
        ),
        
        // Expanded uses available space
        Expanded(
          child: Container(color: Colors.green),
        ),
        
        // Flexible allows child to be smaller
        Flexible(
          child: Container(
            height: 50,
            color: Colors.yellow,
          ),
        ),
        
        // ConstrainedBox enforces min/max
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            maxWidth: 300,
            minHeight: 50,
            maxHeight: 200,
          ),
          child: Container(color: Colors.purple),
        ),
        
        // UnconstrainedBox removes constraints
        UnconstrainedBox(
          child: Container(
            width: 1000, // Can exceed parent
            height: 100,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}

/// ----------------------------------------------------------------------------
/// 19. CONST CONSTRUCTOR
/// ----------------------------------------------------------------------------
/// 
/// Creates compile-time constant widgets
/// Better performance, widgets reused instead of recreated
/// 
/// Usage:
class ConstExample extends StatelessWidget {
  const ConstExample({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ const - widget created once at compile time
        const Text('Static text'),
        const Icon(Icons.star),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Padded text'),
        ),
        
        // ❌ Can't use const with runtime values
        Text('Time: ${DateTime.now()}'),
        
        // ✅ const constructor in custom widgets
        const MyStaticWidget(),
      ],
    );
  }
}

class MyStaticWidget extends StatelessWidget {
  const MyStaticWidget({super.key}); // const constructor
  
  @override
  Widget build(BuildContext context) {
    return const Text('I am const');
  }
}

/// ----------------------------------------------------------------------------
/// 20. RENDER OBJECTS
/// ----------------------------------------------------------------------------
/// 
/// Low-level rendering, layout, hit testing
/// Most widgets wrap RenderObjects
/// 
/// Usage:
class CustomRenderWidget extends SingleChildRenderObjectWidget {
  const CustomRenderWidget({super.key, super.child});
  
  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomRenderBox();
  }
}

class CustomRenderBox extends RenderBox {
  @override
  void performLayout() {
    // Calculate size
    size = constraints.biggest;
  }
  
  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final paint = Paint()..color = Colors.blue;
    canvas.drawRect(offset & size, paint);
  }
}

/// ============================================================================
/// STATE MANAGEMENT PATTERNS
/// ============================================================================

/// ----------------------------------------------------------------------------
/// 21. BLoC PATTERN (Business Logic Component)
/// ----------------------------------------------------------------------------
/// 
/// Separates business logic from UI using Streams
/// Events in, States out
/// 
/// Usage:
class CounterEvent {}
class IncrementEvent extends CounterEvent {}
class DecrementEvent extends CounterEvent {}

class CounterState {
  final int count;
  CounterState(this.count);
}

class CounterBloc2 {
  int _count = 0;
  
  final _stateController = StreamController<CounterState>();
  final _eventController = StreamController<CounterEvent>();
  
  Stream<CounterState> get state => _stateController.stream;
  Sink<CounterEvent> get events => _eventController.sink;
  
  CounterBloc2() {
    _eventController.stream.listen(_handleEvent);
  }
  
  void _handleEvent(CounterEvent event) {
    if (event is IncrementEvent) {
      _count++;
    } else if (event is DecrementEvent) {
      _count--;
    }
    
    _stateController.add(CounterState(_count));
  }
  
  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}

// Usage in widget
class BlocExample extends StatefulWidget {
  const BlocExample({super.key});
  
  @override
  State<BlocExample> createState() => _BlocExampleState();
}

class _BlocExampleState extends State<BlocExample> {
  final _bloc = CounterBloc2();
  
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CounterState>(
      stream: _bloc.state,
      initialData: CounterState(0),
      builder: (context, snapshot) {
        final count = snapshot.data!.count;
        
        return Column(
          children: [
            Text('Count: $count'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _bloc.events.add(IncrementEvent()),
                  child: Text('+'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _bloc.events.add(DecrementEvent()),
                  child: Text('-'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// ----------------------------------------------------------------------------
/// 22. VALUENOTIFIER & CHANGENOTIFIER
/// ----------------------------------------------------------------------------
/// 
/// Lightweight observable state
/// ValueNotifier: Single value
/// ChangeNotifier: Multiple properties
/// 
/// Usage:

// VALUENOTIFIER
class ValueNotifierExample extends StatefulWidget {
  const ValueNotifierExample({super.key});
  
  @override
  State<ValueNotifierExample> createState() => _ValueNotifierExampleState();
}

class _ValueNotifierExampleState extends State<ValueNotifierExample> {
  final _counter = ValueNotifier<int>(0);
  
  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Only rebuilds this widget when counter changes
        ValueListenableBuilder<int>(
          valueListenable: _counter,
          builder: (context, count, child) {
            return Text('Count: $count');
          },
        ),
        ElevatedButton(
          onPressed: () => _counter.value++,
          child: Text('Increment'),
        ),
      ],
    );
  }
}

// CHANGENOTIFIER
class UserModel extends ChangeNotifier {
  String _name = '';
  int _age = 0;
  
  String get name => _name;
  int get age => _age;
  
  void updateName(String newName) {
    _name = newName;
    notifyListeners(); // Notifies all listeners
  }
  
  void updateAge(int newAge) {
    _age = newAge;
    notifyListeners();
  }
}

class ChangeNotifierExample extends StatefulWidget {
  const ChangeNotifierExample({super.key});
  
  @override
  State<ChangeNotifierExample> createState() => _ChangeNotifierExampleState();
}

class _ChangeNotifierExampleState extends State<ChangeNotifierExample> {
  final _user = UserModel();
  
  @override
  void initState() {
    super.initState();
    _user.addListener(_onUserChanged);
  }
  
  @override
  void dispose() {
    _user.removeListener(_onUserChanged);
    _user.dispose();
    super.dispose();
  }
  
  void _onUserChanged() {
    setState(() {}); // Rebuild on user change
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Name: ${_user.name}'),
        Text('Age: ${_user.age}'),
        ElevatedButton(
          onPressed: () => _user.updateName('John'),
          child: Text('Set Name'),
        ),
      ],
    );
  }
}

/// ============================================================================
/// NAVIGATION
/// ============================================================================

/// ----------------------------------------------------------------------------
/// 23. NAVIGATION 1.0 vs 2.0
/// ----------------------------------------------------------------------------
/// 
/// 1.0 (Imperative): push/pop methods
/// 2.0 (Declarative): Pages list, deep linking, web URL sync
/// 
/// Usage:

// NAVIGATION 1.0
class Nav1Example {
  Future<void> navigate(BuildContext context) async {
    // Push new screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen()),
    );
    
    // Pop back
    Navigator.pop(context);
    
    // Push with result
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => SelectionScreen()),
    );
    
    // Named routes
    Navigator.pushNamed(context, '/detail');
    Navigator.pushReplacementNamed(context, '/home');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: ElevatedButton(
        onPressed: () => Navigator.pop(context, 'Result'),
        child: Text('Go Back'),
      ),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// NAVIGATION 2.0 (Conceptual)
/*
class MyRouterDelegate extends RouterDelegate<MyRoutePath> {
  List<Page> _pages = [HomePage()];
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: _pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        _pages.removeLast();
        notifyListeners();
        return true;
      },
    );
  }
  
  void showDetail() {
    _pages.add(DetailPage());
    notifyListeners();
  }
}
*/

/// ============================================================================
/// PERFORMANCE OPTIMIZATION
/// ============================================================================

/// ----------------------------------------------------------------------------
/// 24. PERFORMANCE BEST PRACTICES
/// ----------------------------------------------------------------------------
/// 
/// 1. Use const constructors
/// 2. Avoid rebuilding large widget trees
/// 3. Use ListView.builder for long lists
/// 4. Split widgets to limit rebuild scope
/// 5. Use keys for stateful widgets in lists
/// 
/// Usage:

// ❌ BAD - Rebuilds entire list on every change
class BadListExample extends StatefulWidget {
  const BadListExample({super.key});
  
  @override
  State<BadListExample> createState() => _BadListExampleState();
}

class _BadListExampleState extends State<BadListExample> {
  int _counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: Text('Increment'),
        ),
        // Entire list rebuilds!
        ...List.generate(1000, (i) => ListTile(title: Text('Item $i'))),
      ],
    );
  }
}

// ✅ GOOD - Separates concerns, limits rebuilds
class GoodListExample extends StatefulWidget {
  const GoodListExample({super.key});
  
  @override
  State<GoodListExample> createState() => _GoodListExampleState();
}

class _GoodListExampleState extends State<GoodListExample> {
  int _counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Only this rebuilds
        Text('Counter: $_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: Text('Increment'),
        ),
        // List doesn't rebuild
        Expanded(child: MyList()),
      ],
    );
  }
}

class MyList extends StatelessWidget {
  const MyList({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Lazy loading - builds items on demand
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (context, index) {
        return ListTile(title: Text('Item $index'));
      },
    );
  }
}

// RepaintBoundary - Isolates repaints
class RepaintExample extends StatelessWidget {
  const RepaintExample({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animating widget
        RepaintBoundary(
          child: CircularProgressIndicator(),
        ),
        // Rest of UI doesn't repaint
        Text('Static content'),
      ],
    );
  }
}

/// ============================================================================
/// TESTING
/// ============================================================================

/// ----------------------------------------------------------------------------
/// 25. UNIT, WIDGET, INTEGRATION TESTS
/// ----------------------------------------------------------------------------
/// 
/// Unit: Test single function/class
/// Widget: Test widget rendering and interaction
/// Integration: Test complete app flow
/// 
/// Usage (conceptual - requires test package):
/*
// UNIT TEST
void main() {
  test('Counter increments', () {
    final counter = Counter();
    counter.increment();
    expect(counter.value, 1);
  });
}

// WIDGET TEST
void main() {
  testWidgets('Counter displays value', (tester) async {
    await tester.pumpWidget(MaterialApp(home: CounterWidget()));
    
    expect(find.text('0'), findsOneWidget);
    
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    
    expect(find.text('1'), findsOneWidget);
  });
}

// INTEGRATION TEST
void main() {
  testWidgets('Full user flow', (tester) async {
    await tester.pumpWidget(MyApp());
    
    // Login
    await tester.enterText(find.byType(TextField).first, 'user@test.com');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    
    // Navigate
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    
    expect(find.text('Settings'), findsOneWidget);
  });
}
*/

/// ============================================================================
/// DESIGN PATTERNS (FLUTTER SPECIFIC)
/// ============================================================================

/// ----------------------------------------------------------------------------
/// 26. REPOSITORY PATTERN
/// ----------------------------------------------------------------------------
/// 
/// Abstracts data source (API, DB, cache)
/// Single source of truth for data
/// 
/// Usage:
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<void> saveUser(User user);
}

class User {
  final String id;
  final String name;
  User({required this.id, required this.name});
}

class UserRepositoryImpl implements UserRepository {
  final ApiService _api;
  final DatabaseService _db;
  
  UserRepositoryImpl(this._api, this._db);
  
  @override
  Future<User> getUser(String id) async {
    try {
      // Try cache first
      final cached = await _db.getUser(id);
      if (cached != null) return cached;
      
      // Fetch from API
      final user = await _api.fetchUser(id);
      
      // Cache result
      await _db.saveUser(user);
      
      return user;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }
  
  @override
  Future<void> saveUser(User user) async {
    await _api.updateUser(user);
    await _db.saveUser(user);
  }
}

class ApiService {
  Future<User> fetchUser(String id) async {
    // HTTP call
    return User(id: id, name: 'John');
  }
  
  Future<void> updateUser(User user) async {
    // HTTP call
  }
}

class DatabaseService {
  Future<User?> getUser(String id) async {
    // DB query
    return null;
  }
  
  Future<void> saveUser(User user) async {
    // DB insert
  }
}

/// ----------------------------------------------------------------------------
/// 27. FACTORY PATTERN
/// ----------------------------------------------------------------------------
/// 
/// Creates objects without specifying exact class
/// 
/// Usage:
abstract class Animal {
  void makeSound();
  
  factory Animal(String type) {
    switch (type) {
      case 'dog':
        return Dog();
      case 'cat':
        return Cat();
      default:
        throw ArgumentError('Unknown type: $type');
    }
  }
}

class Dog implements Animal {
  @override
  void makeSound() => print('Woof!');
}

class Cat implements Animal {
  @override
  void makeSound() => print('Meow!');
}

void factoryExample() {
  final dog = Animal('dog');
  dog.makeSound(); // Woof!
  
  final cat = Animal('cat');
  cat.makeSound(); // Meow!
}

/// ----------------------------------------------------------------------------
/// 28. SINGLETON PATTERN
/// ----------------------------------------------------------------------------
/// 
/// Single instance throughout app
/// Use for: API clients, database, preferences
/// 
/// Usage:
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() {
    return _instance;
  }
  
  ApiClient._internal() {
    // Initialize
  }
  
  Future<String> get(String url) async {
    return 'Response';
  }
}

void singletonExample() {
  final client1 = ApiClient();
  final client2 = ApiClient();
  
  print(identical(client1, client2)); // true - same instance
}

/// ----------------------------------------------------------------------------
/// 29. BUILDER PATTERN
/// ----------------------------------------------------------------------------
/// 
/// Construct complex objects step by step
/// 
/// Usage:
class HttpRequest {
  final String url;
  final String method;
  final Map<String, String>? headers;
  final dynamic body;
  final Duration? timeout;
  
  HttpRequest._({
    required this.url,
    required this.method,
    this.headers,
    this.body,
    this.timeout,
  });
}

class HttpRequestBuilder {
  String? _url;
  String _method = 'GET';
  Map<String, String>? _headers;
  dynamic _body;
  Duration? _timeout;
  
  HttpRequestBuilder url(String url) {
    _url = url;
    return this;
  }
  
  HttpRequestBuilder method(String method) {
    _method = method;
    return this;
  }
  
  HttpRequestBuilder headers(Map<String, String> headers) {
    _headers = headers;
    return this;
  }
  
  HttpRequestBuilder body(dynamic body) {
    _body = body;
    return this;
  }
  
  HttpRequestBuilder timeout(Duration timeout) {
    _timeout = timeout;
    return this;
  }
  
  HttpRequest build() {
    if (_url == null) throw StateError('URL is required');
    
    return HttpRequest._(
      url: _url!,
      method: _method,
      headers: _headers,
      body: _body,
      timeout: _timeout,
    );
  }
}

void builderExample() {
  final request = HttpRequestBuilder()
      .url('https://api.example.com/users')
      .method('POST')
      .headers({'Content-Type': 'application/json'})
      .body({'name': 'John'})
      .timeout(Duration(seconds: 30))
      .build();
}

/// ----------------------------------------------------------------------------
/// 30. OBSERVER PATTERN
/// ----------------------------------------------------------------------------
/// 
/// Subscribe to object state changes
/// Used by: Streams, ChangeNotifier, ValueNotifier
/// 
/// Usage:
class NewsPublisher {
  final List<NewsSubscriber> _subscribers = [];
  
  void subscribe(NewsSubscriber subscriber) {
    _subscribers.add(subscriber);
  }
  
  void unsubscribe(NewsSubscriber subscriber) {
    _subscribers.remove(subscriber);
  }
  
  void publishNews(String news) {
    for (var subscriber in _subscribers) {
      subscriber.update(news);
    }
  }
}

abstract class NewsSubscriber {
  void update(String news);
}

class EmailSubscriber implements NewsSubscriber {
  final String email;
  EmailSubscriber(this.email);
  
  @override
  void update(String news) {
    print('Sending email to $email: $news');
  }
}

class PushSubscriber implements NewsSubscriber {
  final String deviceId;
  PushSubscriber(this.deviceId);
  
  @override
  void update(String news) {
    print('Sending push to $deviceId: $news');
  }
}

void observerExample() {
  final publisher = NewsPublisher();
  
  final emailSub = EmailSubscriber('user@example.com');
  final pushSub = PushSubscriber('device123');
  
  publisher.subscribe(emailSub);
  publisher.subscribe(pushSub);
  
  publisher.publishNews('Breaking news!');
  // Sends to both subscribers
}

/// ============================================================================
/// ADVANCED TOPICS
/// ============================================================================

/// ----------------------------------------------------------------------------
/// 31. PLATFORM CHANNELS
/// ----------------------------------------------------------------------------
/// 
/// Communication between Dart and native code (Android/iOS)
/// MethodChannel: Method invocations
/// EventChannel: Event streams
/// 
/// Usage (conceptual):
/*
class BatteryService {
  static const platform = MethodChannel('com.example/battery');
  
  Future<int> getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      return result;
    } catch (e) {
      print('Failed to get battery level: $e');
      return -1;
    }
  }
}

// Native Android code (Kotlin)
/*
class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example/battery"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getBatteryLevel") {
                    val batteryLevel = getBatteryLevel()
                    result.success(batteryLevel)
                } else {
                    result.notImplemented()
                }
            }
    }
}
*/

// EventChannel for streams
class SensorService {
  static const eventChannel = EventChannel('com.example/sensors');
  
  Stream<dynamic> get accelerometer {
    return eventChannel.receiveBroadcastStream();
  }
}
*/

/// ----------------------------------------------------------------------------
/// 32. CUSTOM PAINTING
/// ----------------------------------------------------------------------------
/// 
/// Draw custom graphics using Canvas
/// 
/// Usage:
class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 4;
    
    canvas.drawCircle(center, radius, paint);
    
    // Draw line
    final linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4;
    
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      linePaint,
    );
  }
  
  @override
  bool shouldRepaint(CirclePainter oldDelegate) => false;
}

class CustomPaintExample extends StatelessWidget {
  const CustomPaintExample({super.key});
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200),
      painter: CirclePainter(),
    );
  }
}

/// ----------------------------------------------------------------------------
/// 33. ANIMATIONS
/// ----------------------------------------------------------------------------
/// 
/// Implicit: High-level, automatic (AnimatedContainer)
/// Explicit: Low-level, manual control (AnimationController)
/// 
/// Usage:

// IMPLICIT ANIMATION
class ImplicitAnimationExample extends StatefulWidget {
  const ImplicitAnimationExample({super.key});
  
  @override
  State<ImplicitAnimationExample> createState() => 
      _ImplicitAnimationExampleState();
}

class _ImplicitAnimationExampleState extends State<ImplicitAnimationExample> {
  bool _expanded = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: _expanded ? 200 : 100,
          height: _expanded ? 200 : 100,
          color: _expanded ? Colors.blue : Colors.red,
          curve: Curves.easeInOut,
        ),
        ElevatedButton(
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Text('Toggle'),
        ),
      ],
    );
  }
}

// EXPLICIT ANIMATION
class ExplicitAnimationExample extends StatefulWidget {
  const ExplicitAnimationExample({super.key});
  
  @override
  State<ExplicitAnimationExample> createState() => 
      _ExplicitAnimationExampleState();
}

class _ExplicitAnimationExampleState extends State<ExplicitAnimationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: 2.seconds,
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _animation.value,
          height: _animation.value,
          color: Colors.blue,
        );
      },
    );
  }
}

/// ----------------------------------------------------------------------------
/// 34. SLIVERS
/// ----------------------------------------------------------------------------
/// 
/// Scrollable areas with custom scroll effects
/// Use CustomScrollView with Sliver widgets
/// 
/// Usage:
class SliverExample extends StatelessWidget {
  const SliverExample({super.key});
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Collapsing app bar
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Sliver Example'),
            background: Image.network(
              'https://via.placeholder.com/400',
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Grid
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              color: Colors.primaries[index % Colors.primaries.length],
              child: Center(child: Text('$index')),
            ),
            childCount: 20,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
        ),
        
        // List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(
              title: Text('Item $index'),
            ),
            childCount: 50,
          ),
        ),
      ],
    );
  }
}

/// ============================================================================
/// END OF GUIDE
/// ============================================================================

/// Key Takeaways:
/// 
/// DART:
/// - Use const for compile-time constants, final for runtime
/// - Extensions add functionality to existing types
/// - Mixins enable code reuse across unrelated classes
/// - Null safety prevents null reference errors
/// - Generics provide type-safe reusable code
/// - Isolates handle CPU-intensive tasks
/// 
/// FLUTTER:
/// - Widget tree is immutable, Element tree manages lifecycle
/// - StatelessWidget for static, StatefulWidget for dynamic
/// - Keys preserve state when tree changes
/// - BuildContext accesses inherited data and services
/// - setState triggers rebuilds, scope matters
/// - const constructors improve performance
/// - Streams for reactive data flow
/// - BLoC/Provider for state management
/// - Repository pattern abstracts data sources
/// - Platform channels communicate with native code
/// - Slivers create advanced scroll effects
/// 
/// Best Practices:
/// - Prefer const constructors
/// - Split widgets to limit rebuild scope
/// - Use ListView.builder for long lists
/// - Dispose controllers and subscriptions
/// - Handle async errors gracefully
/// - Check mounted before setState after async
/// - Use keys for stateful widgets in lists
/// - Separate business logic from UI
/// - Test at all levels (unit, widget, integration)
