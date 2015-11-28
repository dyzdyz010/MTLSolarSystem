//
//  SSMetalView.swift
//  SolarSystem
//
//  Created by Du Yizhuo on 15/11/28.
//  Copyright © 2015年 MLTT. All rights reserved.
//

import UIKit

class SSMetalView: UIView {
    var _device: MTLDevice! = nil
    var _metalLayer: CAMetalLayer! = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupMetal()
    }
    
    func setupMetal() {
        _device = MTLCreateSystemDefaultDevice()
        _metalLayer = CAMetalLayer()
        _metalLayer.device = _device
//        _metalLayer.frame = self.frame
        _metalLayer.pixelFormat = MTLPixelFormat.BGRA8Unorm
        _metalLayer.framebufferOnly = true
        
        self.layer.addSublayer(_metalLayer)
    }
    
    override class func layerClass() -> AnyClass {
        return CAMetalLayer.self
    }
    
    override func didMoveToWindow() {
        draw()
    }
    
    func draw() {
        _metalLayer.frame = self.frame
        if let drawable = _metalLayer.nextDrawable() {
            let renderPassDesc = MTLRenderPassDescriptor()
            renderPassDesc.colorAttachments[0].texture = drawable.texture
            renderPassDesc.colorAttachments[0].loadAction = MTLLoadAction.Clear
            renderPassDesc.colorAttachments[0].storeAction = MTLStoreAction.Store
            renderPassDesc.colorAttachments[0].clearColor = MTLClearColorMake(0, 1.0, 0, 1.0)
            
            let commandQueue = _device.newCommandQueue()
            let commandBuffer = commandQueue.commandBuffer()
            let commandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDesc)
            commandEncoder.endEncoding()
            commandBuffer.presentDrawable(drawable)
            commandBuffer.commit()
        }
    }
}
