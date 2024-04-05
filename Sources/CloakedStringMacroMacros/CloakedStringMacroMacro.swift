import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "(\(argument), \(literal: argument.description))"
    }
}

/// Implementation of the `cloaked` macro, which takes an string
/// and produces string init using data which cannot be easily found in decompiled app
///
///     #cloaked("sensitive-data")
///
///  will expand to
///
///     String(data: Data(..))
public struct CloakedMacro: ExpressionMacro {
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        guard
            /// 1. Grab the first (and only) Macro argument.
            let argument = node.argumentList.first?.expression,
            /// 2. Ensure the argument contains of a single String literal segment.
            let segments = argument.as(StringLiteralExprSyntax.self)?.segments, segments.count == 1,
            /// 3. Grab the actual String literal segment.
            case let .stringSegment(literalSegment)? = segments.first
        else {
            throw CloakedMacroError.requiresStaticStringLiteral
        }

        let rawString = literalSegment.content.text
        guard let data = rawString.data(using: .utf8) else {
            throw CloakedMacroError.failedToGetBytesFromString
        }

        let bytes = [UInt8](data)
        let strBytes = "\(bytes)"

        guard validate(bytes: bytes, originalString: rawString) else {
            throw CloakedMacroError.failedToValidateString
        }

        return "String(data: Data(\(raw: strBytes)), encoding: .utf8)!"
    }

    private static func validate(bytes: [UInt8], originalString: String) -> Bool {
        if let reconstructedString = String(bytes: bytes, encoding: .utf8), reconstructedString == originalString {
            return true
        }
        return false
    }
}

enum CloakedMacroError: Error, CustomStringConvertible {
    case requiresStaticStringLiteral
    case failedToGetBytesFromString
    case failedToValidateString

    var description: String {
        switch self {
        case .requiresStaticStringLiteral:
            return "#cloaked requires a static string literal"
        case .failedToGetBytesFromString:
            return "Conversion of string to bytes failed"
        case .failedToValidateString:
            return "String back-validation failed"
        }
    }
}

@main
struct CloakedStringMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        CloakedMacro.self
    ]
}
