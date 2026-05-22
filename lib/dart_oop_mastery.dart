/// ============================================
/// DART OOP MASTERY: Best Practices & Tips
/// ============================================
/// 
/// This file demonstrates advanced Dart OOP concepts,
/// best practices, and professional tips & tricks.
/// 
library;

// ============================================
// 1. ENCAPSULATION & PRIVATE MEMBERS
// ============================================

/// Tip: Use underscore prefix for private members (library-level privacy)
/// Dart doesn't have true private members, but library-level privacy is powerful
class BankAccount {
  // Private fields (accessible only within this library)
  double _balance;
  final String _accountNumber;
  
  // Private constructor - forces use of factory/named constructors
  BankAccount._(this._balance, this._accountNumber);
  
  // Factory constructor - best practice for controlled instantiation
  factory BankAccount.create({
    required String accountNumber,
    required String accountHolder,
    double initialBalance = 0.0,
  }) {
    if (initialBalance < 0) {
      throw ArgumentError('Initial balance cannot be negative');
    }
    return BankAccount._(initialBalance, accountNumber);
  }
  
  // Named constructor - another pattern for specific initialization
  BankAccount.fromJson(Map<String, dynamic> json)
      : _balance = (json['balance'] as num).toDouble(),
        _accountNumber = json['accountNumber'] as String;
  
  // Getters - computed properties
  double get balance => _balance;
  String get accountNumber => _accountNumber;
  
  // Read-only access with validation
  String get maskedAccountNumber => 
      '****${_accountNumber.substring(_accountNumber.length - 4)}';
  
  // Methods with validation
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit amount must be positive');
    _balance += amount;
  }
  
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError('Withdrawal amount must be positive');
    if (amount > _balance) throw StateError('Insufficient funds');
    _balance -= amount;
  }
  
  // Tip: Use late initialization for values that must be set before use
  DateTime? _lastTransactionDate;
  
  DateTime? get lastTransactionDate => _lastTransactionDate;
  
  void recordTransaction() {
    _lastTransactionDate = DateTime.now();
  }
  
  // Example of late non-nullable (when you guarantee it's set)
  late DateTime _accountCreatedAt;
  
  void initializeAccountCreated() {
    _accountCreatedAt = DateTime.now();
  }
  
  DateTime get accountCreatedAt => _accountCreatedAt;
  
  // Note: Cannot use const here because _balance is mutable
  // For truly const instances, all fields must be final
  static BankAccount get empty => BankAccount.create(
        accountNumber: '',
        accountHolder: '',
        initialBalance: 0,
      );
}

// ============================================
// 2. INHERITANCE & POLYMORPHISM
// ============================================

/// Abstract class - defines interface but not implementation
/// Best practice: Use abstract classes for shared behavior
abstract class Animal {
  final String name;
  final int age;
  
  // Const constructor in abstract class
  const Animal({required this.name, required this.age});
  
  // Abstract method - must be implemented by subclasses
  String makeSound();
  
  // Concrete method - can be overridden
  String introduce() => 'I am $name, aged $age';
  
  // Tip: Use protected-like pattern with no-underscore (public) but documented
  void move() {
    print('$name is moving');
  }
}

/// Concrete implementation
class Dog extends Animal {
  final String breed;
  
  const Dog({
    required super.name,
    required super.age,
    required this.breed,
  });
  
  @override
  String makeSound() => 'Woof!';
  
  // Override with super call
  @override
  String introduce() => '${super.introduce()}, I am a $breed';
  
  // Additional method specific to Dog
  void fetch() => print('$name is fetching!');
}

class Cat extends Animal {
  const Cat({required super.name, required super.age});
  
  @override
  String makeSound() => 'Meow!';
  
  void purr() => print('$name is purring');
}

// ============================================
// 3. INTERFACES (Implicit in Dart)
// ============================================

/// Dart doesn't have explicit 'interface' keyword
/// Any class can be used as an interface
/// Best practice: Use abstract classes for interfaces

abstract class Flyable {
  void fly();
  double get maxAltitude;
}

