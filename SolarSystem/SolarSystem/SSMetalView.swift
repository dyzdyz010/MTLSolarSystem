//
//  SSView.swift
//  SolarSystem
//
//  Created by Du Yizhuo on 15/11/23.
//  Copyright © 2015年 MLTT. All rights reserved.
//

import UIKit
import QuartzCore
import Metal
import simd

protocol SSMetaViewDelegate: NSObjectProtocol {
    func drawInView(view: SSMetalView)
}

class SSMetalView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var metalLayer: CAMetalLayer! = nil
    var currentDrawable: CAMetalDrawable! = nil
    var preferredFPS = 60
    var clearColor: MTLClearColor! = nil
    var depthTexture: MTLTexture! = nil
    var delegate: SSMetaViewDelegate! = nil
    
    var displayLink: CADisplayLink! = nil
    
    override class func layerClass() -> AnyClass {
        return CAMetalLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        self.metalLayer = CAMetalLayer()
        self.metalLayer.device = MTLCreateSystemDefaultDevice()
        self.preferredFPS = 60
        self.clearColor = MTLClearColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        self.setDrawable()
        self.makeDepthTexture()
    }
    
    override func didMoveToWindow() {
//        print("didMoveToWindow\n")
        let idealFrameDuration = 1.0 / 60
        let targetFrameDuration = 1.0 / Double(self.preferredFPS)
        let frameInterval = NSInteger(round(targetFrameDuration / idealFrameDuration))
        
        if (self.window != nil) {
            self.displayLink = CADisplayLink(target: self, selector: "displayLinkDidFire:")
            self.displayLink.frameInterval = frameInterval
            self.displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        } else {
            self.displayLink = nil
        }
    }
    
    func displayLinkDidFire(displayLink: CADisplayLink) {
        self.currentDrawable = self.metalLayer.nextDrawable()!
        
        if (self.delegate.respondsToSelector("drawInView:")) {
            self.delegate.drawInView(self)
        }
    }
    
    func setDrawable() {
        var scale = UIScreen.mainScreen().scale
        if ((self.window) != nil) {
            scale = (self.window?.screen.scale)!
        }
        
        var drawableSize = self.bounds.size
        drawableSize.width *= scale
        drawableSize.height *= scale
        self.metalLayer.drawableSize = drawableSize
    }
    
    func makeDepthTexture() {
        let drawableSize = self.metalLayer.drawableSize
        let depthTextureDesc = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(MTLPixelFormat.Depth32Float, width: Int(drawableSize.width), height: Int(drawableSize.height), mipmapped: false)
        self.depthTexture = self.metalLayer.device?.newTextureWithDescriptor(depthTextureDesc)
    }
    
    func currentRenderPassDescriptor() -> MTLRenderPassDescriptor {
        
        let renderPassDesc = MTLRenderPassDescriptor()
        renderPassDesc.colorAttachments[0].texture = self.currentDrawable.texture
        renderPassDesc.colorAttachments[0].loadAction = MTLLoadAction.Clear
        renderPassDesc.colorAttachments[0].storeAction = MTLStoreAction.Store
        renderPassDesc.colorAttachments[0].clearColor = self.clearColor
        
        renderPassDesc.depthAttachment.clearDepth = 1.0
        renderPassDesc.depthAttachment.texture = self.depthTexture
        renderPassDesc.depthAttachment.loadAction = MTLLoadAction.Clear
        renderPassDesc.depthAttachment.storeAction = MTLStoreAction.DontCare
        
        return renderPassDesc
    }

}
