## Overview

This project presents an extension to the Swift `#cloaked` macro, which is designed to improve the security of open text strings in Swift applications. By converting strings to `Data` format using the `UInt8` field, it makes it much harder to easily extract strings from a decompressed application. This method is particularly useful for protecting sensitive data and strings in Swift projects from reverse engineering efforts.

## Features

- **String masking:** Automatically converts plain text strings to `Data([UInt8])` format, hiding their actual content from analysis.
- **Easy integration:** The extension can be seamlessly integrated into existing projects without requiring extensive code modifications.
- **Enhanced security:** Helps protect sensitive data in the application from unintentional or intentional inspection.


## Installation

To add the `#cloaked` extension to your Swift project, simply include the `Cloaked.swift` file and follow the instructions to use it.


## Usage

To use `#cloaked` with your strings, simply wrap your plain text strings with the `#cloaked` macro as shown below:

Source code:
```swift
let secureString = #cloaked("secret")
```

Expanded source:
```swift
String(data: Data([115, 101, 99, 114, 101, 116]), encoding: .utf8)!
```

## Installation

### [Swift Package Manager](https://www.swift.org/package-manager/) (SPM)

Add the following line to the dependencies in `Package.swift`, to use CloakedStringMacro macro in a SPM project:

```swift
.package(url: "https://github.com/pykaso/swiftmacro-cloaked-string.git", from: "0.1.0"),
```

In your target:

```swift
.target(name: "<TARGET_NAME>", dependencies: [
    .product(name: "CloakedStringMacro", package: "CloakedStringMacro"),
    // ...
]),
```

Add `import CloakedStringMacro` into your source code to use CloakedStringMacro macro.

## Licensing

This project is available under the MIT License. See the LICENSE file for more information.


## Contributing

Contributions are warmly welcomed! If you have an idea on how to improve #cloaked, please feel free to create an issue or pull request.


