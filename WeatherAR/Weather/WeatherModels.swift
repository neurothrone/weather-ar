//
//  WeatherModels.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-19.
//

import Foundation

protocol HasWeatherCondition {
  var conditionID: Int { get set }
  var condition: String { get }
}

extension HasWeatherCondition {
  var condition: String {
    switch conditionID {
    case 200...232, 801...804:
      return "Thunder"
    case 300...321, 500...531:
      return "Rainy"
    case 600...622:
      return "Snow"
    case 701...781:
      return "Fog"
    case 800:
      return "Sunny"
    default:
      return "Normal"
    }
  }
}

struct CityWeather: HasWeatherCondition {
  let cityName: String
  let temperature: Double
  var conditionID: Int
  
  init(cityWeatherData: CityWeatherData) {
    cityName = cityWeatherData.name
    temperature = cityWeatherData.main.temp
    conditionID = cityWeatherData.weather.first!.id
  }
}

struct CoordWeather: HasWeatherCondition {
  let latitude: Double
  let longitude: Double
  let temperature: Double
  var conditionID: Int
  
  init(coordWeatherData: CoordWeatherData) {
    latitude = coordWeatherData.coord.lat
    longitude = coordWeatherData.coord.lon
    temperature = coordWeatherData.main.temp
    conditionID = coordWeatherData.weather.first!.id
  }
}
