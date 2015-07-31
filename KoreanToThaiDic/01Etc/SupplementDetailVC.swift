//
//  SupplementDetailVC.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 19..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

class SupplementDetailVC: BaseVC
{

    // seg_etclist_etcdetail
    @IBOutlet weak var hwi_detailWebView: UIWebView!
    
    var titleOfTop = ""
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initHeaderView()
        self.loadWebView()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func initHeaderView() {
        super.initHeaderView()
        
        self.rightETCBtn.hidden = true
        self.topTitleLabel.text = ""
        self.backButton.setTitle(self.titleOfTop, forState: UIControlState.Normal)
        
    }
    
    override func onBackBtnTouchUpInside(sender: UIButton) {
        super.onBackBtnTouchUpInside(sender)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func loadWebView()
    {
        var loadUrlPath = "etc0"
        switch currentIndex
        {
        case 0:
            loadUrlPath = "etc0"
        case 1:
            loadUrlPath = "etc1"
        case 2:
            loadUrlPath = "etc2"
        case 3:
            loadUrlPath = "etc3"
            
        default:
            self.alertWithTitle("잘못된 접근입니다.", clickString: "뒤로 가기", clickHandler: { () -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
        
        
        let path = NSBundle.mainBundle().pathForResource(loadUrlPath, ofType: "html", inDirectory: "thaidic-publish/files")
        var requestURL = NSURL(string:path!);
        var request = NSURLRequest(URL:requestURL!);
        
        self.hwi_detailWebView.loadRequest(request)
        
    }

}
