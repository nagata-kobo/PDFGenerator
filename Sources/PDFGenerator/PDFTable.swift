//
//  PDFTable.swift
//  PDFGenerator
//
//  Created by oopers.com on 2025/04/25.
//  Copyright © 2025 oopers.com. All rights reserved.
//

import PDFKit

extension PDF {

    open class Table: Stack {
        
        public override
        init(direction: PDF.Stack.Direction = .vertical, size: PDF.Dimension.Size) {
            super.init(direction: direction, size: size)
        }
        
        public
        func add(
            _ content: PDF.Container,
            backgroundColor: UIColor? = nil,
            fromEnd: Bool = false
        ) {
            super.add(
                content,
                borders: .all,
                backgroundColor: backgroundColor,
                fromEnd: fromEnd
            )
        }
        
        public
        func fill(
            _ content: PDF.Container,
            backgroundColor: UIColor? = nil
        ) {
            super.fill(
                content,
                borders: .all,
                backgroundColor: backgroundColor
            )
        }
    }
}

extension PDF.Table {

    open
    class Row: PDF.Table {
        
        public
        init(
            size: PDF.Dimension.Size
        ) {
            super.init(direction: .horizontal, size: size)
        }
    }
    
    open
    class Column: PDF.Table {
        
        public
        init(
            size: PDF.Dimension.Size
        ) {
            super.init(direction: .vertical, size: size)
        }
    }
}
