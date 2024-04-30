import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `@RecordInterfacable` macro.
public struct RecordInterfacableMacro: MemberMacro {
//    public static func expansion(
//        of node: MemberBlockSyntax,
//        attachedTo declaration: some DeclGroupSyntax,
//        providingAttributesFor member: some DeclSyntaxProtocol,
//        in context: some MacroExpansionContext
//    ) throws -> [MemberBlockSyntax] {
//
//      return [
//
//      ]
//    }
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let symbolName = declaration
      .as(ClassDeclSyntax.self)?
      .name
      .text
    else {
      fatalError("There should be a binding.")
    }
    return [
      "struct \(raw: symbolName)Record: Codable {}"
    ]
  }
}

@main
struct RecordInterfacablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        RecordInterfacableMacro.self,
    ]
}
