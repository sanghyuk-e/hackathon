//
//  ViewController.swift
//  IncheonAirport
//
//  Created by sanghyuk on 2018. 7. 20..
//  Copyright © 2018년 sanghyuk. All rights reserved.
//

import UIKit

class SecondTerminalViewController: UIViewController, XMLParserDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var short1FLable: UILabel!
    @IBOutlet private weak var shortBMLable: UILabel!
    @IBOutlet private weak var shortB1Lable: UILabel!
    @IBOutlet private weak var longP1Lable: UILabel!

    @IBOutlet private weak var refreshTime: UILabel!

    @IBAction private func refreshButton(_ sender: Any) {
        parkingSpaces.removeAll()
        parkingSpace.removeAll()
        requestMovieInfo()
        mappingParkingArea()
    }
    
    
    var xmlParser = XMLParser()
    
    var currentElement = ""                // 현재 Element
    var parkingSpaces = [[String : String]]() // 주차장 Dictional Array
    
    var parkingSpace = [String: String]()     // 주차장 Dictionary
    
    var datetm = "" // 갱신 시간
    var floor = ""  // 주차 구역 이름
    var parking = ""    // 주차된 차량 수
    var parkingarea = ""    // 주차장 공간 수 (고정 값)
    
    var year = ""
    var month = ""
    var day = ""
    var hour = ""
    var minute = ""
    
    func requestMovieInfo() {
        // OPEN API 주소
        let url = "http://openapi.airport.kr/openapi/service/StatusOfParking/getTrackingParking?serviceKey=1b5aEl3mNADl6xTbBpPZ5nxAhIbUMG%2FA3sOd8VhYij9lGQmihqH8jYh%2FLvqEjPhuZ%2BKbKNpd990YQr3TiME07A%3D%3D&pageNo=1&startPage=1&numOfRows=14&pageSize=10"
        
        guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else { return }
        
        xmlParser.delegate = self;
        xmlParser.parse()
        
        print("\n---------- [ Data Load Success ] ----------\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n---------- [ view Did Load ] ----------\n")
        requestMovieInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\n---------- [ will appear ] ----------\n")
        
        // 제2여객터미널
        print(parkingSpaces[4]) // 단기주차장지상1층
        print(parkingSpaces[5]) // 단기주차장지하M층
        print(parkingSpaces[6]) // 단기주차장지하1층
        print(parkingSpaces[13])    // 장기 주차장
        
        mappingParkingArea()
        
    }
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "item") {
            parkingSpace = [String : String]()
            datetm = ""
            floor = ""
            parking = ""
            parkingarea = ""
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            parkingSpace["datetm"] = datetm
            parkingSpace["floor"] = floor
            parkingSpace["parking"] = parking
            parkingSpace["parkingarea"] = parkingarea
            
            parkingSpaces.append(parkingSpace)
            
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (currentElement == "datetm") {
            datetm = string
        } else if (currentElement == "floor") {
            floor = string
        } else if (currentElement == "parking") {
            parking = string
        } else if (currentElement == "parkingarea") {
            parkingarea = string
        }
    }
    
    // MARK: - mappingParkingArea
    public func mappingParkingArea() {
        // 시간 계산
        let str: String = parkingSpaces[0]["datetm"]!
        let yearStartIndex = str.index(str.startIndex, offsetBy: 0)
        let yearEndIndex = str.index(yearStartIndex, offsetBy: 4)
        
        let monthStartIndex = str.index(yearEndIndex, offsetBy: 0)
        let monthEndIndex = str.index(monthStartIndex, offsetBy: 2)
        
        let dayStartIndex = str.index(monthEndIndex, offsetBy: 0)
        let dayEndIndex = str.index(dayStartIndex, offsetBy: 2)
        
        let hourStartIndex = str.index(dayEndIndex, offsetBy: 0)
        let hourEndIndex = str.index(hourStartIndex, offsetBy: 2)
        
        let minuteStartIndex = str.index(hourEndIndex, offsetBy: 0)
        let minuteEndIndex = str.index(minuteStartIndex, offsetBy: 2)
        
        year = String(str[yearStartIndex..<yearEndIndex])
        month = String(str[monthStartIndex..<monthEndIndex])
        day = String(str[dayStartIndex..<dayEndIndex])
        hour = String(str[hourStartIndex..<hourEndIndex])
        minute = String(str[minuteStartIndex..<minuteEndIndex])
        
        // 갱신 시간 출력
        refreshTime.text = year + "년 " + month + "월 " + day + "일 " + hour + "시 "  + minute + "분"
        
        // 단기 주차장 지상층
        if Int(parkingSpaces[4]["parkingarea"]!)! - Int(parkingSpaces[4]["parking"]!)! > 0 {
            short1FLable.text = String(Int(parkingSpaces[4]["parkingarea"]!)! - Int(parkingSpaces[4]["parking"]!)!) + " 대 가능"
            short1FLable.textColor = .black
        } else {
            short1FLable.text = "만차"
            short1FLable.textColor = .red
        }
        
        // 단기 주차장 지하 1층
        if Int(parkingSpaces[5]["parkingarea"]!)! - Int(parkingSpaces[5]["parking"]!)! > 0 {
            shortBMLable.text = String(Int(parkingSpaces[5]["parkingarea"]!)! - Int(parkingSpaces[5]["parking"]!)!) + " 대 가능"
            shortBMLable.textColor = .black
        } else {
            shortBMLable.text = "만차"
            shortBMLable.textColor = .red
        }
        
        // 단기 주차장 지하 2층
        if Int(parkingSpaces[6]["parkingarea"]!)! - Int(parkingSpaces[6]["parking"]!)! > 0 {
            shortB1Lable.text = String(Int(parkingSpaces[6]["parkingarea"]!)! - Int(parkingSpaces[6]["parking"]!)!) + " 대 가능"
            shortB1Lable.textColor = .black
        } else {
            shortB1Lable.text = "만차"
            shortB1Lable.textColor = .red
        }
        
        // 단기 주차장 지하 3층
        if Int(parkingSpaces[13]["parkingarea"]!)! - Int(parkingSpaces[13]["parking"]!)! > 0 {
            longP1Lable.text = String(Int(parkingSpaces[13]["parkingarea"]!)! - Int(parkingSpaces[13]["parking"]!)!) + " 대 가능"
            longP1Lable.textColor = .black
        } else {
            longP1Lable.text = "만차"
            longP1Lable.textColor = .red
        }
        
        
        
        print("\n---------- [ Mapping Success ] ----------\n")
        print("time : ", parkingSpaces[0]["datetm"]!)
        print(parkingSpaces.count)
        
    }
    
    
}

