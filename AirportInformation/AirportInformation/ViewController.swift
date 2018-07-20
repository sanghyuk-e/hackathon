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
    
    
    var xmlparser = XMLParser()
    /*
     <items>
     <item>
     <datetm>20180720112558.336</datetm>
     <floor>T1 단기주차장지상층</floor>
     <parking>812</parking>
     <parkingarea>738</parkingarea>
     </item>
     </items>
     */
    
    
    var Items = [[String : String]]() // 영화 item Dictional Array
    var Item = [String: String]()     // 영화 item Dictionary
    //
    var currentDateandTime = "" // 영화 제목
    var parking = "" // 영화 내용
    var parkingarea = "" // 영화 내용
    
    
    var currentElement = ""
  
    
    func labelValue(canPaking: Int, label: UILabel) -> String{
        if Int(Items[canPaking]["parkingarea"]!)! - Int(Items[canPaking]["parking"]!)! > 0  {
            label.textColor = .black
            return "\(String(Int(Items[canPaking]["parkingarea"]!)! - Int(Items[canPaking]["parking"]!)!))대 가능"
        }else{
            return "만차"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestInformation()
        currentDateAndTime.text = Items[0]["datetm"]
//        let a = Items[0]["datetm"] as! String
//        let b =  a.index(a.startIndex, offsetBy: 9)
//        print(b)
        
        
        firstFloorPakingArea.text = labelValue(canPaking: 0, label: firstFloorPakingArea)
        b1FloorPakingArea.text = labelValue(canPaking: 1, label: b1FloorPakingArea)
        b2FloorPakingArea.text = labelValue(canPaking: 2, label: b2FloorPakingArea)
        b3FloorPakingArea.text = labelValue(canPaking: 3, label: b3FloorPakingArea)
        p1TowerPakingArea.text = labelValue(canPaking: 4, label: p1TowerPakingArea)
        p2TowerPakingArea.text = labelValue(canPaking: 5, label: p2TowerPakingArea)
        p1LongPakingArea.text = labelValue(canPaking: 6, label: p1LongPakingArea)
        p2LongPakingArea.text = labelValue(canPaking: 7, label: p2LongPakingArea)
        p3LongPakingArea.text = labelValue(canPaking: 8, label: p3LongPakingArea)
        p4LongPakingArea.text = labelValue(canPaking: 9, label: p4LongPakingArea)
 
    }
    
    
    func requestInformation(){
        let pakingInformationLink = "http://openapi.airport.kr/openapi/service/StatusOfParking/getTrackingParking?serviceKey=1QzzaKNZIuZ%2F1pWKrpJIgUJe%2BqdygocaGZWRRmysbwmCkbdp9o%2FZp9bduyxnFw%2F%2B1w6DUhs%2FPuAcb7KE1y1TWA%3D%3D&pageNo=1&startPage=1&numOfRows=10&pageSize=10"
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
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName  qName: String?){
        
        print("\n---------- [ didEndElement ] ----------\n")
        
        
        
        if (elementName == "item") {
            Item["datetm"] = currentDateandTime
            Item["parking"] = parking
            Item["parkingarea"] = parkingarea
            
            Items.append(Item)
            
            print(Items)
            
        }
        
    }
    
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String){
        
        print("\n---------- [ foundCharacters ] ----------\n")
        switch currentElement {
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
