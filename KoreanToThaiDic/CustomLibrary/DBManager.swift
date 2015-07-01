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
    static let dbFilePath = NSBundle.mainBundle().pathForResource("KorThaiDictionary", ofType: "sqlite")!
    
    
    class func dbTest()
    {
        println("db 경로 : \(dbFilePath)")
        
        let db = Database(dbFilePath)
        
        let dic = db["KOR_THAI_DICTIONARY"]
        
        let KOREAN = Expression<String>("KOREAN")
        
        for word in dic
        {
            println("조회 테스트 : \(word[KOREAN])")
        }
        
    }
    
    
    
}

