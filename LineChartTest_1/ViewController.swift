//
//  ViewController.swift
//  LineChartTest_1
//
//  Created by Tyler Falcoff on 2/17/19.
//  Copyright © 2019 Tyler Falcoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lineView: LineChart!
    
    @IBOutlet weak var ticker: UITextField!
    
    @IBOutlet weak var startDate: UIDatePicker!
    
    @IBOutlet weak var endDate: UIDatePicker!
    
    @IBAction func tapView(_ sender: Any) {
        
        if ticker.isFirstResponder {
            
            view.endEditing(true)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func drawLine(_ sender: Any) {
    
        // lineView.drawChart(selectedChart: .line, ySeries: [7.0, 2.0, 4.0, 3.0, 4.0, 6.0, 4.0, 3.0, 1.0, 12.0, 10.0])
        
        
        
        getClose(ticker: ticker.text!, start: startDate.date.toString(dateFormat: "YYYY-MM-dd"), end: endDate.date.toString(dateFormat: "YYYY-MM-dd")) {(data) in
            
            let vals = data.dataset.data
            
            var graphVals: [Double] = []
            
            var graphLabels: [String] = []
            
            for i in 0 ..< vals.count {
                
                graphVals.append(vals[i].value)
                
                graphLabels.append(vals[i].date)
                
            }
            
            DispatchQueue.main.async {
                
                self.lineView.drawChart(selectedChart: .line, ySeries: graphVals.reversed(), xLabels: graphLabels.reversed())
                
            }
            
        }
    
    }
    
    
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}





