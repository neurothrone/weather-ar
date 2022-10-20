//
//  SearchBarView.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-20.
//

import SwiftUI

struct SearchBarView: View {
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


struct SearchBarView_Previews: PreviewProvider {
  @FocusState static var isSearchTextFocused: Bool
  
  static var previews: some View {
    SearchBarView(searchText: .constant(""), isSearchTextFocused: $isSearchTextFocused)
  }
}
