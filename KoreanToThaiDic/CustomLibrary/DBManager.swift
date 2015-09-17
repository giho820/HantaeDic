//
//  DBManager.swift
//  KoreanToThaiDic
//
//  Created by jhkim on 2015. 6. 30..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//

import UIKit
//import SQLite


class DBManager
{
    static var dbFilePath : String?

    
    static var db : Database?

    static var dic : Query?

    
    static var IDX = Expression<Int64>("IDX")
    static var KOREAN = Expression<String>("KOREAN")
    static var THAI = Expression<String>("THAI")
    static var PRONUNCIATION = Expression<String>("PRONUNCIATION")
    static var SEARCH_KOREAN = Expression<String>("SEARCH_KOREAN")

    static let DBFILE_NAME = "DB.sqlite"
    
    
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
    
    
    class func loadBaseDB()
    {
        
        
        switch ConstValue.dic_mode
        {
        case 1:
            dbFilePath = NSBundle.mainBundle().pathForResource("KorThaiDictionary_SEARCH_K", ofType: "sqlite")!
        case 2:
            dbFilePath = NSBundle.mainBundle().pathForResource("ThaiKorDictionary_SEARCH_P", ofType: "sqlite")!
        case 3:
            dbFilePath = NSBundle.mainBundle().pathForResource("ThaiKorDictionary_SEARCH_T", ofType: "sqlite")!
        default:
            break
        }
        
        let destinationPath  = DBManager.hwi_getDocumentFolderPath().stringByAppendingPathComponent(DBManager.DBFILE_NAME)
        NSFileManager.defaultManager().copyItemAtPath(dbFilePath!, toPath: destinationPath, error: nil)
        
        if DBManager.hwi_getCurrentAppVersion() == 0
        {
            DBManager.hwi_setCurrentDBVersion(0.5)
        }
        
    }
    
    
    class func initDB()
    {
        
        dbFilePath = DBManager.hwi_getDocumentFolderPath().stringByAppendingPathComponent(DBManager.DBFILE_NAME)
        println("dbFilePath : \(dbFilePath)")
        switch ConstValue.dic_mode
        {
        case 1:
            db = Database(dbFilePath!)
            dic = db!["KOR_THAI_DICTIONARY"]
        case 2:
            db = Database(dbFilePath!)
            dic = db!["THAI_KOR_DICTIONARY"]
        case 3:
            db = Database(dbFilePath!)
            dic = db!["THAI_KOR_DICTIONARY"]
        default:
            break
        }
        
        println("DB 로드 완료")
        
    }
    
    

    
    
    
    class func getListFromWord(word : String , callback : ()->())
    {
        
        //________________________________________________________________________________________________
        // 속도 테스트 001 : DB 에서 검색 및 콜백 해줌   ---> 만약 메모리가 딸릴 경우 이거로 해야한다.
        
        println("전달받은 word : \(word)")
        
        var backgroundQueue : dispatch_queue_t?
        
        if HWILib.getCurrentOSVersion() < 8
        {
            let qualityOfServiceClass = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        }
        else
        {
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        }
        
        dispatch_async(backgroundQueue!, {
            println("This is run on the background queue")
            
            self.searchedItemArrayTemp.removeAll(keepCapacity: false)
            
            
            var searchedColumn = self.SEARCH_KOREAN
            
            switch ConstValue.dic_mode
            {
            case 1:
                searchedColumn = self.SEARCH_KOREAN
            case 2:
                searchedColumn = self.PRONUNCIATION
            case 3:
                searchedColumn = self.THAI
            default:
                break
            }
            

            
            // 검색 단어의 시작이 * 일 경우 와일드 카드 검색
            if count(word) > 1 && word.substringToIndex(advance(word.startIndex,1)) == "*"
            {
                // 한태사전에서 와일드카드 검색시에는 '괄호 안' 에 대한 내용도 검색하기 위해 컬럼을 self.KOREAN으로 변경
                if ConstValue.dic_mode == 1
                {
                    searchedColumn = self.KOREAN
                }
                
                let searchWord  = dropFirst(word)
                             for oneItem in self.dic!.filter(like("%\(searchWord)%", searchedColumn))
                {
                    var oneCellItem = DicModel()
                    self.setItemToObject(oneCellItem, oneItem: oneItem)
                    self.searchedItemArrayTemp.append(oneCellItem)
                }
                
            }
            // 일반적인 경우 -> 뒷부분 Like 검색
            else
            {
                var searchWord = word
                
                // 한태사전에서 일반 검색일 경우 whitespace 를 제거하고 검색!
                if ConstValue.dic_mode == 1
                {
                    searchWord = (word as NSString).stringByReplacingOccurrencesOfString(" ", withString: "")
                }
                
                for oneItem in self.dic!.filter(like( "\(searchWord)%", searchedColumn) )
                {
                    var oneCellItem = DicModel()
                    self.setItemToObject(oneCellItem, oneItem: oneItem)
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
        

        
    }
    
    
    
    class func setItemToObject(oneModel : DicModel , oneItem : Row)
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
            oneModel.PRONUNCIATION = oneItem[self.PRONUNCIATION]
        case 3:
            oneModel.SEARCH_KOREAN = oneItem[self.THAI]
        default:
            break
        }
        
    }
    
    class func hwi_getCurrentAppVersion()->Double
    {
        if let appVersion = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as? String
        {
            return (appVersion as NSString).doubleValue
        }

        return 0
    }
    
    class func hwi_getCurrentDBVersion() -> Double
    {
        let currentDBVersion = NSUserDefaults.standardUserDefaults().doubleForKey("currentDBVersion")
        
        return currentDBVersion
        
    }
    
    class func hwi_setCurrentDBVersion(version : Double)
    {
        NSUserDefaults.standardUserDefaults().setDouble(version, forKey: "currentDBVersion")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func hwi_getDocumentFolderPath()->String
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        return documentsPath
        
    }
    
}

