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
    
    
    
    var isSetOriginPositionXSearchBarIcon = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.detailScrollView.hidden = true
        self.cancelBtnInSearchBar.hidden = true
        self.initHeaderView()
        self.initViews()
        
        self.tableViewInMain.customDelegate = self
        
        
        
        HWILib.showActivityIndicator(self)
        
        DBManager.getAllList { () -> () in
            self.tableViewInMain.reloadData()
            HWILib.hideActivityIndicator()
        }
        

        
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
    
    @IBAction func onWriting(sender: UITextField)
    {
        println("onWriting")
        setSearchMode()
        
        if sender.text == ""
        {
            DBManager.searchedItemArray = DBManager.allItemArray
            self.tableViewInMain.reloadData()
        }
        else
        {
            hideSearchBarPlaceHolder()
            
            DBManager.getListFromWord(sender.text, callback: { () -> () in
                
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
    
    func initViews()
    {
        self.searchBarView.backgroundColor = ConstValue.color07_main_blue
        self.labelInSearchTextField.textColor = ConstValue.color06_text_gray2
        self.cancelBtnInSearchBar.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        self.cancelBtnInSearchBar.setTitleColor(ConstValue.color01_white, forState: UIControlState.Normal)
        self.cancelBtnInSearchBar.setTitleColor(ConstValue.color05_text_gray, forState: UIControlState.Highlighted)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return DBManager.searchedItemArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let itemCell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemCell
        
        let oneItem = DBManager.searchedItemArray[indexPath.row]
        
        itemCell.label01_largeText.text = oneItem.KOREAN
        itemCell.label02_smallText.text = oneItem.THAI
        
        return itemCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        println("셀 선택 테스트 : 인덱스 : \(indexPath)")
        
        let selectedItem = DBManager.searchedItemArray[indexPath.row]
        detailScrollView.label02_SmallLabel.text = selectedItem.KOREAN
        detailScrollView.label04_SmallLabel.text = selectedItem.THAI
        detailScrollView.label06_SmallLabel.text = selectedItem.PRONUNCIATION
        detailScrollView.arrangeLabelViews()
        setDetailViewMode()

    }
    
    func setDetailViewMode()
    {
        
        self.backButton.hidden = false
        detailScrollView.hidden = false

        self.textFieldInSearchBar.resignFirstResponder()
    }
    
    func setSearchMode()
    {
        self.backButton.hidden = true
        detailScrollView.hidden = true
        self.cancelBtnInSearchBar.hidden = false
    }
    
    override func initHeaderView() {
        super.initHeaderView()
        self.backButton.hidden = true
        self.topTitleLabel.text = "단어검색"
        
    }
    
    override func onBackBtnTouchUpInside(sender: UIButton) {
        super.onBackBtnTouchUpInside(sender)
        
        if !detailScrollView.hidden
        {
            setSearchMode()
        }
    }
    
    func onTouchBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.touchesBegan(touches, withEvent: event)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        self.textFieldInSearchBar.resignFirstResponder()
    }
    
    override func onETCBtnTouchUpInside(sender: UIButton)
    {
        super.onETCBtnTouchUpInside(sender)
        self.performSegueWithIdentifier("main_etc_seg", sender: self)
    }
    
}