abstract class Swimmable {
  void swim();
  double get maxDepth;
}

/// Multiple interface implementation (multiple inheritance of interfaces)
class Duck extends Animal implements Flyable, Swimmable {
  const Duck({required super.name, required super.age});
  
  @override
  String makeSound() => 'Quack!';
  
  @override
  void fly() => print('$name is flying');
  
  @override
  double get maxAltitude => 1000.0;
  
  @override
  void swim() => print('$name is swimming');
  
  @override
  double get maxDepth => 5.0;
}

// ============================================
// 4. MIXINS (Powerful feature for code reuse)
// ============================================

/// Mixins - best for sharing behavior across unrelated classes
/// Tip: Use mixins instead of multiple inheritance when behavior is shared

mixin Timestamped {
  DateTime? _createdAt;
  DateTime? _updatedAt;
  
  DateTime? get createdAt => _createdAt;
  DateTime? get updatedAt => _updatedAt;
  
  void markCreated() {
    _createdAt = DateTime.now();
    _updatedAt = DateTime.now();
  }
  
  void markUpdated() {
    _updatedAt = DateTime.now();
  }
}

mixin Identifiable {
  String? _id;
  
  String? get id => _id;
  
  void setIdentity(String id) {
    _id = id;
  }
}

mixin Validatable {
  bool isValid() => true;
  
  void validate() {
    if (!isValid()) {
      throw StateError('Validation failed');
    }
  }
}

/// Mixin with constraints - only for classes that extend Animal
mixin AnimalBehavior on Animal {
  void sleep() => print('$name is sleeping');
  void eat() => print('$name is eating');
}

/// Using multiple mixins
class Product with Timestamped, Identifiable, Validatable {
  final String name;
  final double price;
  
  Product({required this.name, required this.price}) {
    markCreated();
  }
  
  @override
  bool isValid() => name.isNotEmpty && price > 0;
  
  // Note: Cannot update price because it's final
  // This demonstrates why we need ProductFixed below
}

// Fixed version
class ProductFixed with Timestamped, Identifiable, Validatable {
  final String name;
  double _price;
  
  ProductFixed({required this.name, required double price}) : _price = price {
    markCreated();
  }
  
  double get price => _price;
  
  void updatePrice(double newPrice) {
    _price = newPrice;
    markUpdated();
  }
  
  @override
  bool isValid() => name.isNotEmpty && _price > 0;
}

// ============================================
// 5. GENERICS (Type Safety & Reusability)
// ============================================

/// Generic class - type parameter
/// Best practice: Use descriptive single-letter names (T, E, K, V)
class Repository<T> {
  final Map<String, T> _storage = {};
  
  void save(String id, T item) {
    _storage[id] = item;
  }
  
  T? get(String id) => _storage[id];
  
  List<T> getAll() => _storage.values.toList();
  
  void delete(String id) => _storage.remove(id);
  
  // Generic method with type constraint
  R? transform<R>(String id, R Function(T) transformer) {
    final item = get(id);
    return item != null ? transformer(item) : null;
  }
}

/// Generic with constraints
abstract class Comparable<T> {
  int compareTo(T other);
}

class Box<T extends num> {
  final T value;
  
  const Box(this.value);
  
  // Type constraint allows numeric operations
  Box<double> add(Box<T> other) {
    return Box<double>(value.toDouble() + other.value.toDouble());
  }
}

/// Generic interface implementation
class PriorityQueue<T extends Comparable<T>> {
  final List<T> _items = [];
  
  void enqueue(T item) {
    _items.add(item);
    _items.sort((a, b) => a.compareTo(b));
  }
  
  T? dequeue() => _items.isEmpty ? null : _items.removeAt(0);
}

// ============================================
// 6. FACTORY CONSTRUCTORS & PATTERNS
// ============================================

/// Factory pattern - control object creation
class Logger {
  static Logger? _instance;
  final String name;
  
  // Private constructor
  Logger._(this.name);
  
