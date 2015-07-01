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

    
    class func isValidParam(inputString : String) -> (Bool)
    {
        let trimString = inputString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if trimString == ""
        {
            return false
        }
        
        return true
    }
    
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
            self.activityIndicator?.userInteractionEnabled = false
            self.activityIndicator?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            
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
}