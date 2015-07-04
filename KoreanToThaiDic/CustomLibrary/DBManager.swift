//
//  DBManager.swift
//  KoreanToThaiDic
//
//  Created by jhkim on 2015. 6. 30..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import Foundation
import SQLite


class DBManager
{
    static let dbFilePath = NSBundle.mainBundle().pathForResource("KorThaiDictionary_SEARCH_K", ofType: "sqlite")!
    static let db = Database(dbFilePath)
    static let dic = db["KOR_THAI_DICTIONARY"]
    
    
    static let IDX = Expression<Int64>("IDX")
    static let KOREAN = Expression<String>("KOREAN")
    static let THAI = Expression<String>("THAI")
    static let PRONUNCIATION = Expression<String>("PRONUNCIATION")
    static let SEARCH_KOREAN = Expression<String>("SEARCH_KOREAN")
    
    
    static var searchedItemArray : [DicModel] = []
    static var searchedItemArrayTemp : [DicModel] = []
    
    static var allItemArray : [DicModel] = []
    
    
    class DicModel
    {
        var IDX : Int64 = 0
        var KOREAN : String = ""
        var THAI : String = ""
        var PRONUNCIATION : String = ""
        var SEARCH_KOREAN : String = ""
    }
    
    
    class func getAllList( callback : ()->())
    {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            println("This is run on the background queue")
            
            self.allItemArray.removeAll(keepCapacity: false)
            
            for oneItem in self.dic
            {
                
                var oneCellItem = DicModel()
                oneCellItem.IDX = oneItem[self.IDX]
                oneCellItem.KOREAN = oneItem[self.KOREAN]
                oneCellItem.THAI = oneItem[self.THAI]
                oneCellItem.PRONUNCIATION = oneItem[self.PRONUNCIATION]
                oneCellItem.SEARCH_KOREAN = oneItem[self.SEARCH_KOREAN]
                
                self.allItemArray.append(oneCellItem)
                
            }
            self.searchedItemArray = self.allItemArray
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println("This is run on the main queue, after the previous code in outer block")
                callback()
            })
        })
    }
    
    
    class func getListFromWord(word : String , callback : ()->())
    {
     
//________________________________________________________________________________________________
        // 속도 테스트 001 : DB 에서 검색 및 콜백 해줌   ---> 만약 메모리가 딸릴 경우 이거로 해야한다.
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            println("This is run on the background queue")
            
            self.searchedItemArrayTemp.removeAll(keepCapacity: false)

            for oneItem in self.dic.filter(like("%\(word)%", self.SEARCH_KOREAN))
            {
                
                var oneCellItem = DicModel()
                oneCellItem.IDX = oneItem[self.IDX]
                oneCellItem.KOREAN = oneItem[self.KOREAN]
                oneCellItem.THAI = oneItem[self.THAI]
                oneCellItem.PRONUNCIATION = oneItem[self.PRONUNCIATION]
                oneCellItem.SEARCH_KOREAN = oneItem[self.SEARCH_KOREAN]
                
                self.searchedItemArrayTemp.append(oneCellItem)
                
            }
            self.searchedItemArray = self.searchedItemArrayTemp
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println("This is run on the main queue, after the previous code in outer block")
                        callback()
            })
        })

//________________________________________________________________________________________________
        
        
        
//________________________________________________________________________________________________
        
        // 속도 테스트 002 : 처음에 전체 DB를 메모리에 올리고, 메모리에서 검색  --> 메모리가 넉넉할 경우 사용 -> 속도가 빠르다.
        /*
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            println("This is run on the background queue")
            
            self.searchedItemArrayTemp.removeAll(keepCapacity: false)
            
            
            for oneItem in self.allItemArray as [DicModel]
            {
                
                if oneItem.KOREAN.rangeOfString(word) != nil
                {
                    self.searchedItemArrayTemp.append(oneItem)
                }
                
            }
            
            self.searchedItemArray = self.searchedItemArrayTemp
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println("This is run on the main queue, after the previous code in outer block")
                callback()
            })
        })
        */
        
//________________________________________________________________________________________________
        
    }
    

    
    
    
}

