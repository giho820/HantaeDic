//
//  DetailScrollView.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 2..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

class DetailScrollView: BaseScrollView
{
    let containerView = UIView()
    
    let label01_LargeText = UILabel()
    let label02_SmallLabel = UILabel()

    let label03_LargeText = UILabel()
    let label04_SmallLabel = UILabel()
    
    let label05_LargeText = UILabel()
    let label06_SmallLabel = UILabel()
    
    var arrayOfViews : [UILabel] = [];
    


    func onViewDidLoad()
    {
        // 컨테이너 뷰 설정
        containerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        containerView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = ConstValue.color03_card_gray
        
        
        switch ConstValue.dic_mode
        {
        case 1:
            label01_LargeText.text = "단어"
            label03_LargeText.text = "태국어"
            label05_LargeText.text = "발음"
        case 2:
            label01_LargeText.text = "발음"
            label03_LargeText.text = "태국어"
            label05_LargeText.text = "한국어"
        case 3:
            label01_LargeText.text = "단어"
            label03_LargeText.text = "한국어"
            label05_LargeText.text = "발음"
        default:
            break
        }
        

        
        arrayOfViews =
        [   label01_LargeText , label02_SmallLabel,
            label03_LargeText , label04_SmallLabel,
            label05_LargeText , label06_SmallLabel
        ]

        
        for oneLabel in arrayOfViews
        {
            oneLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            oneLabel.numberOfLines = 0
                self.containerView.addSubview(oneLabel)
        }
        
        self.addSubview(containerView)
        
    }
    
    
    
    func arrangeLabelViews()
    {
        var lastValueOfY : CGFloat = 0
        
        // 상단 큰 라벨 속성
        let leftMarginOfLargeText : CGFloat = 15
        let topMarginOfLargeText : CGFloat = 20
        
        var heightOfLargetText : CGFloat = 0
        let widthOfLargeText = self.frame.size.width - leftMarginOfLargeText*2
        
        // 하단 작은 라벨 속성
        let topMarginOfSmallText : CGFloat = 19
        var heightOfSmallText : CGFloat = 0
        
        for(index, oneLabel) in enumerate(arrayOfViews)
        {
            
            if index%2 == 0
            {
                // 상단 큰 라벨 속성 적용
                oneLabel.font = UIFont.boldSystemFontOfSize(27)
                
                heightOfLargetText = HWILib.getHeightForView(oneLabel.text!, font: oneLabel.font, width: widthOfLargeText)
                
                oneLabel.frame = CGRectMake(leftMarginOfLargeText, topMarginOfLargeText + lastValueOfY, widthOfLargeText , heightOfLargetText)
                
                
                
                lastValueOfY = topMarginOfLargeText + lastValueOfY + heightOfLargetText
            }
            else
            {
                // 하단 작은 라벨 속성 적용
                let yOffsetOfSmallText = topMarginOfSmallText + lastValueOfY
                oneLabel.font = UIFont.boldSystemFontOfSize(19)
                
                
                heightOfSmallText = HWILib.getHeightForView(oneLabel.text!, font: oneLabel.font, width: widthOfLargeText)
                oneLabel.frame = CGRectMake(leftMarginOfLargeText, yOffsetOfSmallText , widthOfLargeText, heightOfSmallText)
                
                lastValueOfY = yOffsetOfSmallText + heightOfSmallText
            }
            
        }
        self.containerView.frame = CGRectMake(0, 0, self.frame.size.width, lastValueOfY+20)
        self.contentSize = self.containerView.frame.size
        

    }

}
