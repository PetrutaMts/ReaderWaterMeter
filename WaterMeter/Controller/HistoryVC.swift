//
//  HistoryVC.swift
//  WaterMeter
//
//  Created by petruta maties on 25/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit
import Foundation
import Charts
import Firebase

class HistoryVC: UIViewController {
    var mm = [String]()
    var value = [Double]()    var new : Double = 0
    var last : Double = 0
    var values: [Double] = [5,6,3,4,5,10,7,8,3,10,11,12]
    let history = History()
    var dataTime = [Timestamp]()
    var dataKeys = ""
    var price : Double = 7.0

    @IBOutlet weak var barChartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        history.extractCost { array, monthArr in
            self.values = array
            self.mm = monthArr

        }
            calculateCost(completion: { [weak self] cost, date in
            guard let self = self else {
                return
            }

            self.value.append(cost)

            let month = date.split(separator: "-")
            var luna = ""
            switch month[1] {
            case "01":
                luna = "Jan"
            case "02":
                luna = "Feb"
            case "03":
                luna = "Mar"
            case "04":
                luna = "Apr"
            case "05" :
                luna = "May"
            case "06":
                luna = "Jun"
            case "07":
                luna = "Jul"
            case "08" :
                luna = "Aug"
            case "09" :
                luna = "Sep"
            case "10":
                luna = "Oct"
            case "11" :
                luna = "Nov"
            case "12":
                luna = "Dec"
            default:
                return
            }
            Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").updateData(["costs" : FieldValue.arrayUnion([cost]), "data": FieldValue.arrayUnion([luna])])
       })
        
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").addSnapshotListener { data, error in let dict = data?.data()
            let costs = dict!["costs"] as! [Double]
            let data = dict!["data"] as! [String]

            self.setChartView(entriesData: data , values: costs)
        }
    }
    
    func calculateCost(completion: @escaping (Double, String) -> Void) {
        history.extractPriceFromDB { coldWaterPrice in
            
            self.price = coldWaterPrice
            
            var lastIndex = 0.0
            
            Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").getDocument { (data, error) in
                var keys:[String] = []
                if let dict = data?.data() {
                    lastIndex = Double(dict["lastIndex"] as! String)!
                    keys =  Array(dict.keys).sorted { $0 < $1 }
                    
                    for i in 0..<keys.count - 3 {
                        self.dataKeys = keys[i]
                    }
                    
                    keys.removeLast(3)
                    var newIndex = Double(keys.last ?? "0.0") ?? 0.0
                    var timestamp = Timestamp()
                    if keys.count > 1 {
                        lastIndex = Double(keys[keys.count - 2])!
                        newIndex = Double(keys[keys.count - 1])!
                        timestamp = dict[keys.last ?? ""]! as! Timestamp
                    } else if keys.count == 1 {
                        newIndex = Double(keys.first ?? "0.0") ?? 0.0
                        timestamp = (dict[keys.first ?? ""] as? Timestamp)!
                    }
                    else {
                        lastIndex = 0.0
                    }
                    
                    let date = String(describing: String(describing: timestamp.dateValue()).split(separator: " ").first!)
                    let cost = (newIndex - lastIndex) * self.price
                    completion(cost, date)
                }
            }
        }
        
    }

    func setChartView(entriesData: [String], values: [Double]) {
        var chartEntries: [BarChartDataEntry] = []
        for i in 0 ..< values.count {
            let newEntry = BarChartDataEntry(x: Double(i), y: values[i])
            chartEntries.append(newEntry)
        }
        let set: BarChartDataSet = BarChartDataSet(values: chartEntries, label: "Payments")
        set.colors = [NSUIColor(ciColor: CIColor(color: .green))]
        set.drawValuesEnabled = true
        
        let data: BarChartData = BarChartData(dataSet: set)
        barChartView.fitBars = true
        barChartView.chartDescription?.enabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelCount = values.count
        barChartView.xAxis.centerAxisLabelsEnabled = true
        barChartView.xAxis.setLabelCount(1, force: true)
        barChartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            var i = 0
            if index > 0 { i = Int(round(index)) }
            return entriesData[i]
        })
            var string = ""
            for i in 0..<entriesData.count {
                string.append(contentsOf: "  " + entriesData[i])
            }
            return string
        })
        barChartView.data = data
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

