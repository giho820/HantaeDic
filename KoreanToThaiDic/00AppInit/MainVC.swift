//
//  MainVC.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 1..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

protocol CustomTableViewDelegate
{
    func onTouchBegan(touches: Set<NSObject>, withEvent event: UIEvent)
}

class MainVC: BaseVC , UITextFieldDelegate , UITableViewDataSource , UITableViewDelegate , CustomTableViewDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var placeholderViewInSearchBar: UIView!
    @IBOutlet weak var labelInSearchTextField: UILabel!
    @IBOutlet weak var textFieldInSearchBar: UITextField!
    @IBOutlet weak var cancelBtnInSearchBar: UIButton!
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var tableViewInMain: CustomTableView!
    
    var originPositionXSearchBarIcon : CGFloat = 0
    var originSizeSearchBarWidth : CGFloat = 0

    

    @IBOutlet weak var detailScrollView: DetailScrollView!
    
    @IBOutlet weak var emptyContentView: UIView!
    
    
    var isSetOriginPositionXSearchBarIcon = false

    
    // 뷰 로드
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.detailScrollView.hidden = true
        self.cancelBtnInSearchBar.hidden = true

        // 뷰 초기화
        self.initHeaderView()
        self.initViews()
        
        self.tableViewInMain.customDelegate = self
        
        

        // 앱 실행된 후 디테일 뷰(커스텀 뷰) 초기화
        HWILib.delay(0.1, closure: { () -> () in
            
            self.detailScrollView.onViewDidLoad()
        })

        
    }
    
    
    
    @IBAction func onStartWriting(sender: UITextField)
    {
        println("onStartWriting")
        hideSearchBarPlaceHolder()
        setSearchMode()
    }
    
    
    
    /// 사용자가 키워드를 검색창에 입력시
    @IBAction func onWriting(sender: UITextField)
    {

        setSearchMode()
        hideSearchBarPlaceHolder()
        
        println("텍스트필드에서 사용자 입력값 : \(sender.text)")

        // iOS 7 버전에서는 onWriting 이 메소드가 비정상적으로 2번 호출된다.
        // '가능성' 이라고 텍스트를 적을 경우 '가능' , '가능성' 두개가 동시에 호출되어 문제가 발생한다.
        // 이에 0.1초 딜레이를 둔 후에 다시 텍스트를 검색해서 해당 텍스트와 마지막에 적은 텍스트가 일치할 경우에 검색을 시행한다.
        if HWILib.getCurrentOSVersion() < 8
        {
            var currentText = sender.text
            
            HWILib.delay(0.1, closure: { () -> () in
                
                if currentText == sender.text
                {
                    DBManager.getListFromWord(sender.text, callback: { () -> () in
                        
                        if sender.text == ""
                        {
                            self.emptyContentView.hidden = false
                        }
                        else
                        {
                            self.emptyContentView.hidden = true
                        }
                        self.tableViewInMain.reloadData()
                        
                    })

                }
            })
        
        }
        else
        {
            DBManager.getListFromWord(sender.text, callback: { () -> () in
                
                if sender.text == ""
                {
                    self.emptyContentView.hidden = false
                }
                else
                {
                    self.emptyContentView.hidden = true
                }
                self.tableViewInMain.reloadData()
                
            })
        }
        
        
        
    }
    
    @IBAction func didEndWriting(sender: UITextField)
    {
        println("didEndWriting")
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func onCancelInSearchBarBtnTouch(sender: UIButton)
    {
        self.textFieldInSearchBar.text = ""
        onWriting(self.textFieldInSearchBar)
    }
    
  
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func hideSearchBarPlaceHolder()
    {
        if !isSetOriginPositionXSearchBarIcon
        {
            self.originPositionXSearchBarIcon = self.placeholderViewInSearchBar.frame.origin.x
            self.originSizeSearchBarWidth = self.textFieldInSearchBar.frame.size.width
            isSetOriginPositionXSearchBarIcon = true
        }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.labelInSearchTextField.hidden = true
            self.placeholderViewInSearchBar.frame = CGRectMake(16, self.placeholderViewInSearchBar.frame.origin.y, self.placeholderViewInSearchBar.frame.size.width, self.placeholderViewInSearchBar.frame.size.height)
            
            self.textFieldInSearchBar.frame = CGRectMake(self.textFieldInSearchBar.frame.origin.x, self.textFieldInSearchBar.frame.origin.y,  self.originSizeSearchBarWidth - 73, self.textFieldInSearchBar.frame.size.height)
            
            self.cancelBtnInSearchBar.hidden = false
        })
        
    }
    
    
    func showSearchBarPlaceHolder()
    {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.labelInSearchTextField.hidden = false
            self.placeholderViewInSearchBar.frame = CGRectMake(self.originPositionXSearchBarIcon, self.placeholderViewInSearchBar.frame.origin.y, self.placeholderViewInSearchBar.frame.size.width, self.placeholderViewInSearchBar.frame.size.height)
            
            self.textFieldInSearchBar.frame = CGRectMake(self.textFieldInSearchBar.frame.origin.x, self.textFieldInSearchBar.frame.origin.y,  self.originSizeSearchBarWidth , self.textFieldInSearchBar.frame.size.height)
            
            self.cancelBtnInSearchBar.hidden = true
        })
    }
    

    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return DBManager.searchedItemArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let itemCell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemCell
        
        let oneItem = DBManager.searchedItemArray[indexPath.row]
        
        itemCell.label02_smallText.text = oneItem.THAI
        
        switch ConstValue.dic_mode
        {
        case 1:
            itemCell.label01_largeText.text = oneItem.KOREAN
        case 2:
            itemCell.label01_largeText.text = oneItem.PRONUNCIATION
        case 3:
            itemCell.label01_largeText.text = oneItem.THAI
            itemCell.label02_smallText.text = oneItem.KOREAN
        default:
            break
        }
        
        HWILib.setBoldSectionToLabel(itemCell.label01_largeText, keyword: self.textFieldInSearchBar.text)
        
        return itemCell
        
    }
    
    
    // 테이블 아이템 클릭 시 행동 정의 --> 디테일뷰 표시
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        println("셀 선택 테스트 : 인덱스 : \(indexPath)")
        
        let selectedItem = DBManager.searchedItemArray[indexPath.row]
        

        
        switch ConstValue.dic_mode
        {
        case 1:
            detailScrollView.label02_SmallLabel.text = selectedItem.KOREAN
            detailScrollView.label04_SmallLabel.text = selectedItem.THAI
            detailScrollView.label06_SmallLabel.text = selectedItem.PRONUNCIATION
        case 2:
            detailScrollView.label02_SmallLabel.text = selectedItem.PRONUNCIATION
            detailScrollView.label04_SmallLabel.text = selectedItem.THAI
            detailScrollView.label06_SmallLabel.text = selectedItem.KOREAN
        case 3:
            detailScrollView.label02_SmallLabel.text = selectedItem.THAI
            detailScrollView.label04_SmallLabel.text = selectedItem.KOREAN
            detailScrollView.label06_SmallLabel.text = selectedItem.PRONUNCIATION
        default:
            break
        }
        
        
        detailScrollView.arrangeLabelViews()
        setDetailViewMode()
        
    }
    
    // 메인 모드를 디테일 뷰 보기 모드로 변경
    func setDetailViewMode()
    {
        
        self.backButton.hidden = false
        detailScrollView.hidden = false
        
        self.textFieldInSearchBar.resignFirstResponder()
    }

    // 메인 모드를 검색 모드로 변경
    func setSearchMode()
    {
        self.backButton.hidden = true
        detailScrollView.hidden = true
        self.cancelBtnInSearchBar.hidden = false
    }
    
    

    
    
    // 백버튼 클릭 시 행동 정의
    override func onBackBtnTouchUpInside(sender: UIButton) {
        super.onBackBtnTouchUpInside(sender)
        
        if !detailScrollView.hidden
        {
            setSearchMode()
        }
    }
    
    

    // 터치 되었을 때 터치 전달
    func onTouchBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.touchesBegan(touches, withEvent: event)
    }
    
    // 스크롤 뷰 스크롤 시 키보드 내림
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        self.textFieldInSearchBar.resignFirstResponder()
    }

    
    // 기타 버튼 클릭 시 -> 기타 화면으로 이동
    override func onETCBtnTouchUpInside(sender: UIButton)
    {
        super.onETCBtnTouchUpInside(sender)
        self.performSegueWithIdentifier("main_etc_seg", sender: self)
    }

    
    
    
    
    //________________________________________________________________________
    // 초기화 함수
    
    func initViews()
    {
        switch ConstValue.dic_mode
        {
        case 1:
            self.searchBarView.backgroundColor = ConstValue.color07_main_blue
        case 2:
            self.searchBarView.backgroundColor = ConstValue.color13_main_green
        case 3:
            self.searchBarView.backgroundColor = ConstValue.color10_main_red
        default :
            break
        }
        

        self.labelInSearchTextField.textColor = ConstValue.color06_text_gray2
        self.cancelBtnInSearchBar.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        self.cancelBtnInSearchBar.setTitleColor(ConstValue.color01_white, forState: UIControlState.Normal)
        self.cancelBtnInSearchBar.setTitleColor(ConstValue.color05_text_gray, forState: UIControlState.Highlighted)
    }
    
    override func initHeaderView()
    {
        super.initHeaderView()
        self.backButton.hidden = true
        self.topTitleLabel.text = "단어검색"
    }
    
}
