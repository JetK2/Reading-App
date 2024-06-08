//Libraries
import SwiftUI

struct SettingsView: View {
    //To dismiss settings
    @Binding var isPresented: Bool
    //customisation components
    @Binding var pageColor: Color
    @Binding var fontColor: Color
    @Binding var cardColor: Color
    @Binding var componentColor: Color
    @Binding var fontFamily: String

    var body: some View {
        NavigationView {
            Form {
                // Colour Pickers
                Section(header: Text("Colors")) {
                    ColorPicker("Page Color", selection: $pageColor)
                    ColorPicker("Font Color", selection: $fontColor)
                    ColorPicker("Card Color", selection: $cardColor)
                    ColorPicker("Component Color", selection: $componentColor)
                }
                // Font Family Picker
                Section(header: Text("Font")) {
                    Picker("Font Family", selection: $fontFamily) {
                        Text("Arial").tag("Arial")
                        Text("Verdana").tag("Verdana")
                        Text("Times New Roman").tag("Times New Roman")
                        Text("Courier").tag("Courier")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            //  Dismiss settings button
            .navigationBarItems(trailing: Button(action: {
                isPresented.toggle() // Dismiss the settings view
            }) {
                Text("Done")
            })
        }
       
    }
}
