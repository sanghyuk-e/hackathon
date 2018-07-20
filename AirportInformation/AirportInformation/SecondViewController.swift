//
//  SecondViewController.swift
//  AirportInformation
//
//  Created by kimdaeman14 on 2018. 7. 20..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var t2currentDateAndTime:UILabel!
    @IBOutlet weak var t2firstFloorPakingArea:UILabel!
    @IBOutlet weak var t2BMFloorPakingArea:UILabel!
    @IBOutlet weak var t2B1FloorPakingArea:UILabel!
    @IBOutlet weak var t2longFloorPakingArea:UILabel!
    @IBAction private func reFreshButton(_ sender: UIBarButtonItem){
        Items.removeAll()
        requestInformation()
        updateLable()
        print(Items)
        
    }
    
    var xmlparser = XMLParser()
    var Items = [[String : String]]()
    var Item = [String: String]()
    var currentDateandTime = ""
    var parking = ""
    var parkingarea = ""
    var floor = ""
    var currentElement = ""
    
    var year = ""
    var month = ""
    var day = ""
    var hour = ""
    var minute = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestInformation()
        updateLable()
        print(Items)
        
        
    }
    
    func labelValue(canPaking: Int, label: UILabel) -> String{
        if Int(Items[canPaking]["parkingarea"]!)! - Int(Items[canPaking]["parking"]!)! > 0  {
            label.textColor = .black
            return "\(String(Int(Items[canPaking]["parkingarea"]!)! - Int(Items[canPaking]["parking"]!)!)) 대 가능"
        }else{
            return "만차"
        }
    }
    
    
    func currentDateAndTime(){
        let str: String = Items[0]["datetm"]!
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
        t2currentDateAndTime.text = "updating... " + year + "." + month + "." + day + " " + hour + ":"  + minute
    }
    
    func updateLable(){
        currentDateAndTime()
        t2firstFloorPakingArea.text = labelValue(canPaking: 4, label: t2firstFloorPakingArea)
        t2BMFloorPakingArea.text = labelValue(canPaking: 5, label: t2BMFloorPakingArea)
        t2B1FloorPakingArea.text = labelValue(canPaking: 6, label: t2B1FloorPakingArea)
        t2longFloorPakingArea.text = labelValue(canPaking: 13, label: t2longFloorPakingArea)
    }
    
    
    
    func requestInformation(){
        let pakingInformationLink = "http://openapi.airport.kr/openapi/service/StatusOfParking/getTrackingParking?serviceKey=1QzzaKNZIuZ%2F1pWKrpJIgUJe%2BqdygocaGZWRRmysbwmCkbdp9o%2FZp9bduyxnFw%2F%2B1w6DUhs%2FPuAcb7KE1y1TWA%3D%3D&pageNo=1&startPage=1&numOfRows=14&pageSize=10"
        let url = URL(string: pakingInformationLink)
        guard let xmlparser = XMLParser(contentsOf: url!) else {return}
        xmlparser.delegate = self
        xmlparser.parse() //이건 뭔지 모르겠군?
    }
    
}


extension SecondViewController : XMLParserDelegate {
    
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]){
        
        print("\n---------- [ didStartElement ] ----------\n")
        
        //
        currentElement = elementName
        if (elementName == "item") {
            Item = [String : String]()
            currentDateandTime = ""
            parking = ""
            parkingarea = ""
            floor = ""
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName  qName: String?){
        
        print("\n---------- [ didEndElement ] ----------\n")
        
        if (elementName == "item") {
            Item["floor"] = floor
            Item["datetm"] = currentDateandTime
            Item["parking"] = parking
            Item["parkingarea"] = parkingarea
            
            Items.append(Item)
            
            //            print(Items)
            
        }
        
    }
    
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String){
        
        print("\n---------- [ foundCharacters ] ----------\n")
        switch currentElement {
        case "floor":
            floor = string
        case "datetm":
            currentDateandTime = string
        case "parking":
            parking = string
        case "parkingarea":
            parkingarea = string
        default:
            print("fail")
        }
        
        
        
        
    }
    
    
    
}
