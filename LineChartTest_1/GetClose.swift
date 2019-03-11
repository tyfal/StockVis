//
//  GetClose.swift
//  StackGraph
//
//  Created by Tyler Falcoff on 11/6/18.
//  Copyright © 2018 Gonzalo Gonzalez . All rights reserved.
//
//
//
//  *Usage: in order to get the close price of Apple scot on 10/1/2018 run the following
//
//  var ticker : String = "AAPL"
//  var start : String = "2018-10-01"
//  var end : String = "2018-10-05"
//
//  getClose(ticker: ticker, start: start, end: end) {(data) in
//
//      print(data.dataset.data[0].value)
//
//  }
//
//
//  let valOptions : [String] = ["Date","Open","High","Low","Close","Volume","Dividend","Split","Adj_Open","Adj_High","Adj_Low","Adj_Close","Adj_Volume"]
//
//

import Foundation
import UIKit

struct Stock:Decodable {
    
    private enum CodingKeys : String, CodingKey { case dataset = "dataset" }
    
    let dataset : dataset
    
}

struct dataset:Decodable {
    
    let dataset_code : String
    let name : String
    let data : [stockData]
    
    enum CodingKeys : String, CodingKey {
        
        case dataset_code = "dataset_code"
        case name = "name"
        case data = "data"
    }
    
    struct stockData:Decodable {
        
        let date: String
        let value: Double
        
        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            date = try container.decode(String.self)
            value = try container.decode(Double.self)
        }
        
    }
    
}


func getClose (ticker : String, start : String, end : String, completionBlock: @escaping (Stock) -> Void) -> Void {
    
    let url : String = "https://www.quandl.com/api/v3/datasets/EOD/"+ticker+".json?api_key=zo7kqTM5GbbuJUNsTKVa&start_date="+start+"&end_date="+end+"&column_inde=3"
    
    let task = URLSession.shared.dataTask(with: NSURL(string: url)! as URL) {
        
        (data, response, error) in
        
        guard let data = data else { return }
        
        do {
            
            let decoder = JSONDecoder()
            
            let stock = try decoder.decode(Stock.self, from: data)
            
            completionBlock(stock)
            
        } catch let jsonErr {
            
            print("Error serializing JSON: ", jsonErr)
            
        }
        
    }
    
    task.resume()
    
}





