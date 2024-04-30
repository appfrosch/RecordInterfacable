import Foundation
import Combine
import Observation
import RecordInterfacable

@available(macOS 14.0, *)
@available(iOS 17.0, *)
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
