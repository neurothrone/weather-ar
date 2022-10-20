//
//  WeatherData.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-19.
//

import Foundation

struct CityWeatherData: Codable {
  let weather: [Weather]
  let main: Main
  let name: String
}

struct CoordWeatherData: Codable {
  let weather: [Weather]
  let main: Main
  let coord: Coord
}

struct Weather: Codable {
  let id: Int // Conditions
}

struct Main: Codable {
  let temp: Double
}

struct Coord: Codable {
  let lon: Double
  let lat: Double
}
