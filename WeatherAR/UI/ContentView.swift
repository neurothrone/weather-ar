//
//  ContentView.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-19.
//

import SwiftUI

struct ContentView: View {
  @FocusState var isSearchTextFocused: Bool
  
  @State private var searchText = ""
  @State private var isSearchTextVisible = true
  @State private var cityWeather: CityWeather?
  
  private let service: WeatherService = .shared
  
  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Weather AR")
        .navigationBarTitleDisplayMode(.inline)
        .onSubmit(of: .text) {
          Task {
            cityWeather = try await service.fetchWeatherByCity(name: searchText)
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
    VStack {
      SearchBar(
        searchText: $searchText,
        isSearchTextFocused: $isSearchTextFocused
      )
      .padding()
      .background(.purple.opacity(0.25))
      .blur(radius: isSearchTextVisible ? 0 : 10)
      .offset(y: isSearchTextVisible ? 0: -200)
      .animation(.linear, value: isSearchTextVisible)
      
      if let cityWeather {
        VStack(alignment: .leading) {
          HStack {
            Text(cityWeather.cityName)
              .font(.headline)
            
            Spacer()
            
            Text(cityWeather.temperature.formatted())
              .foregroundColor(.orange)
          }
          
          HStack {
            Spacer()
            Text(cityWeather.condition)
          }
        }
        .padding()
      }
      
      Spacer()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct SearchBar: View {
  @Binding var searchText: String
  var isSearchTextFocused: FocusState<Bool>.Binding
  
  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(
          isSearchTextFocused.wrappedValue
          ? .purple
          : .primary
        )
      
      TextField("Search", text: $searchText)
        .focused(isSearchTextFocused)
        .autocorrectionDisabled(true)
        .submitLabel(.search)
    }
    .padding(10)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .stroke(lineWidth: 1)
        .fill(
          isSearchTextFocused.wrappedValue
          ? .purple
          : .primary
        )
    )
    .animation(.linear, value: isSearchTextFocused.wrappedValue)
  }
}
