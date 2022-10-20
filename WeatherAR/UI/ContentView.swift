//
//  ContentView.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-19.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var arViewController: ARViewController
  
  @FocusState var isSearchTextFocused: Bool
  
  @State private var searchText = ""
  @State private var isSearchTextVisible = true
  @State private var cityWeather: CityWeather?
  
  
  private let weatherService: WeatherService = .shared
  
  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Weather AR")
        .navigationBarTitleDisplayMode(.inline)
        .onSubmit(of: .text) {
          Task {
            arViewController.receivedCityWeather = try await weatherService.fetchWeatherByCity(name: searchText)
          }
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { isSearchTextVisible.toggle() }) {
              Image(systemName: "magnifyingglass.circle.fill")
                .foregroundColor(
                  isSearchTextVisible
                  ? .purple
                  : .primary
                )
            }
          }
          
          ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Dismiss") {
              isSearchTextFocused = false
            }
          }
        }
    }
  }
  
  var content: some View {
    ZStack {
      ARViewContainer()
        .edgesIgnoringSafeArea(.all)
      
      VStack {
        SearchBarView(
          searchText: $searchText,
          isSearchTextFocused: $isSearchTextFocused
        )
        .padding()
        .background(.purple.opacity(0.25))
        .blur(radius: isSearchTextVisible ? 0 : 10)
        .offset(y: isSearchTextVisible ? 0: -200)
        .animation(.linear, value: isSearchTextVisible)

        Spacer()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(ARViewController.shared)
  }
}
