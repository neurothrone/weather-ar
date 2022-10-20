//
//  ARViewContainer.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-20.
//

import ARKit
import RealityKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
  func makeUIView(context: Context) -> ARView {
    ARViewController.shared.configure()
    return ARViewController.shared.arView
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {}
}
