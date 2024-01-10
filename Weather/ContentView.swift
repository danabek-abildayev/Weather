//
//  ContentView.swift
//  Weather
//
//  Created by Danabek Abildayev on 09.01.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.isRefreshing {
                ProgressView()
            } else {
                VStack {
                    Text(viewModel.city)
                        .font(.system(size: 32))
                    Text(viewModel.temp)
                        .font(.system(size: 44))
                    Text(viewModel.weatherMain)
                        .font(.system(size: 24))
                    Text(viewModel.weatherDescription)
                        .font(.system(size: 24))
                }
                .navigationTitle("Weather in")
            }
        }
    }
}

#Preview {
    ContentView()
}
