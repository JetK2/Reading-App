import SwiftUI
import PDFKit
import Combine

struct PDFTextView: View {
    let url: URL
    @Binding var currentPageIndex: Int
    @Binding var cardColor: Color
    @Binding var fontColor: Color
    @Binding var fontFamily: String
    @State private var pairSentences: [(Int, [String])] = []

    init(url: URL, currentPageIndex: Binding<Int>, cardColor: Binding<Color>, fontColor: Binding<Color>, fontFamily: Binding<String>) {
        self.url = url
        self._currentPageIndex = currentPageIndex
        self._cardColor = cardColor
        self._fontColor = fontColor
        self._fontFamily = fontFamily
        self._pairSentences = State(initialValue: PDFTextProcessor.extractPairSentences(from: url))
    }

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(pairSentences, id: \.0) { index, sentencePair in
                        CardView(sentences: sentencePair, currentIndex: index, cardColor: cardColor, fontColor: fontColor, fontFamily: fontFamily)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                    }
                }
                .padding(.horizontal)
            }
            .onReceive(Just(currentPageIndex)) { _ in
                withAnimation {
                    scrollView.scrollTo(currentPageIndex)
                }
            }
        }
    }
}

struct CardView: View {
    let sentences: [String]
    let currentIndex: Int
    let cardColor: Color
    let fontColor: Color
    let fontFamily: String

    var body: some View {
        VStack {
            ForEach(sentences, id: \.self) { sentence in
                Text(sentence)
                    .font(.custom(fontFamily, size: 18))
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .foregroundColor(fontColor)
            }
        }
        .padding()
        .background(cardColor)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal, 20)
    }
}

struct PDFTextView_Previews: PreviewProvider {
    static var previews: some View {
        PDFTextView(url: URL(string: "your_pdf_url_here")!, currentPageIndex: .constant(0), cardColor: .constant(.blue), fontColor: .constant(.white), fontFamily: .constant("Arial"))
    }
}

class PDFTextProcessor {
    static func extractPairSentences(from url: URL) -> [(Int, [String])] {
        var pairSentences: [(Int, [String])] = []
        var currentIndex = 0
        
        if let pdfDocument = PDFDocument(url: url) {
            for i in 0..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: i), let pageText = page.string {
                    let sentences = pageText.components(separatedBy: ". ")
                    var pair: [String] = []
                    for sentence in sentences {
                        pair.append(sentence)
                        if pair.count == 2 {
                            pairSentences.append((currentIndex, pair))
                            pair = []
                            currentIndex += 1
                        }
                    }
                    if !pair.isEmpty {
                        pairSentences.append((currentIndex, pair))
                        currentIndex += 1
                    }
                }
            }
        }
        return pairSentences
    }
}
