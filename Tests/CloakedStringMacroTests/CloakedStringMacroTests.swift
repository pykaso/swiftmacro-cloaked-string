import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CloakedStringMacroMacros)
import CloakedStringMacroMacros

let testMacros: [String: Macro.Type] = [
    "cloaked": CloakedMacro.self,
]
#endif

final class CloakedStringMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(CloakedStringMacroMacros)
        assertMacroExpansion(
            """
            #cloaked("secret")
            """,
            expandedSource: """
            String(data: Data([115, 101, 99, 114, 101, 116]), encoding: .utf8)!
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroShouldFail() throws {
        #if canImport(CloakedStringMacroMacros)
        assertMacroExpansion(
            #"""
            #cloaked(1)
            """#,
            expandedSource: "#cloaked(1)",
            diagnostics: [
                .init(message: "#cloaked requires a static string literal", line: 1, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
