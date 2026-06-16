// https://www.swift.org/documentation/server/guides/testing.html
import XCTest
import Foundation
@testable import HSLuv

class HSLuvTests: XCTestCase {
    
    struct Snapshot: Codable {
        let rgb: [Double]
        let xyz: [Double]
        let luv: [Double]
        let lch: [Double]
        let hsluv: [Double]
        let hpluv: [Double]
    }
    
    func assertClose(expected: Hsluv, actual: Hsluv, tolerance: Double = 1e-10) {
        XCTAssertEqual(expected.hex, actual.hex)
        XCTAssertLessThanOrEqual(abs(expected.rgb_r - actual.rgb_r), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.rgb_g - actual.rgb_g), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.rgb_b - actual.rgb_b), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.xyz_x - actual.xyz_x), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.xyz_y - actual.xyz_y), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.xyz_z - actual.xyz_z), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.luv_l - actual.luv_l), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.luv_u - actual.luv_u), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.luv_v - actual.luv_v), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.lch_l - actual.lch_l), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.lch_c - actual.lch_c), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.lch_h - actual.lch_h), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.hsluv_h - actual.hsluv_h), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.hsluv_s - actual.hsluv_s), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.hsluv_l - actual.hsluv_l), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.hpluv_h - actual.hpluv_h), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.hpluv_p - actual.hpluv_p), tolerance)
        XCTAssertLessThanOrEqual(abs(expected.hpluv_l - actual.hpluv_l), tolerance)
    }
    
    func testStandaloneFunctions() {
        // Test that the functions match the class-based implementation

        // hsluvToRgb
        let converter = Hsluv()
        converter.hsluv_h = 120
        converter.hsluv_s = 50
        converter.hsluv_l = 70
        converter.hsluvToRgb()
        
        let standaloneResult = hsluvToRgb(120, 50, 70)
        XCTAssertEqual(standaloneResult.red, clamp(converter.rgb_r), accuracy: 0.0001)
        XCTAssertEqual(standaloneResult.green, clamp(converter.rgb_g), accuracy: 0.0001)
        XCTAssertEqual(standaloneResult.blue, clamp(converter.rgb_b), accuracy: 0.0001)

        // hpluvToRgb
        converter.hpluv_h = 120
        converter.hpluv_p = 50
        converter.hpluv_l = 70
        converter.hpluvToRgb()
        
        let standaloneResult2 = hpluvToRgb(120, 50, 70)
        XCTAssertEqual(standaloneResult2.red, clamp(converter.rgb_r), accuracy: 0.0001)
        XCTAssertEqual(standaloneResult2.green, clamp(converter.rgb_g), accuracy: 0.0001)
        XCTAssertEqual(standaloneResult2.blue, clamp(converter.rgb_b), accuracy: 0.0001)
    }
    
    private func clamp(_ value: Double) -> Double {
        return max(0.0, min(1.0, value))
    }
    
    func testSnapshot() {
        let url = URL(fileURLWithPath: "Tests/Resources/snapshot-rev4.json")
        guard let data = try? Data(contentsOf: url),
              let snapshot = try? JSONDecoder().decode([String: Snapshot].self, from: data) else {
            XCTFail("Could not load snapshot-rev4.json")
            return
        }
        
        let conv = Hsluv()
        
        for (hex, s) in snapshot {
            let sample = Hsluv()
            sample.hex = hex
            sample.rgb_r = s.rgb[0]
            sample.rgb_g = s.rgb[1]
            sample.rgb_b = s.rgb[2]
            sample.xyz_x = s.xyz[0]
            sample.xyz_y = s.xyz[1]
            sample.xyz_z = s.xyz[2]
            sample.luv_l = s.luv[0]
            sample.luv_u = s.luv[1]
            sample.luv_v = s.luv[2]
            sample.lch_l = s.lch[0]
            sample.lch_c = s.lch[1]
            sample.lch_h = s.lch[2]
            sample.hsluv_h = s.hsluv[0]
            sample.hsluv_s = s.hsluv[1]
            sample.hsluv_l = s.hsluv[2]
            sample.hpluv_h = s.hpluv[0]
            sample.hpluv_p = s.hpluv[1]
            sample.hpluv_l = s.hpluv[2]
            
            // Test hex to HSLuv conversion
            conv.hex = hex
            conv.hexToHsluv()
            assertClose(expected: sample, actual: conv)
            
            // Test HSLuv to hex conversion
            conv.hsluv_h = sample.hsluv_h
            conv.hsluv_s = sample.hsluv_s
            conv.hsluv_l = sample.hsluv_l
            conv.hsluvToHex()
            assertClose(expected: sample, actual: conv)
            
            // Test HPLuv to hex conversion
            conv.hpluv_h = sample.hpluv_h
            conv.hpluv_p = sample.hpluv_p
            conv.hpluv_l = sample.hpluv_l
            conv.hpluvToHex()
            assertClose(expected: sample, actual: conv)
        }
    }
} 