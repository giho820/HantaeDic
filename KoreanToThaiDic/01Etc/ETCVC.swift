//
//  ETCVC.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 4..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

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
    
    let titleOfIcon01 = "고급 태한사전"
    let titleOfIcon02 = "들리는대로 한글로 찾는 태한사전"
    
    let imageOfIcon01_normal = "icon2_n"
    let imageOfIcon01_pressed = "icon2_p"
    let imageOfIcon02_normal = "icon3_n"
    let imageOfIcon02_pressed = "icon3_p"

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
        let oneModel = AppIconModel()
        oneModel.hwi_title = titleOfIcon01
        oneModel.hwi_image_noemal = UIImage(named: "icon2_n")
        oneModel.hwi_image_pressed = UIImage(named: "icon2_p")
        
        self.arrayOfIconModels.append(oneModel)
        
        let secondModel = AppIconModel()
        secondModel.hwi_title = titleOfIcon02
        secondModel.hwi_image_noemal = UIImage(named: "icon3_n")
        secondModel.hwi_image_pressed = UIImage(named: "icon3_p")

        
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
    //________________________________________________________________________________________________________________________________________________________________________________
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
