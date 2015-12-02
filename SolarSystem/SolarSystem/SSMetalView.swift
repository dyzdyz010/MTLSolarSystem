//
//  SSMetalView.swift
//  SolarSystem
//
//  Created by Du Yizhuo on 15/11/28.
//  Copyright © 2015年 MLTT. All rights reserved.
//

import UIKit

protocol SSMetalViewDelegate {
    func drawInView(view: SSMetalView)
}

class SSMetalView: UIView {
    var _metalLayer: CAMetalLayer!      = nil
    var _delegate: SSMetalViewDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _metalLayer                 = CAMetalLayer()
        _metalLayer.device          = MTLCreateSystemDefaultDevice()
        //        _metalLayer.frame = self.frame
        _metalLayer.pixelFormat     = MTLPixelFormat.BGRA8Unorm
        _metalLayer.framebufferOnly = true
        
        self.layer.addSublayer(_metalLayer)
    }
    
    override class func layerClass() -> AnyClass {
        return CAMetalLayer.self
    }
    
    override func didMoveToWindow() {
        _delegate.drawInView(self)
    }
}
