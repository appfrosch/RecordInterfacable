import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `@RecordInterfacable` macro.
public struct RecordInterfacableMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let conformances = node
      .arguments?
      .as(LabeledExprListSyntax.self)?
      .compactMap { $0
        .expression
        .as(ExprSyntax.self)?
        .as(DeclReferenceExprSyntax.self)?
        .baseName
        .text
      }
    let conformanceString = conformances?.joined(separator: ", ")

    let classDecl = try assertClassDecl(for: declaration)
    let symbolName = try extractSymbolName(from: classDecl)

    /// Extracts all the elements of the body of the given class.
    /// This includes all properties and functions.
    let membersDeclSyntax = declaration
      .as(ClassDeclSyntax.self)?
      .memberBlock
      .members
      .compactMap {
        $0
          .as(MemberBlockItemSyntax.self)?
          .decl
          .as(DeclSyntax.self)
      }

    /// Further extracts all variables
    let membersVariableDeclSyntax = membersDeclSyntax?
      .compactMap {
        $0
          .as(VariableDeclSyntax.self)
      }


    let memberBindingSpecifiers: [String]? = membersVariableDeclSyntax?
      .compactMap { member in
        guard let memberBindingSpecifier = member
          .bindingSpecifier
          .text
          .split(separator: ".")
          .last
        else { fatalError() }
        return "\(memberBindingSpecifier)"
      }
    guard let memberBindingSpecifiers else { fatalError() }

    /// Create a string with the declaration of all members
    let identifierTexts = membersVariableDeclSyntax?
      .map { member in
        let identifierText = member
          .bindings
          .compactMap {
            $0
              .as(PatternBindingSyntax.self)?
              .pattern
              .as(IdentifierPatternSyntax.self)?
              .identifier
              .text
          }
          .first
        guard let identifierText else { fatalError() }
        return identifierText
      }
    guard let identifierTexts
    else { fatalError() }

    let memberTypes = membersVariableDeclSyntax?
      .map { member in
        let memberType = member
          .bindings
          .compactMap {
            $0
              .as(PatternBindingSyntax.self)?
              .typeAnnotation?
              .type
              .as(IdentifierTypeSyntax.self)?
              .name
              .text
          }
          .first
        guard let memberType else { fatalError() }
        return memberType
      }
    guard let memberTypes
    else { fatalError() }

    var memberStrings = [String]()
    var initStrings = [String]()
    var varString = [String]()
    for i in 0..<identifierTexts.count {
      memberStrings.append("\(memberBindingSpecifiers[i]) \(identifierTexts[i]): \(memberTypes[i])")
      initStrings.append("\(identifierTexts[i]): record.\(identifierTexts[i])")
      varString.append("\(identifierTexts[i]): self.\(identifierTexts[i])")
    }
    let memberString = memberStrings
      .joined(separator: "\n")
    let initString = initStrings
      .joined(separator: ", ")

    return [
      DeclSyntax(
        stringLiteral: """
        struct \(symbolName)Record: Codable\((conformanceString?.isEmpty ?? true) ? "" : ",\(conformanceString!)") {
          \(memberString)
        }
        """
      ),
      DeclSyntax(
        extendedGraphemeClusterLiteral: """
      convenience init(from record: \(symbolName)Record) {
        self.init(\(initString))
      }
      """
      ),
      DeclSyntax(
        stringLiteral: """
      var record: \(symbolName)Record {
        \(symbolName)Record(id: self.id, title: self.title)
      }
      """
      ),
    ]
  }
}

extension RecordInterfacableMacro {
  static func assertClassDecl(for declaration: some DeclGroupSyntax) throws -> ClassDeclSyntax {
    guard let classDecl = declaration.as(ClassDeclSyntax.self)
    else { throw RecordInterfacableMacroError.wrongSymbolType }
    return classDecl
  }

  static func extractSymbolName(from classDecl: ClassDeclSyntax) throws -> String {
    let symbolName = classDecl
      .name
      .text

    return symbolName
  }
}

@main
struct RecordInterfacablePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    RecordInterfacableMacro.self,
  ]
}

