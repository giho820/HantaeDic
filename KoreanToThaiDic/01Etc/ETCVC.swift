//
//  ETCVC.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 4..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

// seg_etc_detail    기타 뷰컨트롤러 ---> 웹뷰 컨트롤러로 이동 세그웨이

class ETCVC: BaseVC , UITableViewDataSource , UITableViewDelegate {
    
    //_______________________________________________________________________________________________________________
    // 상단 테이블 관련
    let tableItem01_version = "최신버전입니다."
    let tableItem02_version = ""
    let tableItem03_version = ""
    
    let tableItem01_title = "버전정보"
    let tableItem02_title = "제작자"
    let tableItem03_title = "부록"
    
    let tableItem01_desc = "ver.1.2.4"
    let tableItem02_desc = "다윗쏭"
    let tableItem03_desc = ""
    
    var arrayOfETCItems : [EtcCellModel] = []
    
    
    
    
    
    
    
    
    
    //_______________________________________________________________________________________________________________
    // 하단 아이콘 관련
    
    let titleOfIcon01 = "고급 한태사전"
    let titleOfIcon02 = "들리는대로 한글로 찾는 태한사전"
    let titleOfIcon03 = "고급 태한사전"

    let iconImage01_kor_thai_n = "icon1_n"
    let iconImage02_thai_kor_p_n = "icon3_n"
    let iconImage03_thai_kor_t_n = "icon2_n"
    
    let iconImage01_kor_thai_p = "icon1_p"
    let iconImage02_thai_kor_p_p = "icon3_p"
    let iconImage03_thai_kor_t_p = "icon2_p"
    
    var arrayOfIconModels : [AppIconModel] = []
    

    @IBOutlet weak var separatorView: UIView!
    
    // 하단 아이콘 뷰 컨테이너
    @IBOutlet weak var bottomIconViewContainer: UIView!
    
    
    
    
    
    
    
    
    
    //________________________________________________________________________________________________________________________
    // 테이블 뷰 속 모델에 대한 구조
    class EtcCellModel
    {
        var title = ""
        var desc = ""
        var isArrowShow = false
        var versionText = ""
        
        init(title : String, desc : String, isArrowShow : Bool , versionText : String)
        {
            self.title = title
            self.desc = desc
            self.isArrowShow = isArrowShow
            self.versionText = versionText
        }
    }
    
    //________________________________________________________________________________________________________________________
    
    
    
    
    
    
    
    
    
    
    
    
    
    //________________________________________________________________________________________________________________________________________________
    // 초기화 로직
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initHeaderView()
        self.initTableData()
        
        separatorView.backgroundColor = ConstValue.color05_text_gray
        
        self.initBottomViews()
        
    }
    
    // 01 헤더
    override func initHeaderView()
    {
        super.initHeaderView()

        self.topTitleLabel.text = "기타"
        self.rightETCBtn.hidden = true
        
    }
    
    // 02 테이블
    func initTableData()
    {
        arrayOfETCItems.removeAll(keepCapacity: false)
        arrayOfETCItems.append(EtcCellModel(title: tableItem01_title, desc: tableItem01_desc, isArrowShow: false , versionText : tableItem01_version))
        arrayOfETCItems.append(EtcCellModel(title: tableItem02_title, desc: tableItem02_desc, isArrowShow: false , versionText : tableItem02_version))
        arrayOfETCItems.append(EtcCellModel(title: tableItem03_title, desc: tableItem03_desc, isArrowShow: true , versionText : tableItem03_version))
    }
    
    // 03 하단 아이콘 뷰
    func initBottomViews()
    {
        

        var title01 = ""
        var title02 = ""
        
        var iconImg01_n = ""
        var iconImg02_n = ""

        var iconImg01_p = ""
        var iconImg02_p = ""
        
        
        
        switch ConstValue.dic_mode
        {
        case 1:
            title01 = titleOfIcon02
            title02 = titleOfIcon03
            iconImg01_n = iconImage02_thai_kor_p_n
            iconImg01_p = iconImage02_thai_kor_p_p
            iconImg02_n = iconImage03_thai_kor_t_n
            iconImg02_p = iconImage03_thai_kor_t_p
            
            
        case 2:
            title01 = titleOfIcon01
            title02 = titleOfIcon03
            iconImg01_n = iconImage01_kor_thai_n
            iconImg01_p = iconImage01_kor_thai_p
            iconImg02_n = iconImage03_thai_kor_t_n
            iconImg02_p = iconImage03_thai_kor_t_p
            
        case 3:
            title01 = titleOfIcon01
            title02 = titleOfIcon02
            iconImg01_n = iconImage01_kor_thai_n
            iconImg01_p = iconImage01_kor_thai_p
            iconImg02_n = iconImage02_thai_kor_p_n
            iconImg02_p = iconImage02_thai_kor_p_p
            
        default:
            break
        }
        
        
        
        let oneModel = AppIconModel()
        oneModel.hwi_title = title01
        oneModel.hwi_image_noemal = UIImage(named: iconImg01_n)
        oneModel.hwi_image_pressed = UIImage(named: iconImg01_p)
        
        self.arrayOfIconModels.append(oneModel)
        
        let secondModel = AppIconModel()
        secondModel.hwi_title = title02
        secondModel.hwi_image_noemal = UIImage(named: iconImg02_n)
        secondModel.hwi_image_pressed = UIImage(named: iconImg02_p)

        self.arrayOfIconModels.append(secondModel)
        
        
        
        for (index, oneModel)  in enumerate(arrayOfIconModels)
        {
            let oneIcon = AppIconBtnView()
            oneIcon.initView()


            oneIcon.frame = CGRectMake( CGFloat(index * 70) , 20, 70, 70)
            
            oneIcon.setViews(oneModel.hwi_title, image_normal: oneModel.hwi_image_noemal!, image_pressed: oneModel.hwi_image_pressed!)
            
            self.bottomIconViewContainer.addSubview(oneIcon)

        }
        
        
    }
    //________________________________________________________________________________________________________________________________________________
    
    
    
    
    
    
    
    
    
    
    // 백버튼 터치 시 이전 화면으로 이동
    override func onBackBtnTouchUpInside(sender: UIButton) {
        super.onETCBtnTouchUpInside(sender)
        self.navigationController?.popViewControllerAnimated(true)
    }


    
    
    
    
    
    
    //________________________________________________________________________________________________________________________________________________________________________________
    // 테이블 뷰 Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayOfETCItems.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let oneCell = tableView.dequeueReusableCellWithIdentifier("ETCCell") as! ETCCell
        
        var oneData = arrayOfETCItems[indexPath.row]
        oneCell.hwi_title01.text = oneData.title
        oneCell.hwi_desc01.text = oneData.desc
        oneCell.hwi_title02.text = oneData.versionText
        
        if oneData.isArrowShow
        {
            oneCell.hwi_desc01.hidden = true
            oneCell.hwi_rightArrow01.hidden = false
        }
        else
        {
            oneCell.hwi_desc01.hidden = false
            oneCell.hwi_rightArrow01.hidden = true
        }
        
        return oneCell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == 2
        {
                self.performSegueWithIdentifier("seg_etc_detail", sender: self)
        }
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    //________________________________________________________________________________________________________________________________________________________________________________
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
