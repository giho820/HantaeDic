//
//  HWILib.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 25..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit
import SystemConfiguration


class HWILib
{
    static var activityIndicator : UIView?

    // 텍스트의 빈값 검사
    class func isValidParam(inputString : String) -> (Bool)
    {
        let trimString = inputString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if trimString == ""
        {
            return false
        }
        
        return true
    }
    
    
    // 해당 초만큼 딜레이를 준 후에 메인큐에서 실행
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    
    /// 액티비티 인디케이터 관련
    class func showActivityIndicator(currentVC : UIViewController)
    {
        if self.activityIndicator == nil
        {
            self.activityIndicator = UIView(frame: CGRectMake(0, 0, currentVC.view.frame.size.width, currentVC.view.frame.size.height))
            self.activityIndicator?.userInteractionEnabled = true
            self.activityIndicator?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            
            let sizeOfBackground = (currentVC.view.frame.size.width > currentVC.view.frame.size.height ? currentVC.view.frame.size.height : currentVC.view.frame.size.width) / 3
            
            let viewOfBackground = UIView(frame: CGRectMake(0, 0, sizeOfBackground, sizeOfBackground))
            
            viewOfBackground.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            viewOfBackground.layer.cornerRadius = 15
            viewOfBackground.center = currentVC.view.center
            
            let activityIndicatorIcon = UIActivityIndicatorView(frame: CGRectMake(0, 0, sizeOfBackground, sizeOfBackground))
            activityIndicatorIcon.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityIndicatorIcon.center = CGPointMake(viewOfBackground.frame.size.width/2, viewOfBackground.frame.size.height/2)
            viewOfBackground.addSubview(activityIndicatorIcon)
            
            let labelOfActivityIndicator = UILabel(frame: CGRectMake(0, sizeOfBackground-30, sizeOfBackground, 20))
            labelOfActivityIndicator.text = "로딩중"
            labelOfActivityIndicator.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            labelOfActivityIndicator.textAlignment = NSTextAlignment.Center
            viewOfBackground.addSubview(labelOfActivityIndicator)
            
            activityIndicatorIcon.startAnimating()
            self.activityIndicator!.addSubview(viewOfBackground)
            
            currentVC.view.addSubview(self.activityIndicator!)
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        currentVC.view.bringSubviewToFront(self.activityIndicator!)
        self.activityIndicator!.hidden = false
    }
    
    class func hideActivityIndicator()
    {
        if self.activityIndicator != nil
        {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.activityIndicator!.hidden = true
            self.activityIndicator?.removeFromSuperview()
            self.activityIndicator = nil
        }
    }
    
    
    
    
    
    
    
    // 인터넷 연결상태 확인
    class func isConnectedToNetwork() -> Bool
    {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return isReachable && !needsConnection
    }
    
    
    // 컬러값 RGB 최대값 255를 통해 가져옴
    class func colorWIthRGB( red : CGFloat , green : CGFloat , blue : CGFloat , alpha : CGFloat) -> UIColor
    {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    class func getHeightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    

    
    class func setBoldSectionToLabel(sentenceLabel : UILabel, keyword : String)
    {
        let sentenceTemp = sentenceLabel.text! as NSString
        
        var boldKeyworkd = keyword
        if  count(boldKeyworkd) > 1 && boldKeyworkd.substringToIndex(advance(boldKeyworkd.startIndex, 1)) == "*"
        {
            boldKeyworkd = dropFirst(keyword)
        }
        
        let range = sentenceTemp.rangeOfString(boldKeyworkd)
        
        var attributedString =  NSMutableAttributedString(string: sentenceLabel.text!)
        
        attributedString.setAttributes( [NSFontAttributeName : UIFont.boldSystemFontOfSize(sentenceLabel.font.pointSize)], range: range)
        
        sentenceLabel.attributedText = attributedString
    }
    
    class func getCurrentOSVersion() -> Double
    {
        
        
        return (UIDevice.currentDevice().systemVersion as NSString).doubleValue
    }
    
    
    
    class func workBackgroundAndMainThread(workInThread : (anyObjectToParam : AnyObject) -> AnyObject , workInMainThread : (anyObjectFromBackground : AnyObject) -> AnyObject)
    {
        var backgroundQueue : dispatch_queue_t?
        
        if HWILib.getCurrentOSVersion() < 8
        {
            let qualityOfServiceClass = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        }
        else
        {
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        }
        
        dispatch_async(backgroundQueue!, {

            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                
            })
            
            
        })
    }
    
    
    // 간단 AlertView 생성
    class func showSimpleAlert(title : String ,buttonText : String ,vc : UIViewController , btnClickAction : ()->())
    {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: { (alert : UIAlertAction!) -> Void in
            
            
            
            alertController.dismissViewControllerAnimated(true, completion: { () -> Void in
            })
            btnClickAction()
            
        }))
        vc.presentViewController(alertController, animated: true) { () -> Void in
            
        }
    }
    
}