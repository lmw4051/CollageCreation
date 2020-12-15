//
//  CollageCreationViewController.swift
//  CollageCreation
//
//  Created by David on 2020/12/14.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class CollageCreationViewController: UIViewController {
  // MARK: - Instance Properties
  let catPlayer = AVAudioPlayer(fileName: "Cat-noise")
  var collages: [Collage] = []
  
  let modelName = "Collages"
  let entityName = "Collage"
  lazy var coreDataStack = CoreDataStack(modelName: modelName)
     
  // MARK: - View Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCollageViewData()
    configureUI()
  }
  
  // MARK: - Helper Methods
  func configureUI() {
    view.backgroundColor = .white
    
    let createButton = CustomButton(type: .system)
    createButton.setImage(#imageLiteral(resourceName: "CreateButton"), for: .normal)
    view.addSubview(createButton)
    createButton.centerXInSuperview()
    createButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 32, right: 0))
    createButton.addTarget(self, action: #selector(createCollages), for: .touchUpInside)
        
    let eraserButton = CustomButton(type: .system)
    eraserButton.setTitle("Rmove All", for: .normal)        
    view.addSubview(eraserButton)
    eraserButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 16))
    eraserButton.addTarget(self, action: #selector(removeAllViews), for: .touchUpInside)
    
    loadExistingCollageViews()
  }
  
  func loadExistingCollageViews() {
    for i in collages {
      guard
        let imageData = i.imageData as Data?,
        let imageRect = i.imageRect as String?,
        let identifier = i.id else {
          return
      }
      let rect = NSCoder.cgRect(for: imageRect)
      let collageView = CollageView(frame: rect)
      collageView.image = UIImage(data: imageData)
      collageView.accessibilityIdentifier = identifier
      addGestures(view: collageView)
      view.addSubview(collageView)
    }
  }
  
  func loadCollageViewData() {
    let collageFetch: NSFetchRequest<Collage> = Collage.fetchRequest()
    collageFetch.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    
    do {
      let results = try coreDataStack.managedContext.fetch(collageFetch)
      collages = results
    } catch let error as NSError {
      print("Fetch error: \(error) description: \(error.userInfo)")
    }
  }
  
  func saveCollageViewData(_ collageView: CollageView) {
    let collage = NSEntityDescription.insertNewObject(forEntityName: entityName, into: coreDataStack.managedContext) as! Collage
    collage.creationDate = Date()
    collage.imageRect = NSCoder.string(for: collageView.frame)
    collage.imageData = collageView.image?.pngData()
    collage.id = collageView.accessibilityIdentifier ?? ""
    coreDataStack.saveContext()
  }
  
  func addGestures(view: UIView) {
    let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
    pinchGR.delegate = self
    
    let panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    panGR.delegate = self
    
    let rotateGR = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
    rotateGR.delegate = self
    
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))

    view.addGestureRecognizer(pinchGR)
    view.addGestureRecognizer(panGR)
    view.addGestureRecognizer(rotateGR)
    view.addGestureRecognizer(tapGR)
  }
  
  // MARK: - Selector Methods
  @objc func createCollages() {
    let collageView = CollageView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
    collageView.image = UIImage(named: "cat")
    collageView.accessibilityIdentifier = ProcessInfo().globallyUniqueString
    addGestures(view: collageView)
    view.addSubview(collageView)
    
    saveCollageViewData(collageView)
  }
  
  @objc func removeAllViews() {
    for i in view.subviews {
      if i is CollageView {
        i.removeFromSuperview()
      }
    }
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Collage")
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try coreDataStack.managedContext.execute(batchDeleteRequest)
    } catch let error as NSError {
      print("Fetch error: \(error) description: \(error.userInfo)")
    }
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
    
    if recognizer.state == .ended {
      print("recognizer.state == .ended")
      
      guard let id = recognizerView.accessibilityIdentifier else { return }
      
      let collageFetch: NSFetchRequest<Collage> = Collage.fetchRequest()
      let predicate = NSPredicate(format: "id = %@", id)
      collageFetch.predicate = predicate
      
      do {
        let result = try coreDataStack.managedContext.fetch(collageFetch)
        print(result.count)
        result.first?.imageRect = NSCoder.string(for: recognizerView.frame)
        coreDataStack.saveContext()
      } catch let error as NSError {
        print("Fetch error: \(error) description: \(error.userInfo)")
      }
    }
  }
  
  @objc func handleRotation(recognizer: UIRotationGestureRecognizer) {
    guard let recognizerView = recognizer.view else {
      return
    }
    recognizerView.transform = recognizerView.transform.rotated(by: recognizer.rotation)
    recognizer.rotation = 0
  }
  
  @objc func handleTap(recognizer: UITapGestureRecognizer) {
    if let recognizerView = recognizer.view {
      if recognizerView is UIImageView {
        catPlayer.play()
        
        UIView.animate(withDuration: catPlayer.duration) {
          recognizerView.transform = recognizerView.transform.rotated(by: CGFloat(Double.pi))
        }
      }
    }        
  }
}

// MARK: - UIGestureRecognizerDelegate Methods
extension CollageCreationViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

// MARK: - AVAudioPlayer
extension AVAudioPlayer {
  convenience init(fileName: String) {
    let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
    try! self.init(contentsOf: url)
    prepareToPlay()
  }
}
