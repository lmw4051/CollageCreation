//
//  CreateButton.swift
//  CollageCreation
//
//  Created by David on 2020/12/15.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)    
    constrainWidth(constant: 100)
    constrainHeight(constant: 100)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
