//
//  CustomTableView.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 2..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

class CustomTableView: UITableView {

    var customDelegate : CustomTableViewDelegate?
    
    
    //백그라운드 터치 시 키보드 자동 내림 처리
    /*
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        customDelegate?.onTouchBegan(touches, withEvent: event)
        
    }
    */
    
}
