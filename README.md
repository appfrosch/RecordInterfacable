## TL;DR
This macro only makes sense if you are using `GRDB` with the `Observations`s framework's `@Observable`.

## Abstract
This repository implements a macro that produces a containing `struct` with all the properties
in a `class` to be able to conform to `Codable` even for classes that
interfere with `Codable` because they conform to `@Observable`.

It also conforms to the `GRDB` conformances `FetchableRecord` and `PersistableRecord` as working around 
the quirk described below was the whole reason to dive into implementing this.

## Reason for this
Classes conforming to `@Observable` will automatically produce `CodingKeys` for
the `_`-properties this conformance produces, which in turn will mess with
packages that rely on `Codable`.

This macro is adding a `struct` to such a `class` that can be used for `Codable`
instead of the `class` itself that contains.

## Example
```swift
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
```
becomes
```swift
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
  struct ModelRecord: Codable, FetchableRecord, PersistableRecord {
    let id: UUID
    var title: String
  }
  init(from record: ModelRecord) {
    init(
      id: record.id,
      title: record.title
    )
  }
  func convertToRecord() -> ModelRecord {
    ModelRecord(
      id: self.id,
      title: self.title
    )
}
```
