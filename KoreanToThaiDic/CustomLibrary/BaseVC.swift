//
//  BaseVC.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 1..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    

    // 왼쪽 백버튼 객체
    let backButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton

    // 왼쪽 백버튼 관련 이미지
    let iconBackImageNormal = UIImage(named: "back_n")
    let iconBackImageDown = UIImage(named: "back_p")
    let iconBackImageView = UIImageView()
    
    
    
    
    
    // 상단 타이틀 라벨 객체
    let topTitleLabel = UILabel()
    
    


    
    // 오른쪽 기타 버튼 객체
    let rightETCBtn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    // 왼쪽 백버튼 관련 이미지
    let iconETCImageNormal = UIImage(named: "etc_n")
    let iconETCImageDown = UIImage(named: "etc_p")
    let iconETCImageView = UIImageView()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func initHeaderView()
    {
        let container = UIView()
        container.backgroundColor = ConstValue.color07_main_blue
        container.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        

        
        // 왼쪽 백버튼 관련 처리
        backButton.backgroundColor = UIColor.clearColor()
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.setTitleColor(ConstValue.color01_white, forState: UIControlState.Normal)
        backButton.frame = CGRectMake(8, 31, 77, 21)
        backButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        
        iconBackImageView.frame = CGRectMake(0, 0, 12, 21)
        iconBackImageView.image = iconBackImageNormal
        backButton.addSubview(iconBackImageView)
        
        backButton.addTarget(self, action: "onBackBtnTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.addTarget(self, action: "onBackBtnDown:", forControlEvents: UIControlEvents.TouchDown)
        backButton.addTarget(self, action: "onBackBtnUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        
        container.addSubview(backButton)
        
        
        // 가운데 타이틀 라벨 관련 처리
        topTitleLabel.frame = CGRectMake(0, 20, self.view.frame.size.width, 44)
        topTitleLabel.backgroundColor = UIColor.clearColor()
        topTitleLabel.text = "테스트"
        topTitleLabel.textAlignment = NSTextAlignment.Center
        topTitleLabel.textColor = ConstValue.color01_white
        topTitleLabel.font = UIFont.boldSystemFontOfSize(17)
        container.addSubview(topTitleLabel)
        
        
        // 오른쪽 right 버튼 관련 처리

        rightETCBtn.frame = CGRectMake( self.view.frame.size.width - 44 , 20, 44, 44)
        iconETCImageView.frame = CGRectMake( (rightETCBtn.frame.size.width - 18)/2, 20, 18, 4)
        iconETCImageView.image = iconETCImageNormal
        
        rightETCBtn.addTarget(self, action: "onETCBtnTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        rightETCBtn.addTarget(self, action: "onETCBtnDown:", forControlEvents: UIControlEvents.TouchDown)
        rightETCBtn.addTarget(self, action: "onETCBtnUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        
        rightETCBtn.addSubview(iconETCImageView)
        
        container.addSubview(rightETCBtn)
        
        
        
        
        self.view.addSubview(container)
    }
    
    func onBackBtnTouchUpInside(sender : UIButton)
    {
        iconBackImageView.image = iconBackImageNormal
    }
    
    func onBackBtnDown(sender : UIButton)
    {
        iconBackImageView.image = iconBackImageDown
    }
    
    func onBackBtnUp(sender : UIButton)
    {
        iconBackImageView.image = iconBackImageNormal
    }
    
    
    func onETCBtnTouchUpInside(sender : UIButton)
    {
        iconETCImageView.image = iconETCImageNormal
    }
    
    func onETCBtnDown(sender : UIButton)
    {
        iconETCImageView.image = iconETCImageDown
    }
    
    func onETCBtnUp(sender : UIButton)
    {
        iconETCImageView.image = iconETCImageNormal
    }
    
    
    
}
