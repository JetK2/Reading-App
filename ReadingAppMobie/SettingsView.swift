import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool // Binding to dismiss the settings view
    @Binding var pageColor: Color
    @Binding var fontColor: Color
    @Binding var cardColor: Color
    @Binding var componentColor: Color
    @Binding var fontFamily: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Colors")) {
                    ColorPicker("Page Color", selection: $pageColor)
                    ColorPicker("Font Color", selection: $fontColor)
                    ColorPicker("Card Color", selection: $cardColor)
                    ColorPicker("Component Color", selection: $componentColor)
                }
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
            .navigationBarItems(trailing: Button(action: {
                isPresented.toggle() // Dismiss the settings view
            }) {
                Text("Done")
            })
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensure compatibility with iPad
    }
}
