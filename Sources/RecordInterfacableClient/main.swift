import Foundation
import Combine
import Observation
import RecordInterfacable

@available(macOS 14.0, *)
@available(iOS 17.0, *)
/// This example shows what the macro adds to the class it's applied to–just right-click on `@RecordInterfacable` and expand it.
@RecordInterfacable
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
}

/// Comment the following code in to see the error message shown if the macro is applied to anything but a `class`.
//@RecordInterfacable
//struct Foo {}
