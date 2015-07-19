//
//  ETCDetailWebVC.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 19..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit

class ETCSupplementListVC: BaseVC , UITableViewDataSource , UITableViewDelegate{

    

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initHeaderView()
        
    }

    
    override func initHeaderView()
    {
        super.initHeaderView()
        
        self.topTitleLabel.text = ""
        self.backButton.setTitle("부록", forState: UIControlState.Normal)
        self.rightETCBtn.hidden = true
        
    }
    
    
    override func onBackBtnTouchUpInside(sender: UIButton)
    {
        super.onBackBtnTouchUpInside(sender)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //__________________________________________________________________________________________
    // 테이블 뷰 Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ConstValue.arrayOfSupplementTableTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SupplementCell") as! SupplementCell

        cell.hwi_labelOfTitleCell.text = ConstValue.arrayOfSupplementTableTitles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
            self.performSegueWithIdentifier("seg_etclist_etcdetail", sender: indexPath.row)
    }
    
    // 테이블 뷰 Delegate
    //__________________________________________________________________________________________
 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "seg_etclist_etcdetail"
        {
            let supplementVC = segue.destinationViewController as! SupplementDetailVC
            supplementVC.currentIndex = sender as! Int
            supplementVC.titleOfTop = ConstValue.arrayOfSupplementTableTitles[sender as! Int]
        }
    }
}
