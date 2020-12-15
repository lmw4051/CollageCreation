//
//  CollageView.swift
//  CollageCreation
//
//  Created by David on 2020/12/14.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class CollageView: UIImageView {
  override init(frame: CGRect) {
    super.init(frame: frame)    
    contentMode = .scaleToFill
    isUserInteractionEnabled = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
