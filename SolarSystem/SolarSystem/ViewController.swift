//
//  ViewController.swift
//  SolarSystem
//
//  Created by Du Yizhuo on 15/11/23.
//  Copyright © 2015年 MLTT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var metalView: SSMetalView!
    
    var renderer: SSRenderer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("viewDidLoad\n")
        // Do any additional setup after loading the view, typically from a nib.
        self.renderer = SSRenderer()
        self.metalView.delegate = self.renderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

