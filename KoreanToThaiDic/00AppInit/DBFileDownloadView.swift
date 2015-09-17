//
//  DBFileDownloadView.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 9. 16..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

class DBFileDownloadView: UIView , TCBlobDownloadDelegate , UIAlertViewDelegate
{
    let hwi_backgroundImageView = UIImageView()
    
    let hwi_dbDownloadContainerView = UIView()
    
    let hwi_dbFileDownloadStateLabel = UILabel()
    let hwi_dbFileDownloadActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    let hwi_dbFileDownloadProgressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    
    var hwi_currentVC : UIViewController!
    
    var hwi_downloadDBVersion : Double = 0
    var downloadDBURL : String!
    func onViewDidLoad()
    {
        self.userInteractionEnabled  = true

        
        // 백그라운드 이미지 셋팅
        hwi_backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFit

        var backgroundImage :UIImage!
        var backgroundColor : UIColor!
        
        switch ConstValue.dic_mode
        {
        case 1:
            backgroundImage = UIImage(named: "intro1")
            backgroundColor = HWILib.colorWIthRGB(64, green: 139, blue: 235, alpha: 1)
        case 2:
            backgroundImage = UIImage(named: "intro3")
            backgroundColor = HWILib.colorWIthRGB(75, green: 223, blue: 162, alpha: 1)
        case 3:

            backgroundImage = UIImage(named: "intro2")
            backgroundColor = HWILib.colorWIthRGB(223, green: 78, blue: 78, alpha: 1)
        default:
            break
        }
        
        
        self.hwi_backgroundImageView.image = backgroundImage
        self.hwi_backgroundImageView.backgroundColor = backgroundColor
        self.addSubview(self.hwi_backgroundImageView)
        
        
        
        
        // 다운로드 컨테이너 뷰 셋팅
        self.hwi_dbDownloadContainerView.backgroundColor = HWILib.colorWIthRGB(0, green: 0, blue: 0, alpha: 0.5)
        self.hwi_dbDownloadContainerView.layer.cornerRadius = 10
        self.hwi_dbDownloadContainerView.layer.masksToBounds = true
        self.addSubview(self.hwi_dbDownloadContainerView)
        
        
        
        // 다운로드 컨테이너뷰 속 라벨 셋팅
        self.hwi_dbFileDownloadStateLabel.numberOfLines = 0
        self.hwi_dbFileDownloadStateLabel.font = UIFont.systemFontOfSize(15)
        self.hwi_dbFileDownloadStateLabel.textAlignment = NSTextAlignment.Center
        self.hwi_dbFileDownloadStateLabel.textColor = UIColor.whiteColor()
        self.hwi_dbFileDownloadStateLabel.text = "데이터베이스 파일을 확인중입니다."

        self.hwi_dbDownloadContainerView.addSubview(self.hwi_dbFileDownloadStateLabel)
        
        
        // 액티비티 인디케이터 셋팅
        self.hwi_dbFileDownloadActivityIndicator.startAnimating()
        self.hwi_dbDownloadContainerView.addSubview(self.hwi_dbFileDownloadActivityIndicator)

        // 프로그레스바 --> 토탈 사이즈를 알 수 없음
//        self.hwi_dbDownloadContainerView.addSubview(self.hwi_dbFileDownloadProgressBar)

        
        if HWILib.isConnectedToNetwork()
        {
            // 통신 시작
            println("인터넷 접속 확인되어 통신 시작")
            var request = HTTPTask()
            
            request.GET(ConstValue.url00_versionCheck, parameters: nil, completionHandler: {(response: HTTPResponse) in
                if let err = response.error {
                    println("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }

                if let data = response.responseObject as? NSData
                {
                    // 네트워크 응답 String Log 출력
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)!
                    println("response: \(str)") //prints the HTML of the page
                    
                    if let responseDic = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                    {
                        // 추후 앱 버전 비교 후 분기 처리시 사용 ( 현재는 사용하지 않음 )
                        let currentAppVersion = DBManager.hwi_getCurrentAppVersion()
                        
                        let currentDBVersion = DBManager.hwi_getCurrentDBVersion()
                        
                        println("현재 앱의 DB 버전 : \(currentDBVersion)")
                        
                        // 현재 DB 파일이 존재하지 않는다 --> DB 파일 다운로드
                        
                        var keyOfDBFilrUrl = ""
                        var keyOfDBVersion = ""
                        
                        switch ConstValue.dic_mode
                        {
                        case 1:
                            keyOfDBFilrUrl = "DBCURDTPATH_K"
                            keyOfDBVersion = "DBCURVERCD_K"
                        case 2:
                            keyOfDBFilrUrl = "DBCURDTPATH_P"
                            keyOfDBVersion = "DBCURVERCD_P"
                        case 3:
                            keyOfDBFilrUrl = "DBCURDTPATH_T"
                            keyOfDBVersion = "DBCURVERCD_T"
                        default :
                            break
                        }
                        
                        
                        var serviceInfo = responseDic.objectForKey("SERVICEINFO") as! NSDictionary
                        self.downloadDBURL = serviceInfo.objectForKey(keyOfDBFilrUrl) as! String
                        var serverDBVersion = serviceInfo.objectForKey(keyOfDBVersion) as! Double
                        self.hwi_downloadDBVersion = serverDBVersion
                        ConstValue.url01_HantaeDic = serviceInfo.objectForKey("STORE_URL_K") as! String
                        ConstValue.url02_ListenTaeHanDic = serviceInfo.objectForKey("STORE_URL_P") as! String
                        ConstValue.url03_TaehanDic = serviceInfo.objectForKey("STORE_URL_T") as! String
                        
                        
                        println("다운로드 URL : \(self.downloadDBURL)")
                        println("저장경로 : \(DBManager.hwi_getDocumentFolderPath())")
                        
                        
                        // DB 파일을 다운로드 받아야 할 때
                        if currentDBVersion < serverDBVersion
                        {
                            
                            dispatch_async(dispatch_get_main_queue(),{
                                println("현재 버전보다 서버 버전이 높아서 다운로드 진행")
                                
                                // iOS 버전이 8 이상일 경우 -> UIAlertController 가 존재해서 최신 API 사용
                                if objc_getClass("UIAlertController") != nil {
                                    
                                    println("UIAlertController can be instantiated")
                                    
                                    let alertController = UIAlertController(title: "최신 버전의 DB로 업데이트 하시겠습니까?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                                    alertController.addAction(UIAlertAction(title: "네", style: UIAlertActionStyle.Default, handler: { (alert : UIAlertAction!) -> Void in
                                        
                                        
                                        let fileURL = NSURL(string: self.downloadDBURL)
                                        let download = TCBlobDownloadManager.sharedInstance.downloadFileAtURL(fileURL!, toDirectory: NSURL(fileURLWithPath: DBManager.hwi_getDocumentFolderPath()) , withName: DBManager.DBFILE_NAME, andDelegate: self)
                                        
                                        alertController.dismissViewControllerAnimated(true, completion: { () -> Void in
                                            
                                        })
                                        
                                    }))
                                    
                                    alertController.addAction(UIAlertAction(title: "아니오", style: UIAlertActionStyle.Default, handler: { (alert : UIAlertAction!) -> Void in
                                        
                                        DBManager.initDB()
                                        self.hidden = true
                                        
                                        alertController.dismissViewControllerAnimated(true, completion: { () -> Void in
                                            
                                        })
                                        
                                    }))
                                    
                                    
                                    self.hwi_currentVC.presentViewController(alertController, animated: true) { () -> Void in
                                        
                                    }

                                    
                                }
                                // 구버전일 경우 UIAlertController 가 없어서 -> 구형 API 사용
                                else
                                {
                                    
                                    let alert = UIAlertView()
                                    alert.title = "최신 버전의 DB로 업데이트 하시겠습니까?"
                                    alert.addButtonWithTitle("네")
                                    alert.addButtonWithTitle("아니오")
                                    alert.delegate = self
                                    alert.show()
                                    println("UIAlertController can NOT be instantiated")
                                    

                                }
                                
                                
                               
                            })
                            
                            
                            
                            
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(),{
                                println("현재 버전이 이미 최신버전이어서 그대로 진행")
                                DBManager.initDB()
                                self.hidden = true
                                println("hidden 진행")
                            })
                        }
                        
                    }
                    
                    
                }
            })
        }
        else
        {
            HWILib.showSimpleAlert("인터넷 연결이 되어있지 않으면 사용할 수 없습니다.", buttonText: "확인", vc: self.hwi_currentVC, btnClickAction: { () -> () in
                
            })
        }
        
       
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        println("버튼 인덱스 : \(buttonIndex)")
        
        switch buttonIndex
        {
        case 0:
            let fileURL = NSURL(string: self.downloadDBURL)
            let download = TCBlobDownloadManager.sharedInstance.downloadFileAtURL(fileURL!, toDirectory: NSURL(fileURLWithPath: DBManager.hwi_getDocumentFolderPath()) , withName: DBManager.DBFILE_NAME, andDelegate: self)
        case 1:
            DBManager.initDB()
            self.hidden = true
            
        default:
            break
        }
    }
    
    
    func onViewShow()
    {
        // 현재 자신의 크기 = 부모뷰의 크기
        self.frame = CGRectMake(0, 0, self.superview!.frame.size.width, self.superview!.frame.size.height)
        
        // 백그라운드 이미지뷰의 배치
        self.hwi_backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
        
        
        // DB 다운로드 컨테이너 뷰 배치
        let widthOfdbDownloadContainerView = self.frame.size.width * 0.8
        let heightOfdbDownloadContainerView : CGFloat = 100
        let leftMarginOfContainerView = (self.frame.size.width - widthOfdbDownloadContainerView) / 2
        let topMarginOfContainerView = self.frame.size.height * 0.2
        
        self.hwi_dbDownloadContainerView.frame = CGRectMake(leftMarginOfContainerView, topMarginOfContainerView, widthOfdbDownloadContainerView, heightOfdbDownloadContainerView)
        
        
        // DB 다운로드 컨테이너 뷰 속 상태 라벨 배치
        let widthOfdbFileDownloadStateLabel = self.hwi_dbFileDownloadStateLabel.superview!.frame.size.width * 0.9
        let heightOfdbFileDownloadStateLabel : CGFloat = 20
        let leftMarginOfdbFileDownloadStateLabel = (self.hwi_dbFileDownloadStateLabel.superview!.frame.size.width - widthOfdbFileDownloadStateLabel) / 2
        let topMarginOfdbFileDownloadStateLabel : CGFloat = 5
        
        self.hwi_dbFileDownloadStateLabel.frame = CGRectMake(leftMarginOfdbFileDownloadStateLabel, topMarginOfdbFileDownloadStateLabel, widthOfdbFileDownloadStateLabel, heightOfdbFileDownloadStateLabel)
        
        // 액티비티 인디케이터 셋팅
        let widthOfdbFileDownloadActivityIndicator : CGFloat = 20
        let heightOfdbFileDownloadActivityIndicator : CGFloat = widthOfdbFileDownloadActivityIndicator
        let leftMarginOfdbFileDownloadActivityIndicator = (self.hwi_dbFileDownloadActivityIndicator.superview!.frame.size.width - widthOfdbFileDownloadActivityIndicator) / 2
        let topMarginOfdbFileDownloadActivityIndicator : CGFloat = topMarginOfdbFileDownloadStateLabel + heightOfdbFileDownloadStateLabel + 20
        
        self.hwi_dbFileDownloadActivityIndicator.frame = CGRectMake(leftMarginOfdbFileDownloadActivityIndicator, topMarginOfdbFileDownloadActivityIndicator, widthOfdbFileDownloadActivityIndicator, heightOfdbFileDownloadActivityIndicator)
        
        
        
        // 다운로드 프로그레스 뷰 셋팅
        /*
        let widthOfdbFileDownloadProgressBar : CGFloat = self.hwi_dbFileDownloadStateLabel.superview!.frame.size.width * 0.9
        let heightOfdbFileDownloadProgressBar : CGFloat = 10
        let leftMarginOfdbFileDownloadProgressBar = (self.hwi_dbFileDownloadProgressBar.superview!.frame.size.width - widthOfdbFileDownloadProgressBar) / 2
        let topMarginOfdbFileDownloadProgressBar : CGFloat = hwi_dbFileDownloadProgressBar.frame.origin.y + hwi_dbFileDownloadProgressBar.frame.size.height + 20
        
        self.hwi_dbFileDownloadProgressBar.frame = CGRectMake(leftMarginOfdbFileDownloadProgressBar, topMarginOfdbFileDownloadProgressBar, widthOfdbFileDownloadProgressBar, heightOfdbFileDownloadProgressBar)
        */

    }
    
    func download(download: TCBlobDownload, didProgress progress: Float, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        self.hwi_dbFileDownloadStateLabel.text = "DB파일을 다운로드 중입니다.\n\(totalBytesWritten)"
        /*
        self.hwi_dbFileDownloadProgressBar.setProgress(progress, animated: true)
        println("progress : \(progress)  totalBytesWritten : \(totalBytesWritten)   totalBytesExpectedToWrite : \(totalBytesExpectedToWrite)")
        */
    }
    
    func download(download: TCBlobDownload, didFinishWithError error: NSError?, atLocation location: NSURL?)
    {
        self.hwi_dbFileDownloadStateLabel.text = "다운로드 완료"
        println("다운로드 완료")
        
        // 데이터베이스 셋팅 및 버전 저장
        DBManager.initDB()
        DBManager.hwi_setCurrentDBVersion(self.hwi_downloadDBVersion)
        
        HWILib.delay(0.5, closure: { () -> () in
            self.hidden = true
        })
    }
}
