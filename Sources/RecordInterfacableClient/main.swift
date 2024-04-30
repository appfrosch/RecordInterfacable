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

@available(macOS 14.0, *)
@available(iOS 17.0, *)
@Observable
class ModelExpanded {
  let id: UUID
  var title: String

  init(
    id: UUID = UUID(),
    title: String
  ) {
    self.id = id
    self.title = title
  }

  convenience init(from record: ModelRecord) {
    self.init(id: record.id, title: record.title)
  }

  var record: ModelRecord {
    ModelRecord(id: self.id, title: self.title)
  }

  struct ModelRecord {
    let id: UUID
    var title: String
  }
}


class ModelFoo {
  let id: UUID
  var title: String
  init(
    id: UUID = UUID(),
    title: String
  ) {
    self.id = id
    self.title = title
  }

    convenience init(from record: ModelRecord) {
      self.init(id: record.id, title: record.title)
    }
    struct ModelRecord: Codable {
      let id: UUID
    var title: String
    }
}
