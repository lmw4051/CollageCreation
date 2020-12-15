//
//  CreateButton.swift
//  CollageCreation
//
//  Created by David on 2020/12/15.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class CreateButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setImage(#imageLiteral(resourceName: "CreateButton"), for: .normal)
    constrainWidth(constant: 100)
    constrainHeight(constant: 100)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
