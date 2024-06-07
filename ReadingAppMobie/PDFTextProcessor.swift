import Foundation
import PDFKit

class PDFTextProcessor {
    static func extractPairSentences(from url: URL) -> [[String]] {
        var pairSentences: [[String]] = []
        if let pdfDocument = PDFDocument(url: url) {
            for i in 0..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: i) {
                    if let pageText = page.string {
                        
                        
                        let sentences = pageText.components(separatedBy: ". ")
                        var pair: [String] = []
                        for sentence in sentences {
                            pair.append(sentence)
                            if pair.count == 2 {
                                pairSentences.append(pair)
                                pair = []
                            }
                        }
                        if !pair.isEmpty {
                            pairSentences.append(pair)
                        }
                    }
                }
            }
        }
        return pairSentences
    }
}
