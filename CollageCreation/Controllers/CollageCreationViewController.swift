//
//  CollageCreationViewController.swift
//  CollageCreation
//
//  Created by David on 2020/12/14.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import AVFoundation

class CollageCreationViewController: UIViewController {
  
  let catPlayer = AVAudioPlayer(fileName: "Cat-noise")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
        
    let createButton = CreateButton(type: .system)
    view.addSubview(createButton)
    createButton.centerXInSuperview()
    createButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 32, right: 0))
    createButton.addTarget(self, action: #selector(createCollages), for: .touchUpInside)
  }
  
  @objc func createCollages() {
    let collageView = CollageView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
    
    let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
    pinchGR.delegate = self
    
    let panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    panGR.delegate = self
    
    let rotateGR = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
    rotateGR.delegate = self
    
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))

    collageView.addGestureRecognizer(pinchGR)
    collageView.addGestureRecognizer(panGR)
    collageView.addGestureRecognizer(rotateGR)
    collageView.addGestureRecognizer(tapGR)
    view.addSubview(collageView)
  }
  
  @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
    guard let recognizerView = recognizer.view else {
      return
    }
    let scale = recognizer.scale
    recognizerView.transform = recognizerView.transform.scaledBy(x: scale, y: scale)
    recognizer.scale = 1
  }
  
  @objc func handlePan(recognizer: UIPanGestureRecognizer) {
    guard let recognizerView = recognizer.view else {
      return
    }
    let translation = recognizer.translation(in: self.view)
    recognizerView.center.x += translation.x
    recognizerView.center.y += translation.y
    recognizer.setTranslation(.zero, in: view)
  }
  
  @objc func handleRotation(recognizer: UIRotationGestureRecognizer) {
    guard let recognizerView = recognizer.view else {
      return
    }
    recognizerView.transform = recognizerView.transform.rotated(by: recognizer.rotation)
    recognizer.rotation = 0
  }
  
  @objc func handleTap(recognizer: UITapGestureRecognizer) {
    catPlayer.play()
    
    guard let recognizerView = recognizer.view else {
      return
    }
    
    UIView.animate(withDuration: catPlayer.duration) {
      recognizerView.transform = recognizerView.transform.rotated(by: CGFloat(Double.pi))
    }
  }
}

extension CollageCreationViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

extension AVAudioPlayer {
  convenience init(fileName: String) {
    let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
    try! self.init(contentsOf: url)
    prepareToPlay()
  }
}
