//
//  ARViewController.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-20.
//

import ARKit
import Foundation
import RealityKit

final class ARViewController: ObservableObject {
  static var shared: ARViewController = .init()
  
  @Published var arView: ARView
  
  private var weatherModelManager: ARWeatherModelManager = .shared
  private var weatherAnchor: AnchorEntity?
  private var hasPlacedWeatherEntity = false
  
  var receivedCityWeather: CityWeather = .init(cityName: "Stockholm", temperature: 25, conditionID: 2) {
    didSet {
      updateModel(condition: receivedCityWeather.condition, temperature: receivedCityWeather.temperature)
    }
  }
  
  private init() {
    arView = ARView(frame: .zero)
    arView.addCoachingOverlay()
  }
  
  func configure() {
    registerTapGesture()
    setUpPlaneDetection()
  }
  
  private func setUpPlaneDetection() {
    arView.automaticallyConfigureSession = true
    
    let config = ARWorldTrackingConfiguration()
    config.planeDetection = .horizontal
    config.environmentTexturing = .automatic
    
    arView.session.run(config)
  }
  
  private func registerTapGesture() {
    arView.addGestureRecognizer(
      UITapGestureRecognizer(
        target: self,
        action: #selector(onTap)
      )
    )
  }
  
  @objc
  private func onTap(recognizer: UITapGestureRecognizer) {
    let tapLocation = recognizer.location(in: arView)
    
    let raycastResults = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
    
    guard let firstRaycast = raycastResults.first else { return }
    
    let worldPosition = simd_make_float3(firstRaycast.worldTransform.columns.3)
    
//    let mesh = MeshResource.generateBox(size: 0.02)
//    let material = SimpleMaterial(color: .purple, isMetallic: true)
//    let model = ModelEntity(mesh: mesh, materials: [material])
    
//    placeModelEntity(model, at: worldPosition)
    
    if !hasPlacedWeatherEntity {
      let weatherEntity = weatherModelManager.generateWeatherModel(
        condition: receivedCityWeather.condition,
        temperature: receivedCityWeather.temperature
      )

      placeModelEntity(weatherEntity, at: worldPosition)
      hasPlacedWeatherEntity = true
    }
  }
  
  private func placeModelEntity(_ modelEntity: ModelEntity, at position: SIMD3<Float>) {
    weatherAnchor = AnchorEntity(world: position)
    
    guard let weatherAnchor = weatherAnchor else { return }
    
    weatherAnchor.addChild(modelEntity)
    arView.scene.addAnchor(weatherAnchor)
  }
  
  private func updateModel(condition: String, temperature: Double) {
    guard let weatherAnchor = weatherAnchor else { return }
    
    arView.scene.findEntity(named: "weatherEntity")?.removeFromParent()
    
    let newWeatherEntity = weatherModelManager.generateWeatherModel(
      condition: receivedCityWeather.condition,
      temperature: receivedCityWeather.temperature
    )
    
    weatherAnchor.addChild(newWeatherEntity)
  }
}
