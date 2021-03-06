//
//  SSRenderer.swift
//  SolarSystem
//
//  Created by Du Yizhuo on 15/12/2.
//  Copyright © 2015年 MLTT. All rights reserved.
//

import UIKit
import simd

class SSRenderer: NSObject, SSMetalViewDelegate {
    
    var _device: MTLDevice!                     = nil
    var _vertexBuffer: MTLBuffer!               = nil
    var _pipelineState: MTLRenderPipelineState! = nil
    var _commandQueue: MTLCommandQueue!         = nil
    
    override init() {
        super.init()
        
        setupMetal()
        makePipeline()
        makeBuffers()
    }
    
    func setupMetal() {
        _device                     = MTLCreateSystemDefaultDevice()
    }
    
    func makePipeline() {
        let lib = _device.newDefaultLibrary()!
        let vertexFunc   = lib.newFunctionWithName("vertexMain")
        let fragmentFunc = lib.newFunctionWithName("fragmentMain")
        
        let renderPipelineDesc                             = MTLRenderPipelineDescriptor()
        renderPipelineDesc.vertexFunction                  = vertexFunc
        renderPipelineDesc.fragmentFunction                = fragmentFunc
        renderPipelineDesc.colorAttachments[0].pixelFormat = MTLPixelFormat.BGRA8Unorm
        
        do {
            try self._pipelineState = self._device.newRenderPipelineStateWithDescriptor(renderPipelineDesc)
        } catch {
            print("Error when creating render pipeline state.")
            exit(1)
        }
        
        self._commandQueue = _device.newCommandQueue()
    }
    
    func makeBuffers() {
        let triangle = [SSVertex(position: vector_float4(0, 0.5, 0, 1), color: vector_float4(1.0, 0.0, 0.0, 1.0)),
            SSVertex(position: vector_float4(-0.5, -0.5, 0, 1), color: vector_float4(0.0, 1.0, 0.0, 1.0)),
            SSVertex(position: vector_float4(0.5, -0.5, 0, 1), color: vector_float4(0.0, 0.0, 1.0, 1.0))]
        _vertexBuffer = _device.newBufferWithBytes(triangle, length: triangle.count * sizeof(SSVertex), options: MTLResourceOptions.CPUCacheModeDefaultCache)
    }
    
    
    func drawInView(view: SSMetalView) {
        view._metalLayer.frame = view.frame
        if let drawable = view._metalLayer.nextDrawable() {
            let renderPassDesc = MTLRenderPassDescriptor()
            renderPassDesc.colorAttachments[0].texture     = drawable.texture
            renderPassDesc.colorAttachments[0].loadAction  = MTLLoadAction.Clear
            renderPassDesc.colorAttachments[0].storeAction = MTLStoreAction.Store
            renderPassDesc.colorAttachments[0].clearColor  = MTLClearColorMake(0.5, 0.5, 0.5, 1.0)
            
            let commandQueue = _device.newCommandQueue()
            let commandBuffer = commandQueue.commandBuffer()
            let commandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDesc)
            commandEncoder.setRenderPipelineState(_pipelineState)
            commandEncoder.setVertexBuffer(_vertexBuffer, offset: 0, atIndex: 0)
            commandEncoder.drawPrimitives(MTLPrimitiveType.Triangle, vertexStart: 0, vertexCount: 3)
            commandEncoder.endEncoding()
            commandBuffer.presentDrawable(drawable)
            commandBuffer.commit()
        }
    }
}
