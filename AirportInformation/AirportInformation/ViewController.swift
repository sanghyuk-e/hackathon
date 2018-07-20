//
//  ViewController.swift
//  AirportInformation
//
//  Created by kimdaeman14 on 2018. 7. 20..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//



import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var currentDateAndTime:UILabel!
    @IBOutlet weak var firstFloorPakingArea:UILabel!
    @IBOutlet weak var b1FloorPakingArea:UILabel!
    @IBOutlet weak var b2FloorPakingArea:UILabel!
    @IBOutlet weak var b3FloorPakingArea:UILabel!
    @IBOutlet weak var p1TowerPakingArea:UILabel!
    @IBOutlet weak var p2TowerPakingArea:UILabel!
    @IBOutlet weak var p1LongPakingArea:UILabel!
    @IBOutlet weak var p2LongPakingArea:UILabel!
    @IBOutlet weak var p3LongPakingArea:UILabel!
    @IBOutlet weak var p4LongPakingArea:UILabel!
    @IBAction private func reFreshButton(_ sender: UIBarButtonItem){
        Items.removeAll()
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
  
    
    func labelValue(canPaking: Int, label: UILabel) -> String{
        if Int(Items[canPaking]["parkingarea"]!)! - Int(Items[canPaking]["parking"]!)! > 0  {
            label.textColor = .black
            return "\(String(Int(Items[canPaking]["parkingarea"]!)! - Int(Items[canPaking]["parking"]!)!)) 대 가능"
        }else{
            return "만차"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestInformation()
        print(Items)
        currentDateAndTime.text = Items[0]["datetm"]
        firstFloorPakingArea.text = labelValue(canPaking: 0, label: firstFloorPakingArea)
        b1FloorPakingArea.text = labelValue(canPaking: 1, label: b1FloorPakingArea)
        b2FloorPakingArea.text = labelValue(canPaking: 2, label: b2FloorPakingArea)
        b3FloorPakingArea.text = labelValue(canPaking: 3, label: b3FloorPakingArea)
        p1TowerPakingArea.text = labelValue(canPaking: 7, label: p1TowerPakingArea)
        p2TowerPakingArea.text = labelValue(canPaking: 8, label: p2TowerPakingArea)
        p1LongPakingArea.text = labelValue(canPaking: 9, label: p1LongPakingArea)
        p2LongPakingArea.text = labelValue(canPaking: 10, label: p2LongPakingArea)
        p3LongPakingArea.text = labelValue(canPaking: 11, label: p3LongPakingArea)
        p4LongPakingArea.text = labelValue(canPaking: 12, label: p4LongPakingArea)
    }
    
    func requestInformation(){
        let pakingInformationLink = "http://openapi.airport.kr/openapi/service/StatusOfParking/getTrackingParking?serviceKey=1QzzaKNZIuZ%2F1pWKrpJIgUJe%2BqdygocaGZWRRmysbwmCkbdp9o%2FZp9bduyxnFw%2F%2B1w6DUhs%2FPuAcb7KE1y1TWA%3D%3D&pageNo=1&startPage=1&numOfRows=14&pageSize=10"
        let url = URL(string: pakingInformationLink)
        guard let xmlparser = XMLParser(contentsOf: url!) else {return}
        xmlparser.delegate = self
        xmlparser.parse() //이건 뭔지 모르겠군?
    }
    
}


extension ViewController : XMLParserDelegate {
    
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
