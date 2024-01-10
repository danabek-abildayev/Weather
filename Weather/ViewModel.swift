//
//  ViewModel.swift
//  Weather
//
//  Created by Danabek Abildayev on 09.01.2024.
//

import Foundation
import Combine

enum WeatherErrors: LocalizedError {
    case failedToDecode
    case custom(error: Error)
    case invalidStatusCode
    
    var errorDescription: String? {
        switch self {
        case .failedToDecode:
            "Failed to decode response"
        case .custom(error: let error):
            error.localizedDescription
        case .invalidStatusCode:
            "Request fails within invalid range"
        }
    }
}

class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var temp: String = ""
    @Published var weatherMain: String = ""
    @Published var weatherDescription: String = ""
    @Published private(set) var isRefreshing: Bool = false
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        fetchWeather()
    }
    
    func fetchWeather() {
        let city = "Atyrau"
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=4edfe9decef34a6875f6450265d6d5cd")
        else {
            return
        }
        
        isRefreshing = true
        
        URLSession.shared
            .dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .tryMap({ res in
                guard let response = res.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 300 else {
                    print("Error occured: invalid status")
                    throw WeatherErrors.invalidStatusCode
                }
                
                let decoder = JSONDecoder()
                guard let model = try? decoder.decode(WeatherModel.self, from: res.data) else {
                    print("Error occured: failed to decode")
                    throw WeatherErrors.failedToDecode
                }
                
                return model
            })
            .sink { [weak self] res in
                defer { self?.isRefreshing = false }
                switch res {
                case .failure(let error):
                    print("Error occured: \(WeatherErrors.custom(error: error))")
                default:
                    break
                }
            } receiveValue: { [weak self] model in
                self?.city = model.name
                self?.temp = String(model.main.temp)
                self?.weatherMain = model.weather.first?.main ?? "No Weather info"
                self?.weatherDescription = model.weather.first?.description ?? "No weather description"
            }
            .store(in: &bag)
    }
}
