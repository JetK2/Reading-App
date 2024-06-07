import SwiftUI
import PDFKit

struct FilePreview: View {
    let url: URL

    var body: some View {
        PDFViewWrapper(url: url)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PDFViewWrapper: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(url: url)
    }
}
