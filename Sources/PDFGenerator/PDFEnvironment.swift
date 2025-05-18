//
//  PDFEnvironment.swift
//  PDFGenerator
//
//  Created by oopers.com on 2025/04/30.
//  Copyright © 2025 oopers.com. All rights reserved.
//

import UIKit

extension PDF {
    
    public final
    class Environment {
        
        public
        enum WritingDirection {
            case leftToRight
            case rightToLeft
        }
        
        private
        var pageSize: PDF.Dimension.Size
        
        private(set) public
        var dpi: CGFloat = 72
        
        private(set) public
        var currentPage: PDF.Page? = nil
        
        private
        var writingDirection: WritingDirection = .leftToRight
        
        public
        var leftAnchor: Container.Anchors {
            if writingDirection == .leftToRight {
                return .leading
            } else {
                return .trailing
            }
        }
        
        public
        var rightAnchor: Container.Anchors {
            if writingDirection == .leftToRight {
                return .trailing
            } else {
                return .leading
            }
        }

        private
        var containerPath: [Container] = []
        
        public
        init(pageSize: PDF.Dimension.Size) {
            self.pageSize = pageSize
        }
        
        public
        var contentBounds: CGRect {
            pageSize.bounds(dpi: dpi)
        }
        
        public
        func createPDFData(for pages: [PDF.Page]) -> Data {
            let format = UIGraphicsPDFRendererFormat()
            let bounds = pageSize.bounds(dpi: dpi)
            print(bounds)
            let renderer = UIGraphicsPDFRenderer(bounds: bounds, format: format)
            let pdf = renderer.pdfData { context in
                for page in pages {
                    context.beginPage()
                    self.currentPage = page
                    page.draw(into: context, in: self)
                }
            }
            return pdf
        }
        
        public
        func push(_ container: Container) {
            containerPath.append(container)
        }
        
        public
        func pop() {
            containerPath.removeLast()
        }
    }
}
