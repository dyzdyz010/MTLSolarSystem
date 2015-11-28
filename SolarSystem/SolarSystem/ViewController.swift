//
//  ViewController.swift
//  SolarSystem
//
//  Created by Du Yizhuo on 15/11/23.
//  Copyright © 2015年 MLTT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let device = MTLCreateSystemDefaultDevice()!
    let metalLayer = CAMetalLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("viewDidLoad\n")
        // Do any additional setup after loading the view, typically from a nib.
//        metalLayer.frame = self.view.frame
//        metalLayer.device = device
//        metalLayer.pixelFormat = MTLPixelFormat.BGRA8Unorm
//        self.view.layer.addSublayer(metalLayer)
//        redraw()
//        self.renderer = SSRenderer()
    }

    
    func redraw() {
        if let drawable = metalLayer.nextDrawable() {
            
            let texture = drawable.texture
            let renderPassDesc = MTLRenderPassDescriptor()
            renderPassDesc.colorAttachments[0].texture = texture
            renderPassDesc.colorAttachments[0].loadAction = MTLLoadAction.Clear
            renderPassDesc.colorAttachments[0].storeAction = MTLStoreAction.Store
            renderPassDesc.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 0, 0, 1.0)
            
            let commandQueue = self.device.newCommandQueue()
            let commandBuffer = commandQueue.commandBuffer()
            let commandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDesc)
            commandEncoder.endEncoding()
            commandBuffer.presentDrawable(drawable)
            commandBuffer.commit()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