  // Factory singleton pattern
  factory Logger.instance([String name = 'Default']) {
    _instance ??= Logger._(name);
    return _instance!;
  }
  
  // Factory for different log levels
  factory Logger.file(String filename) => Logger._('File: $filename');
  factory Logger.console() => Logger._('Console');
  
  void log(String message) => print('[$name] $message');
}

/// Factory for creating based on type
abstract class Shape {
  double area();
  factory Shape.fromType(String type, double size) {
    switch (type.toLowerCase()) {
      case 'circle':
        return Circle(size);
      case 'square':
        return Square(size);
      default:
        throw ArgumentError('Unknown shape type: $type');
    }
  }
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
  @override
  double area() => 3.14159 * radius * radius;
}

class Square implements Shape {
  final double side;
  Square(this.side);
  @override
  double area() => side * side;
}

// ============================================
// 7. OPERATOR OVERLOADING
// ============================================

/// Tip: Overload operators for domain-specific types
class Money {
  final double amount;
  final String currency;
  
  const Money(this.amount, [this.currency = 'USD']);
  
  // Arithmetic operators
  Money operator +(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot add different currencies');
    }
    return Money(amount + other.amount, currency);
  }
  
  Money operator -(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot subtract different currencies');
    }
    return Money(amount - other.amount, currency);
  }
  
  Money operator *(double factor) => Money(amount * factor, currency);
  
  // Comparison operators
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          currency == other.currency;
  
  @override
  int get hashCode => Object.hash(amount, currency);
  
  // Relational operators
  bool operator <(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot compare different currencies');
    }
    return amount < other.amount;
  }
  
  bool operator >(Money other) => other < this;
  bool operator <=(Money other) => !(this > other);
  bool operator >=(Money other) => !(this < other);
  
  // Index operator (makes it subscriptable)
  double operator [](int index) {
    if (index == 0) return amount;
    if (index == 1) throw ArgumentError('Currency is not numeric');
    throw RangeError('Index out of range');
  }
  
  @override
  String toString() => '${amount.toStringAsFixed(2)} $currency';
}

// ============================================
// 8. CALLABLE CLASSES
// ============================================

/// Tip: Make classes callable when they represent functions/actions
class Calculator {
  double add(double a, double b) => a + b;
  double subtract(double a, double b) => a - b;
  
  // Call method - makes instance callable like a function
  double call(double a, double b, String operation) {
    switch (operation) {
      case '+':
        return add(a, b);
      case '-':
        return subtract(a, b);
      default:
        throw ArgumentError('Unknown operation: $operation');
    }
  }
}

// Usage: final calc = Calculator(); final result = calc(5, 3, '+');

// ============================================
// 9. ENUMS WITH METHODS & PROPERTIES
// ============================================

/// Enhanced enums (Dart 2.17+) - best practice for state machines
enum OrderStatus {
  pending('Pending', 0),
  processing('Processing', 1),
  shipped('Shipped', 2),
  delivered('Delivered', 3),
  cancelled('Cancelled', -1);
  
  final String displayName;
  final int priority;
  
  const OrderStatus(this.displayName, this.priority);
  
  // Methods in enums
  bool get canCancel => this == pending || this == processing;
  
  OrderStatus? next() {
    switch (this) {
      case OrderStatus.pending:
        return OrderStatus.processing;
      case OrderStatus.processing:
        return OrderStatus.shipped;
      case OrderStatus.shipped:
        return OrderStatus.delivered;
      default:
        return null;
    }
  }
  
  bool isBefore(OrderStatus other) => priority < other.priority;
}

// ============================================
// 10. EXTENSION METHODS
// ============================================

/// Tip: Use extensions to add functionality to existing types
/// Best practice: Don't abuse - use for utility methods

extension StringExtensions on String {
  bool get isEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }
  
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  String get reversed => split('').reversed.join('');
}

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;
  
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
}

extension ListExtensions<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
  
  List<T> get duplicates {
    final seen = <T>{};
    final duplicates = <T>[];
    for (final item in this) {
      if (seen.contains(item)) {
        duplicates.add(item);
      } else {
        seen.add(item);
      }
    }
    return duplicates;
  }
}

