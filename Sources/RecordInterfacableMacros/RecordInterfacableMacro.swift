import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `@RecordInterfacable` macro.
public struct RecordInterfacableMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
      return [
        AttributeSyntax("@Foo")
      ]
    }
}

@main
struct RecordInterfacablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        RecordInterfacableMacro.self,
    ]
}
