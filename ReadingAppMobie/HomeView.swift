//Libraries
//    Apple UI Libary
import SwiftUI
//  Audio and Video Library used this for Text-to-Speech
import AVFoundation
//  Apple PDF libary used for PDF manipulation and display
import PDFKit

// Home Page of App
struct HomeView: View {
    //State allows the components to be changed. State is specifically for UI so it knows to rerender with the new changes. Private keeps it in the HomeView scope
    //FileSelector
    @State private var isShowingFileSelector = false
    @State private var selectedURL: URL?
    //Text-to-Speech
    @State private var firstPage = 0
    @State private var speechRate: Float = 0.25
        //play pause button
    @State private var isPlaying = false
    @State private var speakingRange: ClosedRange<Int>?
    let synthesizer = AVSpeechSynthesizer()
    //Customisation Settings
    @State private var isShowingSettings = false // State for showing settings
    @State private var pageColor = Color.white
    @State private var fontColor = Color.black
    @State private var cardColor = Color.black.opacity(0.2)
    @State private var componentColor = Color.blue
    @State private var fontFamily = "Arial"
    
    
    var body: some View {
        NavigationView {
            //Ztack for background colour
            ZStack {
                pageColor
                    .edgesIgnoringSafeArea(.all)
                //Vstack for buttons and cards
                VStack {
                    //Upload file button
                    Button(action: {
                        //Deselects file
                        if selectedURL != nil {
                            selectedURL = nil
                        } else {
                            //Show file selector if there's no file
                            isShowingFileSelector = true
                        }
                    }) {
                        //Text for upload file button
                        Text(selectedURL != nil ? "Change File" : "Upload File")
                            .padding()
                            .background(componentColor)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .font(.custom(fontFamily, size: 18))
                    }
                    .padding()
                    //Presents File selector using .sheet which slides up from the bottom of the page. It's a temporary page that overlaps what's on the screen
                    .sheet(isPresented: $isShowingFileSelector) {
                        FileSelector(selectedURL: $selectedURL)
                    }
                    //PDF TEXT VIEW
                    if let selectedURL = selectedURL {
                        // Vstack for PDFTextView, speed slider, and play/pause button
                        VStack {
                            //Displays cards
                            PDFTextView(url: selectedURL, firstPage: $firstPage, cardColor: $cardColor, fontColor: $fontColor, fontFamily: $fontFamily)
                                .padding()
                            
                            // speed slider and play/pause button
                            VStack {
                                //SPEED SILDER
                                Text("Speed:")
                                    .foregroundColor(fontColor)
                                    .font(.custom(fontFamily, size: 18))
                                Slider(value: $speechRate, in: 0.5...1.25, step: 0.25)
                                    .accentColor(componentColor)
                                Text(String(format: "%.2f", speechRate))
                                    .foregroundColor(fontColor)
                                    .font(.custom(fontFamily, size: 18))
                                //PLAY/PAUSE BUTTON
                                Button(action: {
                                    
                                    isPlaying.toggle()
                                    if isPlaying {
                                        
                                        text_to_speech(from: firstPage)
                                    } else {
                                        // Pauses speech at the current word
                                        synthesizer.pauseSpeaking(at: .word)
                                      
                                    }
                                }) {
                                    //PLAY/PAUSE BUTTON ICON
                                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(componentColor)
                                }
                                
                            }
                            .padding()
                        }
                        .transition(.opacity)
                    } else {
                        //If no file is selected
                        Text("No file selected")
                            .foregroundColor(fontColor)
                            .font(.custom(fontFamily, size: 18))
                    }
                }
                .padding()
                //SETTINGS
                //Display Settings icon and position in top right
                .navigationBarItems(trailing: Button(action: {
                    isShowingSettings.toggle()
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(componentColor)
                        .font(.title)
                })
                //Settings Page temporary display
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
    
    //TEXT-TO-SPEECH FUNCTION ChatGPT used for this function
    func text_to_speech(from pageIndex: Int = 0, characterIndex: Int = 0) {
        guard let url = selectedURL else { return }
        if let pdfDocument = PDFDocument(url: url) {
            var text = ""
            for i in pageIndex..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: i), let pageText = page.string {
                    if i == pageIndex {
                        text += String(pageText.dropFirst(characterIndex))
                    } else {
                        text += pageText
                    }
                }
            }
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = speechRate
            
            if synthesizer.isSpeaking {
                synthesizer.stopSpeaking(at: .immediate)
            } else {
                synthesizer.speak(utterance)
            }
            
           
            speakingRange = pageIndex...(pdfDocument.pageCount - 1)
            print("Current Page Index: \(pageIndex)")
        } else {
            print("Failed to load PDF document")
        }
    }
    
    //Preview Content
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
}
