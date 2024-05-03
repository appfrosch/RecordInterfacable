import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(RecordInterfacableMacros)
import RecordInterfacableMacros

let testMacros: [String: Macro.Type] = [
    "RecordInterfacable": RecordInterfacableMacro.self,
]
#endif

final class RecordInterfacableTests: XCTestCase {
  func testMacroWithConformances() throws {
      #if canImport(RecordInterfacableMacros)
      assertMacroExpansion(
          """
          @Observable
          @RecordInterfacable(conformances: Hashable, Identifiable)
          class Model {
            let id: UUID
            var title: String
            init(
              id: UUID = UUID(),
              title: String
            ) {
              self.id = id
              self.title = title
            }
          }
          """,
          expandedSource: """
          @Observable
          class Model {
            let id: UUID
            var title: String
            init(
              id: UUID = UUID(),
              title: String
            ) {
              self.id = id
              self.title = title
            }

              struct ModelRecord: Codable, Hashable, Identifiable {
                let id: UUID
                var title: String
              }

              convenience init(from record: ModelRecord) {
                self.init(id: record.id, title: record.title)
              }

              var record: ModelRecord {
                ModelRecord(id: self.id, title: self.title)
              }
          }
          """,
          macros: testMacros
      )
      #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
      #endif
  }

  func testMacroWithoutConformances() throws {
      #if canImport(RecordInterfacableMacros)
      assertMacroExpansion(
          """
          @Observable
          @RecordInterfacable
          class Model {
            let id: UUID
            var title: String
            init(
              id: UUID = UUID(),
              title: String
            ) {
              self.id = id
              self.title = title
            }
          }
          """,
          expandedSource: """
          @Observable
          class Model {
            let id: UUID
            var title: String
            init(
              id: UUID = UUID(),
              title: String
            ) {
              self.id = id
              self.title = title
            }

              struct ModelRecord: Codable {
                let id: UUID
                var title: String
              }

              convenience init(from record: ModelRecord) {
                self.init(id: record.id, title: record.title)
              }

              var record: ModelRecord {
                ModelRecord(id: self.id, title: self.title)
              }
          }
          """,
          macros: testMacros
      )
      #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
      #endif
  }
//    func testMacro() throws {
//        #if canImport(RecordInterfacableMacros)
//        assertMacroExpansion(
//            """
//            @Observable
//            @RecordInterfacable
//            class Model {
//              let id: UUID
//              var title: String
//              init(
//                id: UUID = UUID(),
//                title: String
//              ) {
//                self.id = id
//                self.title = title
//              }
//            }
//            """,
//            expandedSource: """
//            @Observable
//            class Model {
//              let id: UUID
//              var title: String
//              init(
//                id: UUID = UUID(),
//                title: String
//              ) {
//                self.id = id
//                self.title = title
//              }
//
//              struct ModelRecord: Codable {
//                let id: UUID
//                var title: String
//              }
//
//              init(from record: ModelRecord) {
//                init(
//                  id: record.id,
//                  title: record.title
//                )
//              }
//
//              func convertToRecord() -> ModelRecord {
//                ModelRecord(
//                  id: self.id,
//                  title: self.title
//                )
//            }
//            """,
//            macros: testMacros
//        )
//        #else
//        throw XCTSkip("macros are only supported when running tests for the host platform")
//        #endif
//    }
}
