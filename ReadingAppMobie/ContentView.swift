import SwiftUI

struct ContentView: View {
    @State private var isShowingFilePicker = false
    @State private var selectedURL: URL?
    @State private var currentPageIndex = 0

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    isShowingFilePicker = true
                }) {
                    Text("Upload File")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .padding()
                .sheet(isPresented: $isShowingFilePicker) {
                    FilePicker(selectedURL: $selectedURL)
                }

                if let selectedURL = selectedURL {
                    PDFTextView(url: selectedURL, currentPageIndex: $currentPageIndex)
                        .padding()
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
