//
//  ViewController.swift
//  SolarSystem
//
//  Created by Du Yizhuo on 15/11/23.
//  Copyright © 2015年 MLTT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let renderer = SSRenderer()
    
    @IBOutlet var _metalView: SSMetalView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _metalView._delegate = renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

