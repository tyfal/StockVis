//
//  NewsView.swift
//  LineChartTest_1
//
//  Created by Tyler Falcoff on 3/9/19.
//  Copyright © 2019 Tyler Falcoff. All rights reserved.
//

import UIKit
import WebKit

class NewsView: WKWebView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    func popNewsView(ticker: String) {
        
        let myCNNURL = URL(string:"https://www.cnn.com/search/?q=\(ticker)%20stock&size=10")
        
        let myCNNRequest = URLRequest(url: myCNNURL!)
        
        self.load(myCNNRequest)
        
        addButton()
        
    }
    
    
    private func addButton() {
        
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: 50))
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.darkGray
        button.setTitle("View Recent News", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.sizeToFit()
        
        self.frame = CGRect(x: 0.0, y: Double(self.frame.origin.y), width: Double(self.bounds.size.width), height: 50.0)
        
        self.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        button.addTarget(self, action: #selector(resizeFiling(_:)), for: .touchUpInside)
        
        self.addSubview(button)
        
    }
    
    
    @objc private func resizeFiling(_ sender: UIButton) {
        
        var logMsg = ""
        var titleText = ""
        var viewHeight = 0.0
        
        if self.bounds.size.height == 50 {
            
            logMsg = "Showing News :]"
            titleText = "Tap to Hide News"
            viewHeight = 500.0
            
        } else if self.bounds.size.height == 500 {
            
            logMsg = "Hiding News :["
            titleText = "View Recent News"
            viewHeight = 50
            
        }
        
        print(logMsg)
        
        sender.setTitle(titleText, for: .normal)
        sender.titleLabel?.sizeToFit()
        
        UIView.transition(with: self, duration: 0.6, options: .curveEaseOut, animations: {
            
            self.frame = CGRect(x: 0.0, y: Double(self.frame.origin.y), width: Double(self.bounds.size.width), height: viewHeight)
            
            self.heightAnchor.constraint(equalToConstant: CGFloat(viewHeight)).isActive = true
            
        })
        
    }

}
