//
//  SSRenderer.swift
//  SolarSystem
//
//  Created by Du Yizhuo on 15/11/23.
//  Copyright © 2015年 MLTT. All rights reserved.
//

import UIKit
import Metal

class SSRenderer: NSObject, SSMetaViewDelegate {
    let device: MTLDevice! = MTLCreateSystemDefaultDevice()
    var renderPipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    
    override init() {
        super.init()
        
//        do {
//            try self.renderPipelineState = device!.newRenderPipelineStateWithDescriptor(MTLRenderPipelineDescriptor())
//        } catch {
//            print("Failed to create render pipeline state.\n")
//        }
        
        self.commandQueue = self.device.newCommandQueue()
    }
    
    func drawInView(view: SSMetalView) {
        let commandBuffer = self.commandQueue.commandBuffer()
        let commandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(view.currentRenderPassDescriptor())
//        commandEncoder.setRenderPipelineState(self.renderPipelineState)
        commandEncoder.endEncoding()
        
        commandBuffer.presentDrawable(view.currentDrawable)
        commandBuffer.commit()
    }
}
