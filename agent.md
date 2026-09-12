---
description: "QML Development Rules"
globs: ".qml"
---
1. Maintain consistent object structure
   - Order attributes: id → properties → signals → JS functions → object properties → children
   - Add blank lines between each group for readability
2. Use grouped properties for related settings
   - Group properties from the same category
   - Example: Text { font { bold: true; pixelSize: 20 } }
3. Apply QtQuick.Layouts correctly
   - Size the layout against its non-layout parent
   - Set child sizes using Layout.* attached properties
   - Never anchor items that are direct children of layouts
   - Avoid layouts/anchors in delegates when simple x/y/width/height bindings suffice
4. Prefer strong types over var
   - Declare concrete property types for all properties
5. Use interaction signals over value-changed signals
   - Example: for Slider, use `moved` instead of `valueChanged`
   - Prevent unintended signal cascades
6. Prefer declarative bindings over imperative assignments
   - Bind values directly rather than setting them in handlers
   - Keep code reactive and maintainable
7. Make user-facing strings translatable
   - Wrap all display text in qsTr()
8. Avoid unqualified access
   - Reference parent objects explicitly by id
   - Prevent ambiguity and naming conflicts
9. Use required properties for external data
   - Mark properties that must be provided from outside as 'required'
10. Name signal handler parameters explicitly
    - Example: MouseArea { onClicked: ev => console.log(ev.x, ev.y) }
11. Keep JavaScript code tidy
    - One property per line
    - Use blocks for multi-line expressions
    - Factor longer logic into functions or separate .js files
    - Add type annotations where possible
    - Use semicolons inside code blocks
12. Notify when UI and business logic should be separated
    - Leave comments suggesting migration of heavy logic to C++
    - Flag large or frequently changing data for C++ exposure
13. Expose C++ to QML without tight coupling
    - Use required properties for data injection
    - Use QQmlApplicationEngine::setInitialProperties for initialization
    - Use singletons for shared services
    - Keep C++ code QML-agnostic
    - Group related data into one singleton, instead of creating one QML singleton for each piece of data
14. Never store state in delegates
    - Store all state in the model or external objects

---
description: "CPP Development Rules"
globs: ".cpp", ".h", ".hpp", ".cc"
---
1. Use modern C++ features appropriate to project standard
   - Detect C++ standard from CMake or qmake files
   - If standard cannot be detected, assume C++20
2. Prefer Qt 6 solutions over std counterparts especially in UI/Qt-facing classes. But consider also available std solutions.
3. Avoid using Qt 5 compatibility modules, prefer Qt 6 available classes.
4. For exposing data models inherit proper subclass of QAbstractItemModel, add missing implementation.
5. Use RAII for resource management where possible
   - Let objects manage resources automatically
   - Avoid manual lock/unlock, open/close, or similar patterns
6. Avoid exceptions with Qt classes
   - Prefer error codes and error messages when available
7. Avoid new/delete for dynamic allocation of non-QObjects
   - Prefer smart pointers
   - Prefer stack allocation for value types
8. Pass pointer to parent when allocating QObjects dynamically
9. Prefer return values over out parameters
10. Prefer enum class over plain enums
   - Prefer enums over macros
11. Always initialize objects
   - Avoid use-before-set bugs
   - Prefer {} initialization syntax
12. Make objects immutable by default
13. Prefer Qt containers in Qt-based projects. If a Qt container is not suitable, use C++ standard library containers instead of raw C arrays
14. Follow project naming conventions
    - Check existing project files first
    - Use clang-format configuration if present
    - Default to Google C++ Style Guide naming if no other convention found
