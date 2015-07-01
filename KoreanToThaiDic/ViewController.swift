//
//  ViewController.swift
//  KoreanToThaiDic
//
//  Created by jhkim on 2015. 6. 30..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DBManager.dbTest()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

