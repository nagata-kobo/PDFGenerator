//
//  PDFDimension.swift
//  PDFGenerator
//
//  Created by oopers.com on 2025/04/25.
//  Copyright © 2025 oopers.com. All rights reserved.
//

import Foundation

extension PDF {
    ///Namespace for types of PDF dimensions
    public enum Dimension {}
}

extension PDF.Dimension {
    
    public enum Length: Sendable {
        ///Relative to the super container
        case relative(CGFloat)
        case absolute(Unit)
        case proportional(CGFloat)
        case flexible
        
        static let zero: Length = .absolute(.zero)
        
        public enum Unit: Sendable {
            case pixel(CGFloat, dpi: CGFloat)
            case millimeter(CGFloat)
            case inch(CGFloat)
            
            public static
            func point(_ value: CGFloat) -> Unit {
                .pixel(value, dpi: 72)
            }
            
            public static
            let zero: Unit = .point(0)
        }
    }
    
    /*
    enum PDFContainer {
        case container
        case page
        case column
        case row
    }
     */
    
    public struct Size: Sendable {
        var width: Length
        var height: Length
        
        public init(width: Length, height: Length) {
            self.width = width
            self.height = height
        }
    }
}

extension PDF.Dimension.Size {
    
    public static
    let zero: PDF.Dimension.Size = .init(width: .zero, height: .zero)
    
    public static
    let a4portrait: PDF.Dimension.Size = .init(
        width: .absolute(.pixel(2480, dpi: 300)),
        height: .absolute(.pixel(3508, dpi: 300))
    )
    
    ///Full size relative to parent container's contentBounds
    public static
    let parentContentSize: PDF.Dimension.Size = .init(
        width: .relative(1.0),
        height: .relative(1.0)
    )

    public
    func bounds(dpi: CGFloat) -> CGRect {
        guard
            case let .absolute(width) = self.width,
            case let .absolute(height) = self.height
        else {
            return .zero
        }
        let size = CGSize(
            width: width.pixels(dpi: dpi),
            height: height.pixels(dpi: dpi)
        )
        return .init(origin: .zero, size: size)
    }
}

extension PDF.Dimension.Length {
    
    ///Returns `nan` if the `PDFUnit` is not absolute nor relative
    public func widthValue(
        for size: CGSize,
        dpi: CGFloat
    ) -> CGFloat {
        switch self {
        case .absolute(let unit):
            return unit.pixels(dpi: dpi)
        case .relative(let ratio):
            return size.width * ratio
        default:
            return .nan
        }
    }
    
    ///Returns `nan` if the `PDFUnit` is not absolute nor relative
    public func heightValue(
        for size: CGSize,
        dpi: CGFloat
    ) -> CGFloat {
        switch self {
        case .absolute(let unit):
            return unit.pixels(dpi: dpi)
        case .relative(let ratio):
            return size.height * ratio
        default:
            return .nan
        }
    }
    
    public static func * (lhs: PDF.Dimension.Length, rhs: CGFloat) -> PDF.Dimension.Length {
        switch lhs {
        case .absolute(let unit):
            return .absolute(unit * rhs)
        case .relative(let ratio):
            return .relative(ratio * rhs)
        case .proportional(let factor):
            return .proportional(factor * rhs)
        case .flexible:
            return .flexible
        }
    }
}

extension PDF.Dimension.Length.Unit {
    
    public func pixels(dpi: CGFloat) -> CGFloat {
        switch self {
        case .pixel(let value, let _dpi):
            return value / _dpi * dpi
        case .millimeter(let millimeters):
            return millimeters / 25.4 * dpi
        case .inch(let inches):
            return inches * dpi
        }
    }
    
    public func points(in environment: PDF.Environment) -> CGFloat {
        return pixels(dpi: environment.dpi)
    }
    
    public static func - (lhs: PDF.Dimension.Length.Unit, rhs: PDF.Dimension.Length.Unit) -> PDF.Dimension.Length.Unit {
        .pixel(lhs.pixels(dpi: 1800) - rhs.pixels(dpi: 1800), dpi: 1800)
    }
    
    public static func * (lhs: PDF.Dimension.Length.Unit, rhs: CGFloat) -> PDF.Dimension.Length.Unit {
        switch lhs {
        case .pixel(let value, let _dpi):
            return .pixel(value * rhs, dpi: _dpi)
        case .millimeter(let millimeters):
            return .millimeter(millimeters * rhs)
        case .inch(let inches):
            return .inch(inches * rhs)
        }
    }
}
