//
//  AppIconBtnView.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 4..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

protocol AppIconBtnViewDelegate
{
    func onBtnTouchUPInside(sender : AppIconBtnView)
}



class AppIconModel
{
    var hwi_title = ""
    var hwi_image_noemal : UIImage?
    var hwi_image_pressed : UIImage?
}



class AppIconBtnView: UIView
{
    let iconSize : CGFloat = 60
    
    
    var hwi_iconImage = UIImageView()
    var hwi_title = UILabel()
    var hwi_containerBtn = UIButton()
    var delegate : AppIconBtnViewDelegate?
    
    var image_normal = UIImage()
    var image_pressed = UIImage()

    

    

    func initView()
    {
        self.hwi_title.numberOfLines = 0
        self.hwi_title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.addSubview(self.hwi_iconImage)
        self.addSubview(self.hwi_title)
        self.addSubview(self.hwi_containerBtn)
        
    }
    
    func setViews(title : String , image_normal : UIImage , image_pressed : UIImage)
    {
        //가로 60    /  세로 97 -- 텍스트 크기에 따라 가변

        let marginLeftOfIconImage = (self.frame.size.width - iconSize) / 2
        let marginTopOfIconImage = (self.frame.size.height - iconSize) / 2
        
        self.image_normal = image_normal
        self.image_pressed = image_pressed
        
        self.hwi_iconImage.image = self.image_normal
        self.hwi_iconImage.frame = CGRectMake( marginLeftOfIconImage ,marginTopOfIconImage , iconSize, iconSize)
        
        
        self.hwi_title.text = title
        var marginTopOfTitle = marginTopOfIconImage + self.hwi_iconImage.frame.size.height + 7

        self.hwi_title.font = UIFont.boldSystemFontOfSize(9)
        var heightOfTitle = HWILib.getHeightForView(self.hwi_title.text!, font: self.hwi_title.font, width: iconSize)

        self.hwi_title.frame = CGRectMake(self.hwi_iconImage.frame.origin.x , marginTopOfTitle , iconSize, heightOfTitle)
        
        
        var heightOfIconViewTotal = marginTopOfTitle + heightOfTitle
        
        self.hwi_containerBtn.frame = CGRectMake(0, 0, self.frame.size.width, heightOfIconViewTotal)
        
        self.hwi_containerBtn.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        self.hwi_containerBtn.addTarget(self, action: "onTouchUpDown:", forControlEvents: UIControlEvents.TouchDown)
        self.hwi_containerBtn.addTarget(self, action: "onTouchUpOutside:", forControlEvents: UIControlEvents.TouchUpOutside)
        self.frame.size = CGSizeMake(iconSize, heightOfIconViewTotal)

        
    }
    
    
    func onTouchUpInside(sender : UIButton )
    {
        self.hwi_iconImage.image = self.image_normal
        if delegate != nil
        {
            delegate?.onBtnTouchUPInside(self)
        }
        else
        {
            println("델리게이트 설정이 되지 않았습니다.")
        }
    }
    
    func onTouchUpDown(sender : UIButton )
    {
        self.hwi_iconImage.image = self.image_pressed
    }
    
    func onTouchUpOutside(sender : UIButton )
    {
        self.hwi_iconImage.image = self.image_normal
    }
    
}
