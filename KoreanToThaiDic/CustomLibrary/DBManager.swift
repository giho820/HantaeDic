//
//  DBManager.swift
//  KoreanToThaiDic
//
//  Created by jhkim on 2015. 6. 30..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit



class DBManager
{
    static var dbFilePath = NSBundle.mainBundle().pathForResource("KorThaiDictionary_SEARCH_K", ofType: "sqlite")!
    
    
    static var db = Database(dbFilePath)
    static var dic = db["KOR_THAI_DICTIONARY"]
    
    
    static var IDX = Expression<Int64>("IDX")
    static var KOREAN = Expression<String>("KOREAN")
    static var THAI = Expression<String>("THAI")
    static var PRONUNCIATION = Expression<String>("PRONUNCIATION")
    static var SEARCH_KOREAN = Expression<String>("SEARCH_KOREAN")
    static var SEARCH_PRONUNCIATION = Expression<String>("SEARCH_PRONUNCIATION")
    
    
    
    static var searchedItemArray : [DicModel] = []
    static var searchedItemArrayTemp : [DicModel] = []
    
    static var allItemArray : [DicModel] = []
    
    
    
    
    class func initDB()
    {
        switch ConstValue.dic_mode
        {
        case 1:
            dbFilePath = NSBundle.mainBundle().pathForResource("KorThaiDictionary_SEARCH_K", ofType: "sqlite")!
            db = Database(dbFilePath)
            dic = db["KOR_THAI_DICTIONARY"]
        case 2:
            dbFilePath = NSBundle.mainBundle().pathForResource("ThaiKorDictionary_SEARCH_P", ofType: "sqlite")!
            db = Database(dbFilePath)
            dic = db["THAI_KOR_DICTIONARY"]
        case 3:
            dbFilePath = NSBundle.mainBundle().pathForResource("ThaiKorDictionary_SEARCH_T", ofType: "sqlite")!
            db = Database(dbFilePath)
            dic = db["THAI_KOR_DICTIONARY"]
        default:
            break
        }
    }
    
    
    
    class DicModel
    {
        var IDX : Int64 = 0
        var KOREAN : String = ""
        var THAI : String = ""
        var PRONUNCIATION : String = ""
        var SEARCH_KOREAN : String = ""
        var SEARCH_PRONUNCIATION : String = ""
        
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
            
            
            var searchedColumn = self.SEARCH_KOREAN
            
            switch ConstValue.dic_mode
            {
            case 1:
                searchedColumn = self.SEARCH_KOREAN
            case 2:
                searchedColumn = self.SEARCH_PRONUNCIATION
            case 3:
                searchedColumn = self.THAI
            default:
                break
            }
            
            // 검색 단어의 시작이 * 일 경우 와일드 카드 검색
            if count(word) > 1 && word.substringToIndex(advance(word.startIndex,1)) == "*"
            {
                let searchWord  = dropFirst(word)
                for oneItem in self.dic.filter(like("%\(searchWord)%", searchedColumn))
                {
                    var oneCellItem = DicModel()
                    self.setItemToObject(oneCellItem, oneItem: oneItem, searchKeyword: word)
                    self.searchedItemArrayTemp.append(oneCellItem)
                }
            }
            else
            {
                // 일반적인 경우 -> 뒷부분 Like 검색
                for oneItem in self.dic.filter(like( "\(word)%", searchedColumn) )
                {
                    var oneCellItem = DicModel()
                    self.setItemToObject(oneCellItem, oneItem: oneItem, searchKeyword: word)
                    self.searchedItemArrayTemp.append(oneCellItem)
                }
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
    
    
    
    class func setItemToObject(oneModel : DicModel , oneItem : Row , searchKeyword : String)
    {
        oneModel.IDX = oneItem[self.IDX]
        oneModel.KOREAN = oneItem[self.KOREAN]
        oneModel.THAI = oneItem[self.THAI]
        oneModel.PRONUNCIATION = oneItem[self.PRONUNCIATION]
        
        /*
        한태 사전 -> 검색한 한국어 부분에 bold 처리
        들리는대로 태한사전 -> 검색한 한국어 부분에 bold 처리
        태한 사전 -> 검색한 태국어 부분에 bold 처리
        */
        switch ConstValue.dic_mode
        {
        case 1:
            oneModel.SEARCH_KOREAN = oneItem[self.SEARCH_KOREAN]
        case 2:
            oneModel.SEARCH_PRONUNCIATION = oneItem[self.SEARCH_PRONUNCIATION]
        case 3:
            oneModel.SEARCH_KOREAN = oneItem[self.THAI]
        default:
            break
        }
        
    }
    
    
    
}

