//
//  CollageCreationViewController.swift
//  CollageCreation
//
//  Created by David on 2020/12/14.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class CollageCreationViewController: UIViewController {
  let createButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "CreateButton"), for: .normal)
    button.constrainWidth(constant: 100)
    button.constrainHeight(constant: 100)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
        
    view.addSubview(createButton)
    createButton.centerXInSuperview()
    createButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 32, right: 0))
    createButton.addTarget(self, action: #selector(createCollages), for: .touchUpInside)
  }
  
  @objc func createCollages() {
    let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
    imageView.image = UIImage(named: "cat")
    imageView.contentMode = .scaleToFill
    imageView.isUserInteractionEnabled = true
    
    let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
    pinchGR.delegate = self
    
    let panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    panGR.delegate = self
    
    let rotateGR = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
    rotateGR.delegate = self

    imageView.addGestureRecognizer(pinchGR)
    imageView.addGestureRecognizer(panGR)
    imageView.addGestureRecognizer(rotateGR)
    
    view.addSubview(imageView)
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
}

extension CollageCreationViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
