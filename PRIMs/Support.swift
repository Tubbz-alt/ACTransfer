//
//  Support.swift
//  act-r
//
//  Created by Niels Taatgen on 3/29/15.
//  Copyright (c) 2015 Niels Taatgen. All rights reserved.
//

import Foundation

// Global stuff

func actrNoise(noise: Double) -> Double {
    let rand = Double(Int(arc4random_uniform(100000-2)+1))/100000.0
    return noise * log((1 - rand) / rand )
}

func isVariable(s: String) -> Bool {
    return s.hasPrefix("=")
}

func isVariable(v: Value) -> Bool {
    if let s = v.text() {
        return s.hasPrefix("=") }
    else { return false }
}

func string2Double(s: String) -> Double? {
    let scanner = NSScanner(string: s)
    return scanner.scanDouble()
}

// Chunk values can be a symbol, a number or nil
/**
Chunks can have different types in their slots:

- Symbol: Another chunk

- Number: a number (Double)

- Text : a string

*/
enum Value: CustomStringConvertible {
    case Symbol(Chunk)
    case Number(Double)
    case Text(String)


    func number() -> Double? {
        switch self {
        case .Number(let value):
            return value
        default:
            return nil
        }
    }
    
    func text() -> String? {
        switch self {
        case .Text(let s):
            return s
        default: return nil
        }
    }
    
    
    
    func chunk() -> Chunk? {
        switch self {
        case .Symbol(let chunk):
            return chunk
        default:
            return nil
        }
    }
    
    func isEqual(v: Value) ->  Bool {
        return v.description == self.description
    }
    
    var description: String {
        get {
            switch self {
            case Symbol(let value):
                return "\(value.name)"
            case Number(let value):
                return "\(value)"
            case Text(let value):
                return "\(value)"

            }
        }
    }
}

// Functions to manipulate lists of PRIMs
// We need a function to chop off the first PRIM

/**
Chop a PRIM string into separate PRIM

- parameter s: The String with the list of PRIMs

- parameter n: How many PRIMs should be chopped off

- returns: A tuple of two strings with the first n PRIMs and the rest
*/
func chopPrims(s: String, n: Int) -> (String,String) {
    let x = s.componentsSeparatedByString(";")
    if x.count == n {
        return (s, "")
    } else {
        return (x[1..<n].reduce(x[0], combine: { $0 + ";" + $1}),x[(n+1)..<x.count].reduce(x[n], combine: { $0 + ";" + $1} ))
    }
}
