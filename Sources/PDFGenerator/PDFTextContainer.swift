//
//  PDFTextContainer.swift
//  PDFGenerator
//
//  Created by oopers.com on 2025/04/30.
//  Copyright © 2025 oopers.com. All rights reserved.
//

import UIKit

extension PDF {
    
    public class TextContainer: Container {
        
        public enum VerticalAlignment {
            case top
            case middle
            case bottom
        }
        
        public var text: String?
        
        public var font: UIFont?
        
        public var alignment: NSTextAlignment?
        
        public var verticalAlignment: VerticalAlignment = .middle
        
        public init(
            _ text: String,
            size: PDF.Dimension.Size = .zero
        ) {
            self.text = text
            super.init(size: size)
        }
        
        public init(
            _ text: String,
            font: UIFont,
            alignment: NSTextAlignment?,
            verticalAlignment: VerticalAlignment = .middle,
            size: PDF.Dimension.Size = .zero
        ) {
            self.text = text
            self.font = font
            self.alignment = alignment
            self.verticalAlignment = verticalAlignment
            super.init(size: size)
        }
        
        public override func draw(
            into context: UIGraphicsPDFRendererContext,
            in environment: PDF.Environment
        ) {
            fixContentBounds(in: environment)
            guard let contentBounds else {return}
            //print("***T", text, contentBounds)
            let font = self.font ?? UIFont.systemFont(ofSize: 150)
            let attributes: [NSAttributedString.Key : Any] = [
                .font: font,
                .paragraphStyle: createParagraphStyle(),
            ]
            let nsText = (text ?? "") as NSString
            let textBounds = createTextBounds(
                nsText,
                with:  attributes,
                in: contentBounds
            )
            nsText.draw(in: textBounds, withAttributes: attributes)
            /*
            //For debugging
            context.stroke(contentBounds)
            dump(contentBounds)
             */
        }
        
        private func createParagraphStyle() -> NSParagraphStyle {
            let alignment = self.alignment ?? .natural
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byTruncatingTail
            paragraphStyle.alignment = alignment
            return paragraphStyle
        }

        private func createTextBounds(
            _ nsText: NSString,
            with attributes: [NSAttributedString.Key : Any],
            in contentBounds: CGRect
        ) -> CGRect {
            let size = nsText.size(withAttributes: attributes)
            print("textSize of \(nsText):", size)
            if size.height >= contentBounds.height {
                return contentBounds
            } else {
                let dHeight = contentBounds.height - size.height
                switch verticalAlignment {
                case .top:
                    return CGRect(
                        x: contentBounds.origin.x,
                        y: contentBounds.origin.y,
                        width: contentBounds.size.width,
                        height: size.height
                    )
                case .middle:
                    return CGRect(
                        x: contentBounds.origin.x,
                        y: contentBounds.origin.y + dHeight / 2,
                        width: contentBounds.size.width,
                        height: size.height
                    )
                case .bottom:
                    return CGRect(
                        x: contentBounds.origin.x,
                        y: contentBounds.origin.y + dHeight,
                        width: contentBounds.size.width,
                        height: size.height
                    )
                }
            }
        }
    }
}
