//
//  SECFilings.swift
//  LineChartTest_1
//
//  Created by Tyler Falcoff on 3/9/19.
//  Copyright © 2019 Tyler Falcoff. All rights reserved.
//

import UIKit
import WebKit

class SECFilings: WKWebView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    func popSECViews (ticker: String, form_type: String) {
        
        addButton()
        
        searchTicker(ticker: ticker, form_type: form_type) { (links) in
            
            let mySECURL = URL(string:links[0])
            
            let mySECRequest = URLRequest(url: mySECURL!)
            
            self.load(mySECRequest)
            
        }
        
    }
    
    
    private func searchTicker (ticker : String, form_type: String, completionBlock: @escaping ([String]) -> Void) -> Void  {
        
        let url : String = "https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=\(ticker)&type=\(form_type)"
        
        let task = URLSession.shared.dataTask(with: NSURL(string: url)! as URL) {
            
            (data, response, error) in
            
            guard let data = data else {
                
                print("can't get data")
                
                return
                
            }
                
            let contents = String(data: data, encoding: .ascii)

            let lstData = contents!.split(separator: "\"")
            
            var lstLinks: [String] = []
            
            for i in lstData {
                
                if i.hasSuffix("xbrl_type=v") {
                    
                    lstLinks.append("https://www.sec.gov\(i)")
                    
                }
                
            }
            
            completionBlock(lstLinks)
            
        }
        
        task.resume()
        
    }
    
    
    private func addButton() {
        
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: 50))
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.darkGray
        button.setTitle("View SEC Filings", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.sizeToFit()
        
        self.frame = CGRect(x: 0.0, y: 320.0, width: Double(self.bounds.size.width), height: 50.0)
        
        self.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        button.addTarget(self, action: #selector(resizeFiling(_:)), for: .touchUpInside)
        
        self.addSubview(button)
        
    }
    
    
    @objc private func resizeFiling(_ sender: UIButton) {
        
        var logMsg = ""
        var titleText = ""
        var viewHeight = 0.0
        var stackHeightDelta = 0.0
        
        if self.bounds.size.height == 50 {
        
            logMsg = "Showing SEC Filing :]"
            titleText = "Tap to Hide SEC Filing"
            viewHeight = 500.0
            stackHeightDelta = 450
            
        } else if self.bounds.size.height == 500 {
            
            logMsg = "Hiding SEC Filing :["
            titleText = "View SEC Filing"
            viewHeight = 50
            stackHeightDelta = 0.0
            
        }
        
        print(logMsg)
        
        sender.setTitle(titleText, for: .normal)
        sender.titleLabel?.sizeToFit()
        
        UIView.transition(with: self, duration: 0.6, options: .curveEaseOut, animations: {
            
            self.frame = CGRect(x: 0.0, y: 320.0, width: Double(self.bounds.size.width), height: viewHeight)
            
            self.heightAnchor.constraint(equalToConstant: CGFloat(viewHeight)).isActive = true
            
        })
        
        // self.superview?.heightAnchor.constraint(equalToConstant: CGFloat(1000)).isActive = true
        
        // superview?.addConstraint(heightAnchor.constraint(equalToConstant: 1000))
        // superview?.setNeedsLayout()
        
        // superview?.superview?.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        
        superview?.superview?.backgroundColor = UIColor.yellow
        
        // let stackConst = superview?.heightAnchor.constraint(equalToConstant: 440)
            
        // stackConst?.isActive = false
        
        
        
    }
        
}
    
    
