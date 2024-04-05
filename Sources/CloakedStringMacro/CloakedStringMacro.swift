/// A macro that creates a string initialization from the raw bytes of the source string literal.
/// This converted string is then not easy to find in the decompiled application.
/// For example,
///
///     #cloaked("sectet")
///
/// produces:
///
///     String(data: Data([115, 101, 99, 114, 101, 116]), encoding: .utf8)!
@freestanding(expression)
public macro cloaked<T>(_ value: T) -> (T) = #externalMacro(module: "CloakedStringMacroMacros", type: "CloakedMacro")
