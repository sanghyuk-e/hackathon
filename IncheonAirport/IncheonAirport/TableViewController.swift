//
//  ViewController.swift
//  IncheonAirport
//
//  Created by sanghyuk on 2018. 7. 20..
//  Copyright © 2018년 sanghyuk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var short1FLable: UILabel!
    @IBOutlet private weak var shortB1Lable: UILabel!
    @IBOutlet private weak var shortB2Lable: UILabel!
    @IBOutlet private weak var shortB3Lable: UILabel!
    @IBOutlet private weak var towerP1Lable: UILabel!
    @IBOutlet private weak var towerP2Lable: UILabel!
    @IBOutlet private weak var longP1Lable: UILabel!
    @IBOutlet private weak var longP2Lable: UILabel!
    @IBOutlet private weak var longP3Lable: UILabel!
    @IBOutlet private weak var longP4Lable: UILabel!
    @IBOutlet private weak var refreshTime: UILabel!
    
    @IBAction private func refreshButton(_ sender: Any) {
        requestAirPlaneInfo()
    }
    
    
    var xmlParser = XMLParser()
    
    var currentElement = ""                // 현재 Element
    var items = [[String : String]]()
    var item = [String: String]()

    var airline = ""    // 항공사
    var airport = ""    // 출발지 공항
    var airportCode = ""    // 공항 코드
    var carousel = ""   // 수하물수취대
    var estimatedDateTime = ""  // 변경시간
    var exitnumber = "" // 출구
    var flightId = ""   // 편명
    var gatenumber = "" // 탑승구
    var himidity = ""   // 습도
    var maxtem = "" // 최고기온
    var mintem = "" // 최저기온
    var remark = "" // 현황
    var scheduleDateTime = ""   // 예정시간
    var terminalid = "" // 터미널 구분
    var wimage = "" // 날씨 이미지 경로
    var wind = ""   // 풍속
    var yoil = ""   // 날씨표출요일
    
    
    var year = ""
    var month = ""
    var day = ""
    var hour = ""
    var minute = ""
    
//    var date = Date()
//    let calendar = Calendar(identifier: .gregorian)

    
    func requestAirPlaneInfo() {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        print(components)
        year = String(components.year!)
        month = String(components.month!)
        day = String(components.day!)
        hour = String(components.hour!)
        minute = String(components.minute!)
        
        navigationItem.title = year + "년 " + month + "월 " + day + "일 " + hour + "시 " + minute + "분"
        
        
        // OPEN API 주소
        let url = "http://openapi.airport.kr/openapi/service/StatusOfPassengerWeahter/getPassengerArrivalsW?serviceKey=1b5aEl3mNADl6xTbBpPZ5nxAhIbUMG%2FA3sOd8VhYij9lGQmihqH8jYh%2FLvqEjPhuZ%2BKbKNpd990YQr3TiME07A%3D%3D&pageNo=1&startPage=1&numOfRows=1000&pageSize=10&from_time=" + hour + minute + "&to_time=2400&lang=K"
        
        guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else { return }
        
        xmlParser.delegate = self;
        xmlParser.parse()
        
        print("\n---------- [ Data Load Success ] ----------\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n---------- [ view Did Load ] ----------\n")
        requestAirPlaneInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\n---------- [ will appear ] ----------\n")
        
    }
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "item") {
            item = [String : String]()
            
            airline = ""
            airport = ""
            airportCode = ""
            carousel = ""
            estimatedDateTime = ""
            exitnumber = ""
            flightId = ""
            gatenumber = ""
            himidity = ""
            maxtem = ""
            mintem = ""
            remark = ""
            scheduleDateTime = ""
            terminalid = ""
            wimage = ""
            wind = ""
            yoil = ""
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            
            item["airline"] = airline
            item["airport"] = airport
            item["airportCode"] = airportCode
            item["carousel"] = carousel
            item["estimatedDateTime"] = estimatedDateTime
            item["exitnumber"] = exitnumber
            item["flightId"] = flightId
            item["gatenumber"] = gatenumber
            item["himidity"] = himidity
            item["maxtem"] = maxtem
            item["mintem"] = mintem
            item["remark"] = remark
            item["scheduleDateTime"] = scheduleDateTime
            item["terminalid"] = terminalid
            item["wimage"] = wimage
            item["wind"] = wind
            item["yoil"] = yoil
            
            items.append(item)
            
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (currentElement == "airline") {
            airline = string
        } else if (currentElement == "airport") {
            airport = string
        } else if (currentElement == "airportCode") {
            airportCode = string
        } else if (currentElement == "carousel") {
            carousel = string
        } else if (currentElement == "estimatedDateTime") {
            estimatedDateTime = string
        } else if (currentElement == "exitnumber") {
            exitnumber = string
        } else if (currentElement == "flightId") {
            flightId = string
        } else if (currentElement == "gatenumber") {
            gatenumber = string
        } else if (currentElement == "himidity") {
            himidity = string
        } else if (currentElement == "maxtem") {
            maxtem = string
        } else if (currentElement == "mintem") {
            mintem = string
        } else if (currentElement == "remark") {
            remark = string
        } else if (currentElement == "scheduleDateTime") {
            scheduleDateTime = string
        } else if (currentElement == "terminalid") {
            terminalid = string
        } else if (currentElement == "wimage") {
            wimage = string
        } else if (currentElement == "wind") {
            wind = string
        } else if (currentElement == "yoil") {
            yoil = string
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "airplaneCell", for: indexPath)
        
        let str1: String = items[indexPath.row]["scheduleDateTime"]!
        let scheduleDateTimeStart1 = str1.index(str1.startIndex, offsetBy: 0)
        let scheduleDateTimeEnd1 = str1.index(scheduleDateTimeStart1, offsetBy: 2)
        
        let scheduleDateTimeStart2 = str1.index(scheduleDateTimeEnd1, offsetBy: 0)
        let scheduleDateTimeEnd2 = str1.index(scheduleDateTimeStart2, offsetBy: 2)
        
        let str2: String = items[indexPath.row]["estimatedDateTime"]!
        let estimatedDateTimeStart1 = str2.index(str2.startIndex, offsetBy: 0)
        let estimatedDateTimeEnd1 = str2.index(estimatedDateTimeStart1, offsetBy: 2)
        
        let estimatedDateTimeStart2 = str2.index(estimatedDateTimeEnd1, offsetBy: 0)
        let estimatedDateTimeEnd2 = str2.index(estimatedDateTimeStart2, offsetBy: 2)
        
        let scheduleHour = String(str1[scheduleDateTimeStart1..<scheduleDateTimeEnd1])
        let scheduleMinute = String(str1[scheduleDateTimeStart2..<scheduleDateTimeEnd2])
        let estimatedHour = String(str2[estimatedDateTimeStart1..<estimatedDateTimeEnd1])
        let estimatedMinute = String(str2[estimatedDateTimeStart2..<estimatedDateTimeEnd2])
        
        if String(items[indexPath.row]["estimatedDateTime"]!) == String(items[indexPath.row]["scheduleDateTime"]!) {
            cell.textLabel?.text = items[indexPath.row]["airline"]! + "(" + items[indexPath.row]["flightId"]! + ") [" + scheduleHour + ":" + scheduleMinute + " 예정]"
        } else {
            cell.textLabel?.text = items[indexPath.row]["airline"]! + "(" + items[indexPath.row]["flightId"]! + ") [" + scheduleHour + ":" + scheduleMinute + " 예정 > " + estimatedHour + ":" + estimatedMinute + " 예정]"
        }
        
        // Configure the cell...
        
        
        
        return cell
    }
}

