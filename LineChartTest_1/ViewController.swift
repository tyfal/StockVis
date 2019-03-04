//
//  ViewController.swift
//  LineChartTest_1
//
//  Created by Tyler Falcoff on 2/17/19.
//  Copyright © 2019 Tyler Falcoff. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollData: UIScrollView!
    @IBOutlet weak var stackData: UIStackView!
    @IBOutlet var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var pickerBackdrop: UIView!
    @IBOutlet var pickStockOutlet: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var donePickingOutlet: UIScreenEdgePanGestureRecognizer!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var drawLineButton: UIButton!
    @IBOutlet weak var SECView: WKWebView!
    
    
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
        
        formatView()
        
        displayPicker()

    }
    
    @IBAction func pickStock(_ sender: Any) {
        
        displayPicker()
        
    }
    
    @IBAction func donePickingStock(_ sender: Any) {
        
        hidePicker()
        
    }

    @IBAction func drawLine(_ sender: Any) {
        
        let myURL = URL(string:"https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=\(ticker.text!)&type=10-K")
        let myRequest = URLRequest(url: myURL!)
        
        getClose(ticker: ticker.text!, start: startDate.date.toString(dateFormat: "YYYY-MM-dd"), end: endDate.date.toString(dateFormat: "YYYY-MM-dd")) {(data) in
            
            let vals = data.dataset.data
            
            var graphVals: [Double] = []
            
            var graphLabels: [String] = []
            
            for i in 0 ..< vals.count {
                
                graphVals.append(vals[i].value)
                
                graphLabels.append(vals[i].date)
                
            }
            
            DispatchQueue.main.async {
                
                self.hidePicker()
                
                self.companyLabel.text = "\(self.ticker.text!) Info"
                
                self.lineView.drawChart(selectedChart: .line, ySeries: graphVals.reversed(), xLabels: graphLabels.reversed())
                
                self.SECView.load(myRequest)
                
            }
            
        }
    
    }
    
    func formatView() {
        
        pickerBackdrop.clipsToBounds = true
        
        ticker.layer.zPosition = 3
        
        startDate.layer.zPosition = 3
        
        endDate.layer.zPosition = 3
        
        tickerLabel.layer.zPosition = 3
        
        startDateLabel.layer.zPosition = 3
        
        endDateLabel.layer.zPosition = 3
        
        drawLineButton.layer.zPosition = 3
        
        pickerBackdrop.layer.zPosition = 2
        
        pickerBackdrop.layer.cornerRadius = 25
        
        lineView.layer.zPosition = 1
        
        SECView.layer.zPosition = 1
        
        scrollData.layer.zPosition = 1
        
        stackData.layer.zPosition = 1
        
    }
    
    
    func hidePicker() {
        
        print("done picking yaaa!!!")
        
        UIView.transition(with: pickerBackdrop, duration: 0.5, options: .curveEaseInOut, animations: {
            self.pickerBackdrop.alpha = 0.7
            self.pickerBackdrop.frame = CGRect(x: -45.0, y: 20.0, width: 60.0, height: self.lineView.frame.height + 20)
            self.startDate.alpha = 0.0
            self.endDate.alpha = 0.0
        
        })
        
        pickStockOutlet.isEnabled = true
        
        donePickingOutlet.isEnabled = false
        
    }
    
    
    func displayPicker() {
        
        print("picking stock yaaa!!!")
        
        UIView.transition(with: pickerBackdrop, duration: 0.5, options: .curveEaseInOut, animations: {
            self.pickerBackdrop.alpha = 0.85
            self.pickerBackdrop.frame = CGRect(x: -45.0, y: 20.0, width: self.lineView.frame.width, height: self.lineView.frame.height + 20)
            self.startDate.alpha = 1.0
            self.endDate.alpha = 1.0
        })
        
        pickStockOutlet.isEnabled = false
        
        donePickingOutlet.isEnabled = true
        
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





