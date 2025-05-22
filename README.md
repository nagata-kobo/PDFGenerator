# PDFGenerator

A Swift package to generate PDF files.
For iOS (12.0+).
Intended to work with PDFKit.

```Swift
        let pdfEnv = PDF.Environment(pageSize: .a4portrait)
        let pages: [PDF.Page] = createPDFPages()
        let pdf = pdfEnv.createPDFData(for: pages)
        if let document = PDFDocument(data: pdf) {
            self.pdfView.document = document
        }
```

```Swift
    private func createPDFPages() -> [PDF.Page] {
        let page = PDF.Page(
            size: .a4portrait,
            leftPadding: .absolute(.millimeter(10)),
            rightPadding: .absolute(.millimeter(10)),
            topPadding: .absolute(.millimeter(10)),
            bottomPadding: .absolute(.millimeter(10))
        )
        let textSize = PDF.Dimension.Size(
            width: .relative(1.0),
            height: .absolute(.point(100/*26*/))
        )
        let font = UIFont.systemFont(ofSize: 20)
        let textFormat = NSLocalizedString("血圧レポート (年/月/日-年/月/日)", comment: "")
        page.pageContent.add(PDF.TextContainer(
            textFormat,
            font: font,
            alignment: .center,
            //verticalAlignment: .top,
            size: textSize))
        let footerSize = PDF.Dimension.Size(
            width: .relative(1.0),
            height: .absolute(.point(26))
        )
        let footerFont = UIFont.systemFont(ofSize: 20)
        let footerFormat = NSLocalizedString("ページ番号/ページ数", comment: "")
        page.pageContent.add(
            PDF.TextContainer(
                footerFormat,
                font: footerFont,
                alignment: .center,
                size: footerSize
            ),
            fromEnd: true
        )

        ...

        return [page]
    }
```

Sample code: https://github.com/nagata-kobo/PDFCreator.git
