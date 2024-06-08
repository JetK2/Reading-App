//Libraries
import SwiftUI
import PDFKit


//Displays PDF Content
struct PDFTextView: View {
    let url: URL
    //Binding is for two data flow when a child changes so does the parent
    //Cards
    @Binding var firstPage: Int
    @Binding var cardColor: Color
    @Binding var fontColor: Color
    @Binding var fontFamily: String
    @State private var sentences: [String] = []

    //Initialises the style and text of the cards
    init(url: URL, firstPage: Binding<Int>, cardColor: Binding<Color>, fontColor: Binding<Color>, fontFamily: Binding<String>) {
        self.url = url
        self._firstPage = firstPage
        self._cardColor = cardColor
        self._fontColor = fontColor
        self._fontFamily = fontFamily
        self._sentences = State(initialValue: PDFTextProcessor.extractSentences(from: url))
    }
    
    var body: some View {
        //Horizontal scroll function
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    //For loop to put the sentences on each card
                    ForEach(sentences.indices, id: \.self) { index in
                        CardView(sentence: sentences[index], cardColor: cardColor, fontColor: fontColor, fontFamily: fontFamily)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .id(index)
                    }
                }
                .padding(.horizontal)
            }
            
            }
        }
    }

//Used struct as the card does not change after it's been initialised
struct CardView: View {
    let sentence: String
    let cardColor: Color
    let fontColor: Color
    let fontFamily: String

    var body: some View {
        VStack {
            Text(sentence)
                .font(.custom(fontFamily, size: 18))
                .padding()
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .foregroundColor(fontColor)
        }
        .padding()
        .background(cardColor)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal, 20)
    }
}

//PDF Text View Preview
struct PDFTextView_Previews: PreviewProvider {
    static var previews: some View {
        PDFTextView(url: URL(string: "your_pdf_url_here")!, firstPage: .constant(0), cardColor: .constant(.blue), fontColor: .constant(.white), fontFamily: .constant("Arial"))
    }
}




//PDF TEXT PROCESSOR
struct PDFTextProcessor {
    //Using static func here as there's no value for the PDF Text Processor
     static func extractSentences(from url: URL) -> [String] {
         //  guard makes sure the code doesn't proceed unless there is a pdf url
         //  This part converts the pdf into a string
        guard let pdfDocument = PDFDocument(url: url) else { return [] }
        var text = ""
        for i in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: i), let pageText = page.string {
                text += pageText + "\n"
            }
        }
        
        // Splits the text into sections based on fullstops, line breaks and keywords
        let keywords = ["Abstract", "Introduction", "Chapter", "Conclusion", "References"]
        var sentences = text.components(separatedBy: .newlines)
                            .flatMap { $0.components(separatedBy: ". ") }
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        // Further split based on keywords
        for keyword in keywords {
            sentences = sentences.flatMap { $0.components(separatedBy: keyword) }
        }

        // Remove empty sentences
        sentences = sentences.filter { !$0.isEmpty }

        return sentences
    }
}

