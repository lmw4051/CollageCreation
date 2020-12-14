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
        
    view.addSubview(imageView)
  }
}