// ============================================
// 11. CASCADE NOTATION (Powerful Dart feature)
// ============================================

/// Tip: Use cascade notation for method chaining and configuration
class ConfigBuilder {
  String? _host;
  int? _port;
  bool _secure = false;
  
  ConfigBuilder host(String h) {
    _host = h;
    return this;
  }
  
  ConfigBuilder port(int p) {
    _port = p;
    return this;
  }
  
  ConfigBuilder secure() {
    _secure = true;
    return this;
  }
  
  Map<String, dynamic> build() => {
        'host': _host,
        'port': _port,
        'secure': _secure,
      };
}

// Usage with cascade:
// final config = ConfigBuilder()
//   ..host('example.com')
//   ..port(8080)
//   ..secure()
//   ..build();

// ============================================
// 12. STATIC MEMBERS & METHODS
// ============================================

class MathUtils {
  // Static constant
  static const double pi = 3.14159;
  
  // Static method
  static double circleArea(double radius) => pi * radius * radius;
  
  // Static factory
  static MathUtils get instance => MathUtils._();
  
  // Private constructor for singleton
  MathUtils._();
  
  // Static getter
  static String get version => '1.0.0';
}

// ============================================
// 13. TYPE CHECKS & CASTING
// ============================================

/// Tip: Use pattern matching and type checks properly
void processAnimal(Animal animal) {
  // Type check with is
  if (animal is Dog) {
    animal.fetch(); // Type promotion - animal is now Dog
  } else if (animal is Cat) {
    animal.purr(); // Type promotion - animal is now Cat
  }
  
  // Type casting with as (use when certain of type)
  // final dog = animal as Dog; // Throws if not Dog
  
  // Safe casting pattern
  final dog = animal is Dog ? animal : null;
  dog?.fetch();
  
  // Pattern matching (Dart 3.0+)
  switch (animal) {
    case Dog():
      animal.fetch();
    case Cat():
      animal.purr();
    case Duck():
      animal.fly();
      animal.swim();
    default:
      print('Unknown animal');
  }
}

// ============================================
// 14. LATE INITIALIZATION
// ============================================

/// Tip: Use late for values that must be initialized before use
/// but can't be initialized at declaration
class DatabaseConnection {
  late String _connectionString;
  late final DateTime _connectedAt;
  
  // Late initialization in constructor
  DatabaseConnection() {
    _connectionString = 'default://localhost';
    _connectedAt = DateTime.now();
  }
  
  // Late with initialization function
  late final String _config = _loadConfig();
  
  String _loadConfig() {
    // Expensive operation
    return 'loaded_config';
  }
  
  // Late nullable - can be null
  late String? _optionalConfig;
  
  String get connectionString => _connectionString;
  DateTime get connectedAt => _connectedAt;
  String get config => _config;
  String? get optionalConfig => _optionalConfig;
  
  void setConfig(String config) {
    _connectionString = config;
    _optionalConfig = config;
  }
}

// ============================================
// 15. CONST CONSTRUCTORS & IMMUTABILITY
// ============================================

/// Tip: Use const constructors for compile-time constants
/// All fields must be final
class Point {
  final double x;
  final double y;
  
  const Point(this.x, this.y);
  
  // Const constructor can call other const constructors
  const Point.origin() : this(0, 0);
  
  // Computed properties
  double get distanceFromOrigin => (x * x + y * y);
  
  // Methods that return new instances (immutable pattern)
  Point translate(double dx, double dy) => Point(x + dx, y + dy);
}

// Can create compile-time constants
const point1 = Point(10, 20);
const point2 = Point.origin();

// ============================================
// 16. GETTERS & SETTERS BEST PRACTICES
// ============================================

class Temperature {
  double _celsius = 0;
  
  // Getter
  double get celsius => _celsius;
  
  // Setter with validation
  set celsius(double value) {
    if (value < -273.15) {
      throw ArgumentError('Temperature cannot be below absolute zero');
    }
    _celsius = value;
  }
  
