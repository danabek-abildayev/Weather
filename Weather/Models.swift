//
//  Models.swift
//  Weather
//
//  Created by Danabek Abildayev on 09.01.2024.
//

import Foundation

struct WeatherModel: Codable {
    let name: String
    let main: CurrentWeather
    let weather: [WeatherInfo]
}

struct CurrentWeather: Codable {
    let temp: Float
}

struct WeatherInfo: Codable {
    let main: String
    let description: String
}
