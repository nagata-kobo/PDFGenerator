//
//  PDFPage.swift
//  PDFGenerator
//
//  Created by oopers.com on 2025/04/25.
//  Copyright © 2025 oopers.com. All rights reserved.
//

import UIKit

extension PDF {
    
    public class Page: Container {
        
        var content: Container
        
        var pageContent: PDF.Stack {
            return content as! PDF.Stack
        }
        
        public init(
            size: PDF.Dimension.Size = .parentContentSize,
            leftPadding: PDF.Dimension.Length = .absolute(.point(0)),
            rightPadding: PDF.Dimension.Length = .absolute(.point(0)),
            topPadding: PDF.Dimension.Length = .absolute(.point(0)),
            bottomPadding: PDF.Dimension.Length = .absolute(.point(0))
        ) {
            let pageStack = Self.createPageContent()
            self.content = pageStack
            
            super.init(
                size: size,
                leftPadding: leftPadding,
                rightPadding: rightPadding,
                topPadding: topPadding,
                bottomPadding: bottomPadding
            )
            
            pageStack.parent = self
        }

        public override
        func draw(
            into context: UIGraphicsPDFRendererContext,
            in environment: PDF.Environment
        ) {
            fixContentBounds(in: environment)
            guard let contentBounds else {return}
            print("***", contentBounds)
            environment.push(content)
            content.draw(into: context, in: environment)
            environment.pop()
        }
        
        public override
        func fixContentBounds(in environment: PDF.Environment) {
            super.fixContentBounds(in: environment)
            guard let contentBounds else {return}
            
            content.bounds = contentBounds
        }
        
        public static
        func createPageContent() -> Container {
            return Stack(
                size: .parentContentSize
            )
        }
    }
}