  // Computed getters
  double get fahrenheit => _celsius * 9 / 5 + 32;
  double get kelvin => _celsius + 273.15;
  
  // Setter for computed property
  set fahrenheit(double value) {
    celsius = (value - 32) * 5 / 9;
  }
}

// ============================================
// 17. NAMED PARAMETERS & OPTIONAL PARAMETERS
// ============================================

class User {
  final String name;
  final String email;
  final int? age; // Nullable optional
  final String? phone;
  
  // Named parameters with required/optional
  User({
    required this.name,
    required this.email,
    this.age,
    this.phone,
  });
  
  // Named constructor with default values
  User.guest({
    this.name = 'Guest',
    this.email = 'guest@example.com',
    this.age,
    this.phone,
  });
  
  // Positional optional parameters
  User.anonymous([this.name = 'Anonymous', this.email = '']) 
      : age = null,
        phone = null;
}

// ============================================
// 18. COMPOSITION OVER INHERITANCE
// ============================================

/// Tip: Prefer composition when behavior doesn't fit inheritance
class Engine {
  void start() => print('Engine started');
  void stop() => print('Engine stopped');
}

class Wheels {
  final int count;
  Wheels(this.count);
  void rotate() => print('$count wheels rotating');
}

// Composition - has-a relationship
class Car {
  final Engine _engine;
  final Wheels _wheels;
  final String model;
  
  Car({required this.model})
      : _engine = Engine(),
        _wheels = Wheels(4);
  
  void drive() {
    _engine.start();
    _wheels.rotate();
    print('$model is driving');
  }
  
  void park() {
    _engine.stop();
    print('$model is parked');
  }
}

// ============================================
// USAGE EXAMPLES
// ============================================

void demonstrateOOP() {
  print('=== DART OOP MASTERY DEMONSTRATION ===\n');
  
  // 1. Factory constructors
  final account = BankAccount.create(
    accountNumber: '123456',
    accountHolder: 'John Doe',
    initialBalance: 1000.0,
  );
  print('Account: ${account.maskedAccountNumber}');
  
  // 2. Inheritance & Polymorphism
  final animals = [
    Dog(name: 'Buddy', age: 3, breed: 'Golden Retriever'),
    Cat(name: 'Whiskers', age: 2),
    Duck(name: 'Donald', age: 1),
  ];
  
  for (final animal in animals) {
    print('${animal.introduce()} - ${animal.makeSound()}');
  }
  
  // 3. Mixins
  final product = ProductFixed(name: 'Laptop', price: 999.99);
  product.setIdentity('prod-001');
  print('Product: ${product.name}, ID: ${product.id}');
  
  // 4. Generics
  final repo = Repository<String>();
  repo.save('1', 'Item 1');
  repo.save('2', 'Item 2');
  print('Repository items: ${repo.getAll()}');
  
  // 5. Operator overloading
  final money1 = Money(100.0);
  final money2 = Money(50.0);
  print('Money sum: ${money1 + money2}');
  
  // 6. Enums with methods
  var status = OrderStatus.pending;
  print('Status: ${status.displayName}, can cancel: ${status.canCancel}');
  status = status.next()!;
  print('Next status: ${status.displayName}');
  
  // 7. Extensions
  final email = 'test@example.com';
  print('Is email: ${email.isEmail}');
  print('Capitalized: ${'hello'.capitalize}');
  
  // 8. Cascade notation
  final config = ConfigBuilder()
    ..host('example.com')
    ..port(8080)
    ..secure();
  print('Config: ${config.build()}');
  
  // 9. Static members
  print('Circle area: ${MathUtils.circleArea(5.0)}');
  
  // 10. Type checks
  final dog = Dog(name: 'Max', age: 5, breed: 'Labrador');
  processAnimal(dog);
  
  // 11. Const constructors
  const point = Point(10, 20);
  print('Point: (${point.x}, ${point.y})');
  
  // 12. Composition
  final car = Car(model: 'Tesla Model 3');
  car.drive();
}

