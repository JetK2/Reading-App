import SwiftUI

struct CardView: View {
    let sentencePair: [String]

    var body: some View {
        VStack {
            ForEach(sentencePair, id: \.self) { sentence in
                Text(sentence)
                    .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding() // Add some padding around the card
    }
}
