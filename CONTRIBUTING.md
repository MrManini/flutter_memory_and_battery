# Contributing to Flutter Memory and Battery Optimization Template

Thank you for your interest in contributing! This guide will help you get started.

## 📋 Table of Contents
- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Adding New Examples](#adding-new-examples)
- [Style Guidelines](#style-guidelines)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

Please be respectful and constructive in all interactions. We're here to learn and improve together.

## How to Contribute

You can contribute in several ways:

1. **Add new optimization examples**
2. **Improve existing examples**
3. **Enhance documentation**
4. **Fix bugs**
5. **Add performance benchmarks**
6. **Improve test coverage**

## Development Setup

### Prerequisites
- Flutter SDK ^3.9.2
- Dart SDK (comes with Flutter)
- Your favorite IDE (VS Code, Android Studio, IntelliJ)

### Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/flutter_memory_and_battery.git
   cd flutter_memory_and_battery
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

5. Run tests:
   ```bash
   flutter test
   ```

## Project Structure

The project follows clean architecture principles:

```
lib/
├── core/
│   ├── constants/     # App-wide constants
│   └── utils/        # Utility functions
├── domain/           # Business logic layer
│   ├── entities/     # Core business objects
│   ├── repositories/ # Repository contracts
│   └── usecases/    # Business use cases
├── data/            # Data layer
│   ├── datasources/  # Data sources
│   ├── models/       # Data models
│   └── repositories/ # Repository implementations
└── presentation/    # UI layer
    ├── pages/        # Screen widgets
    ├── widgets/      # Reusable UI components
    └── providers/    # State management
```

## Adding New Examples

To add a new optimization example:

### 1. Add to Constants

Edit `lib/core/constants/app_constants.dart`:

```dart
static const String yourExampleId = 'your_example';
```

### 2. Add to Data Source

Edit `lib/data/datasources/optimization_local_datasource.dart`:

```dart
const OptimizationExampleModel(
  id: AppConstants.yourExampleId,
  title: 'Your Example Title',
  description: 'Brief description of what this demonstrates',
  type: OptimizationType.memory, // or .battery or .both
),
```

### 3. Create Example Page

Create `lib/presentation/pages/examples/your_example.dart`:

```dart
import 'package:flutter/material.dart';
import '../../widgets/comparison_view.dart';

/// Example demonstrating [your technique]
/// 
/// KEY OPTIMIZATION:
/// Explain what the optimization does and why it matters
class YourExample extends StatelessWidget {
  const YourExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Your Example Title',
      optimizedWidget: const _OptimizedVersion(),
      nonOptimizedWidget: const _NonOptimizedVersion(),
    );
  }
}

/// OPTIMIZED: Explain what makes this optimized
class _OptimizedVersion extends StatelessWidget {
  const _OptimizedVersion();

  @override
  Widget build(BuildContext context) {
    // Your optimized implementation
    return Container();
  }
}

/// NON-OPTIMIZED: Explain what makes this inefficient
class _NonOptimizedVersion extends StatelessWidget {
  const _NonOptimizedVersion();

  @override
  Widget build(BuildContext context) {
    // Your non-optimized implementation
    return Container();
  }
}
```

### 4. Add Navigation

Edit `lib/presentation/pages/home_page.dart`:

```dart
// Import your example
import 'examples/your_example.dart';

// Add to the switch statement in _navigateToExample:
case AppConstants.yourExampleId:
  page = const YourExample();
  break;
```

### 5. Document the Technique

Add detailed documentation to `TECHNIQUES.md`:

```markdown
### N. Your Technique Name

**What it is:** Brief explanation

**How it works:**
- Point 1
- Point 2

**Implementation:**
```dart
// Code example
```

**Impact:**
- Measurable improvements
- When to use
```

### 6. Add Tests

Create tests in `test/examples/your_example_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_memory_and_battery/presentation/pages/examples/your_example.dart';

void main() {
  testWidgets('Your example loads correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: YourExample()),
    );
    
    // Add your test assertions
  });
}
```

## Style Guidelines

### Dart Code Style

1. **Follow Dart style guide**: Use `dart format` before committing
2. **Use meaningful names**: Variables and functions should be self-documenting
3. **Add comments**: Explain WHY, not WHAT
4. **Use const constructors**: Wherever possible
5. **Dispose resources**: Always clean up in dispose()

### Documentation Style

1. **Be clear and concise**: Avoid jargon where possible
2. **Use examples**: Show, don't just tell
3. **Include metrics**: Quantify the impact when possible
4. **Explain trade-offs**: Every optimization has costs

### Example Structure

Each example should:
- Have clear visual distinction between optimized/non-optimized
- Include explanatory cards in the UI
- Show measurable differences (counts, metrics)
- Be interactive when possible
- Include comprehensive inline documentation

## Submitting Changes

### Before Submitting

1. **Test your changes**:
   ```bash
   flutter test
   ```

2. **Format your code**:
   ```bash
   dart format .
   ```

3. **Analyze for issues**:
   ```bash
   flutter analyze
   ```

4. **Ensure tests pass**:
   All existing tests should continue to pass

### Pull Request Process

1. **Create a new branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**:
   - Write clean, documented code
   - Add tests for new functionality
   - Update documentation

3. **Commit with clear messages**:
   ```bash
   git commit -m "Add [feature]: Brief description"
   ```

4. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Create Pull Request**:
   - Provide a clear description of changes
   - Reference any related issues
   - Include screenshots for UI changes
   - List testing performed

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New optimization example
- [ ] Bug fix
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Test addition

## Testing
Describe testing performed

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests pass
- [ ] Code formatted with dart format
```

## Questions?

Feel free to:
- Open an issue for discussion
- Ask questions in pull requests
- Reach out to maintainers

Thank you for contributing! 🎉
