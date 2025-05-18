//
//  PDFContainer.swift
//  PDFGenerator
//
//  Created by oopers.com on 2025/04/28.
//  Copyright © 2025 oopers.com. All rights reserved.
//

import UIKit

extension PDF {
    
    public class Container {
        public weak
        var parent: Container?
        
        public
        var size: PDF.Dimension.Size = .zero {
            didSet {
                self.needsLayout = true
            }
        }
        
        public
        var leftPadding: PDF.Dimension.Length
        public
        var rightPadding: PDF.Dimension.Length
        public
        var topPadding: PDF.Dimension.Length
        public
        var bottomPadding: PDF.Dimension.Length

        private(set) public
        var needsLayout: Bool = true
        
        public
        var bounds: CGRect?
        private
        var actualLeftPadding: CGFloat?
        private
        var actualRightPadding: CGFloat?
        private
        var actualTopPadding: CGFloat?
        private
        var actualBottomPadding: CGFloat?
        private(set) public
        var contentBounds: CGRect?
        
        public
        init(size: Dimension.Size) {
            self.parent = nil
            self.size = size
            self.leftPadding = .zero
            self.rightPadding = .zero
            self.topPadding = .zero
            self.bottomPadding = .zero
        }
        
        public
        init(
            parent: Container? = nil,
            size: PDF.Dimension.Size = .a4portrait,
            leftPadding: PDF.Dimension.Length = .absolute(.point(0)),
            rightPadding: PDF.Dimension.Length = .absolute(.point(0)),
            topPadding: PDF.Dimension.Length = .absolute(.point(0)),
            bottomPadding: PDF.Dimension.Length = .absolute(.point(0))
        ) {
            self.parent = parent
            self.size = size
            self.leftPadding = leftPadding
            self.rightPadding = rightPadding
            self.topPadding = topPadding
            self.bottomPadding = bottomPadding
        }

        open
        func draw(
            into context: UIGraphicsPDFRendererContext,
            in environment: PDF.Environment
        ) {
            //Override this method & draw the contents
        }
        
        public
        func fixContentBounds(in environment: PDF.Environment) {
            if let parent {
                parent.fixContentBounds(in: environment)
            } else {
                self.bounds = environment.contentBounds
            }
            guard let bounds else {
                print("bounds cannot be fixed")
                return
            }

            let actualSize = bounds.size
            let paddingLeft = self.leftPadding.widthValue(for: actualSize, dpi: environment.dpi)
            let paddingRight = self.rightPadding.widthValue(for: actualSize, dpi: environment.dpi)
            let paddingTop = self.topPadding.heightValue(for: actualSize, dpi: environment.dpi)
            let paddingBottom = self.bottomPadding.heightValue(for: actualSize, dpi: environment.dpi)
            let origin = CGPoint(
                x: paddingLeft + bounds.origin.x,
                y: paddingTop + bounds.origin.y
            )
            let width = actualSize.width - paddingLeft - paddingRight
            let height = actualSize.height - paddingTop - paddingBottom
            let size = CGSize(width: width, height: height)
            let contentBounds = CGRect(origin: origin, size: size)

            self.actualLeftPadding = paddingLeft
            self.actualRightPadding = paddingRight
            self.actualTopPadding = paddingTop
            self.actualBottomPadding = paddingBottom
            self.contentBounds = contentBounds
            //Set `bounds` of child containers if any, in subclasses
        }
    }
}

extension PDF.Container {
    public struct Anchors: OptionSet, Sendable {
        public let rawValue: Int
        static let top = Anchors(rawValue: 1 << 0)
        static let bottom = Anchors(rawValue: 1 << 1)
        static let leading = Anchors(rawValue: 1 << 2)
        static let trailing = Anchors(rawValue: 1 << 3)
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
    public struct Borders: OptionSet, Sendable {
        public let rawValue: Int
        static let top = Borders(rawValue: 1 << 0)
        static let bottom = Borders(rawValue: 1 << 1)
        static let leading = Borders(rawValue: 1 << 2)
        static let trailing = Borders(rawValue: 1 << 3)
        
        static let all: Borders = [.top, .bottom, .leading, .trailing]

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
    public class Layout {
        let container: PDF.Container
        var anchors: Anchors = []
        var borders: Borders = []
        
        init(
            container: PDF.Container,
            anchors: Anchors = [
                .top,
                .leading,
                .trailing,
            ],
            borders: Borders = []
        ) {
            self.container = container
            self.anchors = anchors
            self.borders = borders
        }
    }
}
