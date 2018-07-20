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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestInformation()
        currentDateAndTime.text = Items[0]["datetm"]
        
        firstFloorPakingArea.text = Int(Items[0]["parkingarea"]!)! - Int(Items[0]["parking"]!)! > 0 ? "\(String(Int(Items[0]["parkingarea"]!)! - Int(Items[0]["parking"]!)!))대 가능": "만차"
        b1FloorPakingArea.text = Int(Items[1]["parkingarea"]!)! - Int(Items[1]["parking"]!)! > 0 ? "\(String(Int(Items[1]["parkingarea"]!)! - Int(Items[1]["parking"]!)!))대 가능": "만차"
        b2FloorPakingArea.text = Int(Items[2]["parkingarea"]!)! - Int(Items[2]["parking"]!)! > 0 ? "\(String(Int(Items[2]["parkingarea"]!)! - Int(Items[2]["parking"]!)!))대 가능": "만차"
        b3FloorPakingArea.text = Int(Items[3]["parkingarea"]!)! - Int(Items[3]["parking"]!)! > 0 ? "\(String(Int(Items[3]["parkingarea"]!)! - Int(Items[3]["parking"]!)!))대 가능": "만차"
        p1TowerPakingArea.text = Int(Items[4]["parkingarea"]!)! - Int(Items[4]["parking"]!)! > 0 ? "\(String(Int(Items[4]["parkingarea"]!)! - Int(Items[4]["parking"]!)!))대 가능": "만차"
        p2TowerPakingArea.text = Int(Items[5]["parkingarea"]!)! - Int(Items[5]["parking"]!)! > 0 ? "\(String(Int(Items[5]["parkingarea"]!)! - Int(Items[5]["parking"]!)!))대 가능": "만차"
        p1LongPakingArea.text = Int(Items[6]["parkingarea"]!)! - Int(Items[6]["parking"]!)! > 0 ? "\(String(Int(Items[6]["parkingarea"]!)! - Int(Items[6]["parking"]!)!))대 가능": "만차"
        p2LongPakingArea.text = Int(Items[7]["parkingarea"]!)! - Int(Items[7]["parking"]!)! > 0 ? "\(String(Int(Items[7]["parkingarea"]!)! - Int(Items[7]["parking"]!)!))대 가능": "만차"
        p3LongPakingArea.text = Int(Items[8]["parkingarea"]!)! - Int(Items[8]["parking"]!)! > 0 ? "\(String(Int(Items[8]["parkingarea"]!)! - Int(Items[8]["parking"]!)!))대 가능": "만차"
        p4LongPakingArea.text = Int(Items[9]["parkingarea"]!)! - Int(Items[9]["parking"]!)! > 0 ? "\(String(Int(Items[9]["parkingarea"]!)! - Int(Items[9]["parking"]!)!))대 가능": "만차"
        //
        //
        //        b1FloorPakingArea.text = String(Int(Items[1]["parkingarea"]!)! - Int(Items[1]["parking"]!)!)
        //        b2FloorPakingArea.text = String(Int(Items[2]["parkingarea"]!)! - Int(Items[2]["parking"]!)!)
        //        b3FloorPakingArea.text = String(Int(Items[3]["parkingarea"]!)! - Int(Items[3]["parking"]!)!)
        //        p1TowerPakingArea.text = String(Int(Items[4]["parkingarea"]!)! - Int(Items[4]["parking"]!)!)
        //        p2TowerPakingArea.text = String(Int(Items[5]["parkingarea"]!)! - Int(Items[5]["parking"]!)!)
        //        p1LongPakingArea.text = String(Int(Items[6]["parkingarea"]!)! - Int(Items[6]["parking"]!)!)
        //        p2LongPakingArea.text = String(Int(Items[7]["parkingarea"]!)! - Int(Items[7]["parking"]!)!)
        //        p3LongPakingArea.text = String(Int(Items[8]["parkingarea"]!)! - Int(Items[8]["parking"]!)!)
        //        p4LongPakingArea.text = String(Int(Items[9]["parkingarea"]!)! - Int(Items[9]["parking"]!)!)
        //
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
