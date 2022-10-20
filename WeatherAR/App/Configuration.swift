//
//  Configuration.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-20.
//

import Foundation

enum Configuration {
  enum Error: Swift.Error {
    case missingKey, invalidValue
  }
  
  static func value<T: LosslessStringConvertible>(for key: String) throws -> T {
    guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
      throw Error.missingKey
    }
    
    switch object {
    case let value as T:
      return value
    case let string as String:
      guard let value = T(string) else { fallthrough }
      return value
    default:
      throw Error.invalidValue
    }
  }
}
