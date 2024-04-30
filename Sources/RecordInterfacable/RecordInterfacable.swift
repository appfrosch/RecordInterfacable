/// A macro that produces a containing `struct` with all the properties
/// in a `class` to be able to conform to `Codable` even for classes that
/// interfere with `Codable` because they conform to `@Observable`.
///
/// Classes conforming to `@Observable` will automatically produce `CodingKeys` for
/// the `_`-properties this conformance produces, which in turn will mess with
/// packages that rely on `Codable`.
///
/// This macro is adding a `struct` to such a `class` that can be used for `Codable`
/// instead of the `class` itself that contains.
///
/// ```swift
/// @Observable
/// @RecordInterfacable
/// class Model {
///   let id: UUID
///   var title: String
///   init(
///     id: UUID = UUID(),
///     title: String
///   ) {
///     self.id = id
///     self.title = title
///   }
/// }
/// ```
/// becomes
/// ```swift
/// @Observable
/// class Model {
///   let id: UUID
///   var title: String
///   init(
///     id: UUID = UUID(),
///     title: String
///   ) {
///     self.id = id
///     self.title = title
///   }
///
///   struct ModelRecord: Codable {
///     let id: UUID
///     var title: String
///   }
///
///   init(from record: ModelRecord) {
///     init(
///       id: record.id,
///       title: record.title
///     )
///   }
///
///   func convertToRecord() -> ModelRecord {
///     ModelRecord(
///       id: self.id,
///       title: self.title
///     )
/// }
/// ```
@attached(memberAttribute)
public macro RecordInterfacable() = #externalMacro(module: "RecordInterfacableMacros", type: "RecordInterfacableMacro")
