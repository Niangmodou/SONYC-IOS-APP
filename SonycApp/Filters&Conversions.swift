//
//  Filters&Conversions.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/25/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//

import UIKit
import Accelerate
import AudioToolbox
import AVFoundation


var biquadFilter: vDSP.Biquad<Float>?

let forwardDCT = vDSP.DCT(count:  bufferSize,
                          transformType: .II)

let inverseDCT = vDSP.DCT(count: bufferSize,
                          transformType: .III)



var forwardDCT_PreProcessed = [Float](repeating: 0,
                                           count: bufferSize)

var forwardDCT_PostProcessed = [Float](repeating: 0,
                                            count: bufferSize)

var inverseDCT_Result = [Float](repeating: 0,
                              count: bufferSize)

class FiltersConversions: UIViewController{
    
}

func apply(dctMultiplier: [Float], toInput input: [Float]) -> [Float] {
       // Perform forward DCT.
       forwardDCT?.transform(input,
                             result: &forwardDCT_PreProcessed)
       // Multiply frequency-domain data by `dctMultiplier`.
       vDSP.multiply(dctMultiplier,
                     forwardDCT_PreProcessed,
                     result: &forwardDCT_PostProcessed)
       
       // Perform inverse DCT.
       inverseDCT?.transform(forwardDCT_PostProcessed,
                             result: &inverseDCT_Result)
       
       // In-place scale inverse DCT result by n / 2.
       // Output samples are now in range -1...+1
       vDSP.divide(inverseDCT_Result,
                   Float(bufferSize/2),
                   result: &inverseDCT_Result)
    
       var values: [Float] = inverseDCT_Result
        values.enumerated().forEach{ index, value in
            values[index] = powf(value, 2.0)
        }
    
    
    var values1: [Float] = values
          values1.enumerated().forEach{ index, value in
              values1[index] = sqrtf(value)
          }
    
   
    
    var values2: [Float] = values1
             values2.enumerated().forEach{ index, value in
                 values2[index] = log10(value)
             }
    
    return values2
   }

func applyMean(toInput input: [Float]) -> Int{

    let sumArray = input.reduce(0, +)
//    print("The sumArray is")
//    print(sumArray)
    let avgArrayValue = sumArray / Float(input.count)
    let intAvgArrayValue = Int(avgArrayValue)
    print(intAvgArrayValue)
    return intAvgArrayValue
}



func decibelsConvert(array: [Float]) -> [Float]{
        var dbs: [Float] = array
        dbs.enumerated().forEach{ index, value in
             dbs[index] =  20 * value
//            dbs[index] =  20 * (log10(sqrtf(value)))
        }
    
    var dbs1: [Float] = dbs
     dbs1.enumerated().forEach{ index, value in
        dbs1[index] =  value + Float(calibrationOffset)
    //            dbs[index] =  20 * (log10(sqrtf(value)))
            }
    
    var dbs3: [Float] = dbs1
             dbs3.enumerated().forEach{ index, value in
                dbs3[index] =  abs(value)
                    }

    
    

    print(dbs3)
    return dbs3
//    print(dbs2)
//    return dbs2
}

func getMin(array: [Float]) -> Float{
    return array.min()!
}

func getMax(array: [Float]) -> Float{
    return array.max()!
}


