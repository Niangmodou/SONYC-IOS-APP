//
//  EqualizationFilters.swift
//  SonycApp
//
//  Created by Vanessa Johnson on 7/25/20.
//  Copyright © 2020 Vanessa Johnson. All rights reserved.
//


//this file will be credited to: https://developer.apple.com/documentation/accelerate/equalizing_audio_with_vdsp with changes to conform to the specific project

import Accelerate

enum EqualizationMode: String, CaseIterable {
    case dctLowPass = "DCT Low-Pass"
    case dctHighPass = "DCT High-Pass"
    case dctBandPass = "DCT Band-Pass"
    case dctBandStop = "DCT Band-Stop"
    
    
    //making the multipler one of the equalization filters
    func dctMultiplier() -> [Float]? {
        let multiplier: [Float]?
        
        switch self {
        case .dctHighPass:
            multiplier = EqualizationFilters.dctHighPass
        case .dctLowPass:
            multiplier = EqualizationFilters.dctLowPass
        case .dctBandPass:
            multiplier = EqualizationFilters.dctBandPass
        case .dctBandStop:
            multiplier = EqualizationFilters.dctBandStop
        default:
            multiplier = nil
        }
        
        return multiplier
    }
    
    
    var category: Category {
        switch self {
        case .dctBandStop, .dctBandPass, .dctLowPass, .dctHighPass:
            return .dct(dctMultiplier()!)
        }
    }
    
    enum Category {
        case dct([Float])
        case biquad([Double])
        case passThrough
    }
}

struct EqualizationFilters {
    //dctHighPass array values
    static let dctHighPass: [Float] = {
        return interpolatedVectorFrom(magnitudes:  [0,   0,   1,    1],
                                      indices:     [0, 340, 350, 1024],
                                      count: bufferSize)
    }()
    //dctLowPass array values
    static let dctLowPass: [Float] = {
        return interpolatedVectorFrom(magnitudes:  [1,   1,   0,   0],
                                      indices:     [0, 200, 210, 1024],
                                      count: bufferSize)
    }()
    //dctBandPass array values
    static let dctBandPass: [Float] = {
        return interpolatedVectorFrom(magnitudes:  [0,   0,   1,   1,   0,    0],
                                      indices:     [0, 290, 300, 380, 390, 1024],
                                      count: bufferSize)
    }()
    //dctBandStop array values
    static let dctBandStop: [Float] = {
        return interpolatedVectorFrom(magnitudes:  [1,   1,   0,   0,   1,    1],
                                      indices:     [0, 290, 300, 380, 390, 1024],
                                      count: bufferSize)
    }()
    
    
    static func interpolatedVectorFrom(magnitudes: [Float],
                                       indices: [Float],
                                       count: Int) -> [Float] {
        assert(magnitudes.count == indices.count,
               "`magnitudes.count` must equal `indices.count`.")
        
        var c = [Float](repeating: 0,
                        count: count)
        
        let stride = vDSP_Stride(1)
        
        vDSP_vgenp(magnitudes, stride,
                   indices, stride,
                   &c, stride,
                   vDSP_Length(count),
                   vDSP_Length(magnitudes.count))
        
        return c
    }
    
}
