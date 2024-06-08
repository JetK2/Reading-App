// Libraries
import SwiftUI
import UIKit

//FILE SELECTOR Chatgpt used for this part
struct FileSelector: UIViewControllerRepresentable {
    @Binding var selectedURL: URL?

    // Creates coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Create the UIDocumentPickerViewController
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        controller.delegate = context.coordinator
        return controller
    }
    
    // Update the UIViewController if needed
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    // Coordinator class to handle document picker events
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FileSelector

        init(_ picker: FileSelector) {
            self.parent = picker
        }
        
        // document picked
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else { return }
            parent.selectedURL = selectedURL
            
            print("Selected file URL: \(selectedURL)")
        }
    }
}
