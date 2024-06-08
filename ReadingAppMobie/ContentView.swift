import SwiftUI
import AVFoundation
import PDFKit

struct ContentView: View {
    @State private var isShowingFilePicker = false
    @State private var selectedURL: URL?
    @State private var currentPageIndex = 0
    @State private var speechRate: Float = 1.0 // Speech rate
    @State private var isPlaying = false // State for play/pause button
    @State private var isShowingSettings = false // State for showing settings
    @State private var pageColor = Color.black
    @State private var fontColor = Color.white
    @State private var cardColor = Color.blue
    @State private var componentColor = Color.blue
    @State private var fontFamily = "Arial"
    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        NavigationView {
            ZStack {
                pageColor // Background color
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Button(action: {
                        if selectedURL != nil {
                            selectedURL = nil // Deselect the current file
                        } else {
                            isShowingFilePicker = true // Show file picker if no file is selected
                        }
                    }) {
                        Text(selectedURL != nil ? "Change File" : "Upload File")
                            .padding()
                            .background(componentColor)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .font(.custom(fontFamily, size: 18))
                    }
                    .padding()
                    .sheet(isPresented: $isShowingFilePicker) {
                        FilePicker(selectedURL: $selectedURL)
                    }

                    if let selectedURL = selectedURL {
                        VStack { // Wrap the PDFTextView, slider, and play/pause button in a VStack
                            PDFTextView(url: selectedURL, currentPageIndex: $currentPageIndex, cardColor: $cardColor, fontColor: $fontColor, fontFamily: $fontFamily)
                                .padding()

                            // Add slider and play/pause button
                            VStack {
                                Text("Speed:")
                                    .foregroundColor(fontColor)
                                    .font(.custom(fontFamily, size: 18))
                                Slider(value: $speechRate, in: 0.5...2.0, step: 0.25)
                                    .accentColor(componentColor)
                                Text(String(format: "%.2f", speechRate))
                                    .foregroundColor(fontColor)
                                    .font(.custom(fontFamily, size: 18))

                                Button(action: {
                                    isPlaying.toggle() // Toggle play/pause state
                                    if isPlaying {
                                        speakPDFText()
                                    } else {
                                        synthesizer.stopSpeaking(at: .immediate) // Pause speech
                                    }
                                }) {
                                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(componentColor)
                                }
                            }
                            .padding()
                        }
                        .transition(.opacity)
                    } else {
                        Text("No file selected")
                            .foregroundColor(fontColor)
                            .font(.custom(fontFamily, size: 18))
                    }
                }
                .padding()
                .navigationBarItems(trailing: Button(action: {
                    isShowingSettings.toggle()
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.white)
                        .font(.title)
                })
                .sheet(isPresented: $isShowingSettings) {
                    SettingsView(isPresented: $isShowingSettings,
                                 pageColor: $pageColor,
                                 fontColor: $fontColor,
                                 cardColor: $cardColor,
                                 componentColor: $componentColor,
                                 fontFamily: $fontFamily)
                }
            }
            
        }
    }
    
    func speakPDFText() {
        guard let url = selectedURL else { return }
        if let pdfDocument = PDFDocument(url: url) {
            var text = ""
            for i in 0..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: i), let pageText = page.string {
                    text += pageText
                }
            }
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-UK") // Set the language
            utterance.rate = speechRate // Set the speech rate
            synthesizer.speak(utterance)
        } else {
            print("Failed to load PDF document")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
