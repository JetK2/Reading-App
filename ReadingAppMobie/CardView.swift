import SwiftUI

struct CardView: View {
    let sentences: [String]

    var body: some View {
        VStack {
            ForEach(sentences, id: \.self) { sentence in
                Text(sentence)
                    .padding()
                    .fixedSize(horizontal: false, vertical: true) // Allow the text to expand vertically
                    .multilineTextAlignment(.center) // Center align the text
            }
        }
        .padding()
        .frame(maxWidth: 300) // Set a maximum width for the card
        .background(Color.accentColor) // Use the desired background color
        .cornerRadius(15) // Add corner radius
        .shadow(radius: 5) // Add shadow
        .padding(.horizontal, 20) // Add horizontal padding around the card
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(sentences: [""])
            .previewLayout(.sizeThatFits)
    }
}
