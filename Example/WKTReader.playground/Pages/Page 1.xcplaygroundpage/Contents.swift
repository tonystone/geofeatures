//: Playground - noun: a place where people can play

import UIKit

var str = "POINT(10 5)"
var str2 = "COLLECTION(POINT(1 1) POINT(2 2))"

class Point {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

func process(string: String) -> [AnyObject] {
    
    print(string)
    
    var params = [AnyObject]()
    var tokens = [String]()
    
    for index in string.characters.indices {
        
        switch string[index] {
            
        case "(":
            let token = string.substringToIndex(index)
            tokens.append(token) // grab the geometry type
            
            let parms = process(string.substringFromIndex(index.advancedBy(1))) // process the parameters
            
            if let token = tokens.popLast() {
                
                switch token {
                case "POINT":
                    let point = Point(x: Int(parms[0] as! String)!, y: Int(parms[1] as! String)!) // need to do some type checking here
                    
                    params.append(point)
                    
                    return params
                    
                case "COLLECTION":
                    var collection = [AnyObject]()
                    
                    for param in params {
                        collection.append(param)
                    }
                    
                    return collection
                default: continue
                }
            }
            
        case " ": // param separator
            
            params.append(string.substringToIndex(index)) // save off the param that was processed before the separator
            
            let additionalParams = process(string.substringFromIndex(index.advancedBy(1))) // process the rest of the string
            
            params.appendContentsOf(additionalParams)
            
            return params
            
        case ")":
            
            params.append(string.substringToIndex(index))
            
            return params
            
        default: continue
        }
    }
    
    return params // probably would want to throw an error here instead
}


let result = process(str)




