//
//  File.swift
//  HSLuvSwift
//
//  Created by Joseph Wardell on 3/8/25.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
extension SwiftUI.Color {

    // SwiftUI.Color doesn't allow for accessing the raw RGB values
    // without having access to the environment
    // (see https://www.hackingwithswift.com/quick-start/swiftui/how-to-read-the-red-green-and-blue-values-from-a-color)
    // so we cannot implement the framework's Color protocol
    // we can only implement the initializer
    public init(hue: Double, saturation: Double, lightness: Double, alpha: Double) {
        let rgb = hsluvToRgb(HSLuvTuple(hue, saturation, lightness))

        self.init(red: rgb.R, green: rgb.G, blue: rgb.B, opacity: alpha)
    }

    // NOTE: SwiftUI.Color doesn't allow for accessing the raw RGB values
    // without having access to the environment
    // (see https://www.hackingwithswift.com/quick-start/swiftui/how-to-read-the-red-green-and-blue-values-from-a-color)
    // so we cannot implement the framework's Color protocol
    // we can only implement the initializer
    public init(hue: Double, pastelSaturation: Double, lightness: Double, alpha: Double) {
        let rgb = hpluvToRgb(HSLuvTuple(hue, pastelSaturation, lightness))

        self.init(red: rgb.R, green: rgb.G, blue: rgb.B, opacity: alpha)
    }
}
