//
//  ARWeatherModelManager.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-20.
//

import AVFoundation
import Foundation
import RealityKit

final class ARWeatherModelManager {
  static var shared: ARWeatherModelManager = .init()
  
  private init() {}
  
  func generateWeatherModel(condition: String, temperature: Double) -> ModelEntity {
    let conditionModel = createWeatherConditionModel(with: condition)
    let temperatureText = createWeatherTextModel(with: temperature)
    
    conditionModel.addChild(temperatureText)
    temperatureText.setPosition(SIMD3<Float>(x: -0.07, y: 0.05, z: .zero), relativeTo: conditionModel)
    
    conditionModel.name = "weatherEntity"
    return conditionModel
  }
  
  private func createWeatherConditionModel(with condition: String) -> ModelEntity {
    let mesh = MeshResource.generateBox(size: 0.1)
    
    let videoItem = createVideoItemWith(fileName: condition)
    
    var materials: [Material] = []
    
    if let videoItem {
      let videoMaterial = createVideoMaterial(with: videoItem)
      materials.append(videoMaterial)
    } else {
      let simpleMaterial = SimpleMaterial(color: .purple, isMetallic: true)
      materials.append(simpleMaterial)
    }
    
    let model = ModelEntity(mesh: mesh, materials: materials)
    
    return model
  }
  
  private func createVideoItemWith(fileName: String) -> AVPlayerItem? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp4") else { return nil }
    
    let asset = AVURLAsset(url: url)
    return AVPlayerItem(asset: asset)
  }
  
  private func createVideoMaterial(with videoItem: AVPlayerItem) -> VideoMaterial {
    let player = AVPlayer()
    let videoMaterial = VideoMaterial(avPlayer: player)
    
    player.replaceCurrentItem(with: videoItem)
    player.play()
    
    return videoMaterial
  }
  
  private func createWeatherTextModel(with temperature: Double) -> ModelEntity {
    let mesh = MeshResource.generateText(
      "\(temperature) °C",
      extrusionDepth: 0.1,
      font: .systemFont(ofSize: 2),
      containerFrame: .zero,
      alignment: .left,
      lineBreakMode: .byTruncatingTail
    )
    
    let material = SimpleMaterial(color: .white, isMetallic: false)
    
    let textEntity = ModelEntity(mesh: mesh, materials: [material])
    textEntity.scale = SIMD3<Float>(x: 0.03, y: 0.03, z: 0.1)
    return textEntity
  }
}
