//
//  WeatherService.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-19.
//

import Foundation

enum NetworkError: String {
  case badURL = "❌ -> Bad URL"
  case decodingError = "❌ -> Failed to decode data"
  case invalidResponse = "❌ -> Invalid Response"
}

class WeatherService {
  static var shared: WeatherService = .init()
  
  private var apiKey: String {
    do {
      return try Configuration.value(for: "API_KEY")
    } catch {
      fatalError("❌ -> No API Key found in Configuration files")
    }
  }
  
//  private let apiKey: String
//
//  private init() {
//    guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
//      fatalError("❌ -> No API Key found in the environment")
//    }
//
//    self.apiKey = apiKey
//  }
  
  func fetchWeatherByCity(name: String) async throws -> CityWeather {
    let urlString = WeatherURL.city(name: name).urlStringWith(apiKey: apiKey)    
    guard let url = URL(string: urlString) else {
      fatalError(NetworkError.badURL.rawValue)
    }
    
    let urlRequest = URLRequest(url: url)
    let session = URLSession(configuration: .default)
    let (data, _) = try await session.data(for: urlRequest)
    
    guard let cityWeatherData = self.decodeCityData(data) else {
      fatalError(NetworkError.decodingError.rawValue)
    }
    
    return convert(cityWeatherData: cityWeatherData)
  }
  
  private func decodeCityData(_ data: Data) -> CityWeatherData? {
    do {
      let decodedData = try JSONDecoder().decode(CityWeatherData.self, from: data)
      return decodedData
    } catch {
      return nil
    }
  }
  
  private func convert(cityWeatherData: CityWeatherData) -> CityWeather {
    .init(cityWeatherData: cityWeatherData)
  }
  
  private func convert(coordWeatherData: CoordWeatherData) -> CoordWeather {
    .init(coordWeatherData: coordWeatherData)
  }
}

extension WeatherService {
  private enum WeatherURL {
    case city(name: String)
    case coordinates(lat: Double, lon: Double)
    
    private static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func urlStringWith(apiKey: String) -> String {
      switch self {
      case .city(let name):
        return "\(Self.baseURL)?q=\(name)&appid=\(apiKey)"
      case .coordinates(let lat, let lon):
        return "\(Self.baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
      }
    }
  }
}
