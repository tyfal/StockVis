//
//  LineChart.swift
//  LineChartTest_1
//
//  Created by Tyler Falcoff on 2/17/19.
//  Copyright © 2019 Tyler Falcoff. All rights reserved.
//

import UIKit

enum Chart {
    
    case line
    
}

class LineChart: UIView {
    
    var currentChart: Chart?
    
    var series: [Double]?
    
    var dates: [String]?
    
    var label: UILabel?
    
    var scaleFactorY: Double?
    
    var scaleFactorX: Double?
    
    var minY: Double?
    
    var minX: Double?
    
    // var recognizer: UIPanGestureRecognizer!
    var ballView: UIView!
    let ballSize: CGFloat = 5
    var endOfLineAnchor = CGPoint.zero
    var lineLayer = CAShapeLayer()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        print("The chart function has just been called d(^o^)b")
        
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            
            print("could not get current context :{")
            
            return
            
        }
        
        guard let series = series else {
            
            print("could not get data :{")
            
            return
            
        }
        
        drawSeries(use: currentContext, ySeries: series)
        
        enableTouch(use: currentContext)
        
    }
    
    
    func drawChart(selectedChart: Chart, ySeries: [Double], xLabels: [String]) {
        
        currentChart = selectedChart
        
        series = ySeries
        
        dates = xLabels
        
        setNeedsDisplay()
        
    }
    
    
    func drawSeries(use context: CGContext, ySeries:[Double]) {
        
        let fitY = scaleYSeries(use: context, ySeries: ySeries)
        
        var xSeries:[Double] = []
        
        for i in 1...ySeries.count {
            
            xSeries.append(Double(i))
            
        }
        
        let fitX = scaleXSeries(use: context, xSeries: xSeries)
        
        for i in 1..<fitX.count {
            
            drawLine(use: context, start: CGPoint(x: fitX[i-1], y: fitY[i-1]), end: CGPoint(x: fitX[i], y: fitY[i]))
            
        }
        
    }
    
    
    func drawLine(use context: CGContext, start: CGPoint, end: CGPoint, color: CGColor = UIColor.red.cgColor) {
        
        //design the path
        context.move(to: start)
        context.addLine(to: end)
        
        //design path in layer
        context.setStrokeColor(color)
        context.setLineCap(.round)
        context.setLineWidth(1.0)
        
        
        context.strokePath()
        
    }
    
    func scaleXSeries(use context: CGContext, xSeries: [Double]) -> [Double] {
        
        var scaledXSeries: [Double] = []
        
        let screenSize = bounds.size
        
        let max = findMax(series: xSeries)
        
        minX = findMin(series: xSeries)
        
        scaleFactorX = Double(screenSize.width)/(max-minX!)
        
        for i in xSeries {
            
            scaledXSeries.append((i-minX!)*scaleFactorX!)
            
        }
        
        return scaledXSeries
        
    }
    
    func scaleYSeries(use context: CGContext, ySeries: [Double]) -> [Double] {
        
        var scaledYSeries: [Double] = []
        
        let screenSize = bounds.size
        
        let max = findMax(series: ySeries)
        
        minY = findMin(series: ySeries)
        
        scaleFactorY = Double(screenSize.height)/(max-minY!)
        
        for i in ySeries {
            
            scaledYSeries.append(Double(screenSize.height) - (i-minY!)*scaleFactorY!)
            
        }
        
        return scaledYSeries
        
    }
    
    func findMax(series: [Double]) -> Double {
        
        var max = series[0]
        
        for i in series {
            
            if (i > max) {
                
                max = i
                
            }
            
        }
        
        return max
        
    }
    
    func findMin(series: [Double]) -> Double {
        
        var min = series[0]
        
        for i in series {
            
            if (i < min) {
                
                min = i
                
            }
            
        }
        
        return min
        
    }
    
    func enableTouch(use context: CGContext) {
        
        label = UILabel(frame: CGRect(x: 5, y: 2, width: bounds.size.width, height: 20))
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(LineChart.handlePan(_:)))
        
        self.addSubview(label!)
        
        self.addGestureRecognizer(pan)
        
    }
    
    var originalCenter = CGPoint.zero
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        
        var xLoc: CGFloat
        
        switch (sender.state) {
            
            case .began:
                
                print("start da ting :]")
            
                ballView = createBallView()
                ballView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
                endOfLineAnchor = CGPoint(x: bounds.size.width / 2, y: bounds.size.height * 0.8)
                
                lineLayer.strokeColor = UIColor.blue.cgColor
                lineLayer.path = pathFromBallToAnchor()
                self.layer.addSublayer(lineLayer)
                self.addSubview(ballView)
            
            case .ended:
                
                self.label?.text = ""
                
                print("end da ting :]")
            
                ballView.removeFromSuperview()
                lineLayer.removeFromSuperlayer()
            
            case .changed:
                
                xLoc = sender.location(in: self).x
                
                var xDex = Int(Double(xLoc)/scaleFactorX!)
                
                if (xDex < 0) {xDex = 0}
                
                else if (xDex > series!.count - 1) {xDex = series!.count - 1}
                
                var yVal: Double
                
                var xVal: String
                
                yVal = series![xDex]
                
                xVal = dates![xDex]
                
                self.label?.text = "\(xVal): \(yVal)"
                
                let yLoc = CGFloat(Double(bounds.size.height) - (yVal-minY!)*scaleFactorY!)
            
                ballView.center = CGPoint(x: CGFloat((Double(xDex+1)-minX!)*scaleFactorX!), y: yLoc)
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                lineLayer.path = pathFromBallToAnchor()
                CATransaction.commit()
            
            default: print("what da-fault :)")
            
        }
    
    }
    
    func pathFromBallToAnchor() -> CGPath {
        let bazier = UIBezierPath()
        bazier.move(to: CGPoint(x: ballView.center.x, y: bounds.size.height))
        bazier.addLine(to: CGPoint(x: ballView.center.x, y: 0))
        return bazier.cgPath
    }
    
    func createBallView() -> UIView {
        let ball = UIView(frame: CGRect(x: bounds.size.width / 2, y: 0, width: ballSize, height: ballSize))
        ball.backgroundColor = UIColor.blue
        
        ball.layer.cornerRadius = ballSize / 2
        ball.layer.masksToBounds = true
        return ball
    }
    
    
    func createVerticalLineThatStartsAt(start: CGPoint, withHeight height: Double) -> UIView {
        let rect = CGRect(origin: start, size: CGSize(width: 1.0, height: height))
        //        var x = CGRect(origin: start, size: CGSize(width: 1, height: height))
        return UIView(frame: rect)
    }
    
}
