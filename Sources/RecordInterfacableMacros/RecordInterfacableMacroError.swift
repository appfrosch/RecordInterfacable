//
//  RecordInterfacableMacroError.swift
//  
//
//  Created by Andreas Seeger on 03.05.2024.
//

import Foundation

enum RecordInterfacableMacroError: Error, CustomStringConvertible {
  case wrongSymbolType

  var description: String {
    switch self {
    case .wrongSymbolType:
      "This macro is to be used with class types only …"
    }
  }
}
