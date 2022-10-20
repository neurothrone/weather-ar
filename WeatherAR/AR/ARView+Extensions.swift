//
//  ARView+Extensions.swift
//  WeatherAR
//
//  Created by Zaid Neurothrone on 2022-10-20.
//

import ARKit
import RealityKit

extension ARView: ARCoachingOverlayViewDelegate {
  func addCoachingOverlay() {
    let overlay = ARCoachingOverlayView()
//    overlay.activatesAutomatically = false
    
    overlay.goal = .horizontalPlane
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    overlay.session = self.session
    overlay.delegate = self
    
    self.addSubview(overlay)
  }
  
  public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
    print("✅ -> Overlay did Deactivate")
  }
}
