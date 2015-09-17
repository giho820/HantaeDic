//
//  ConstValue.swift
//  KoreanToThaiDic
//
//  Created by KimJeonghwi on 2015. 7. 1..
//  Copyright (c) 2015년 smallhouse. All rights reserved.
//



/*
사전 모드 변경 가이드


1. Project Root 의 Target 의 general 탭에서 app Icon 변경
2. Project Root 의 Target 의 Info 탭에서 (Bundle Identifier, Bundle Display name ) 변경
3. ConstValues 에 dic_mode 변수 변경
4. LaunchScreen.xib 에서 런치 스크린 변경

*/



import UIKit

class ConstValue {
    
    // dic_mode  = 사전 모드
    /*
        1 : 고급 한태사전
        2 : 들리는대로 한글로 찾는 태한사전
        3 : 고급 태한사전
    */
    static let dic_mode = 3
    
    static let url00_versionCheck = "http://hyojoong2.cafe24.com/hante/mobile/selectServiceInfo.php?OS=i"
    
    static let arrayOfSupplementTableTitles =
    [
        "부록 1. 태국어 자음과 모음",
        "부록 2. 성조 규칙",
        "부록 3. 성조 연습",
        "부록 4. 한글 읽고 쓰기"
    ]
    
    
    // 서버 통신을 통해 하기 URL 은 변경되므로 의미가 없음
    static var url01_HantaeDic = "http://www.google.com"
    static var url02_ListenTaeHanDic = "http://www.naver.com"
    static var url03_TaehanDic = "http://www.daum.net"
    
    
    static let color01_white = HWILib.colorWIthRGB(255, green: 255, blue: 255, alpha: 1)
    static let color02_black = HWILib.colorWIthRGB(0, green: 0, blue: 0, alpha: 1)
    static let color03_card_gray = HWILib.colorWIthRGB(249, green: 249, blue: 249, alpha: 1)
    static let color04_card_gray2 = HWILib.colorWIthRGB(238, green: 238, blue: 238, alpha: 1)
    static let color05_text_gray = HWILib.colorWIthRGB(204, green: 204, blue: 204, alpha: 1)
    static let color06_text_gray2 = HWILib.colorWIthRGB(143, green: 142, blue: 148, alpha: 1)
    static let color07_main_blue = HWILib.colorWIthRGB(62, green: 131, blue: 237, alpha: 1)
    static let color08_sub_blue1 = HWILib.colorWIthRGB(57, green: 116, blue: 212, alpha: 1)
    static let color09_sub_blue2 = HWILib.colorWIthRGB(217, green: 232, blue: 253, alpha: 1)
    static let color10_main_red = HWILib.colorWIthRGB(223, green: 55, blue: 66, alpha: 1)
    static let color11_sub_red1 = HWILib.colorWIthRGB(206, green: 38, blue: 49, alpha: 1)
    static let color12_sub_red2 = HWILib.colorWIthRGB(253, green: 229, blue: 229, alpha: 1)
    static let color13_main_green = HWILib.colorWIthRGB(0, green: 231, blue: 165, alpha: 1)
    static let color14_sub_green1 = HWILib.colorWIthRGB(0, green: 204, blue: 140, alpha: 1)
    static let color15_sub_green2 = HWILib.colorWIthRGB(224, green: 250, blue: 241, alpha: 1)
    

    
}