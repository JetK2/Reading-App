import SwiftUI
import PDFKit

struct PDFTextView: View {
    let url: URL
    @Binding var currentPageIndex: Int
    
    @State private var pairSentences: [[String]] = []

    init(url: URL, currentPageIndex: Binding<Int>) {
        self.url = url
        self._currentPageIndex = currentPageIndex
    }

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(pairSentences, id: \.self) { sentencePair in
                        CardView(sentences: sentencePair)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            pairSentences = PDFTextProcessor.extractPairSentences(from: url)
        }
    }
}

struct PDFTextView_Previews: PreviewProvider {
    static var previews: some View {
        PDFTextView(url: URL(string: "your_pdf_url_here")!, currentPageIndex: .constant(0))
    }
}
