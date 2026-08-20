import SwiftUI
import Combine

// MARK: - Alert Button Model
struct AlertButtonModel: Identifiable {
    let id = UUID()
    let title: String
    var role: ButtonRole? = nil   // nil = default, .cancel, .destructive
    var action: () -> Void = {}
}

// MARK: - Alert Manager (Global Observable Object)
// Aa Native iOS System alert ne manage kare che - bilkul Apple nu default look.
final class AlertManager: ObservableObject {
    static let shared = AlertManager()

    @Published var isPresented: Bool = false
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var buttons: [AlertButtonModel] = [AlertButtonModel(title: "OK")]

    private init() {}

    /// App ma gyay pan thi call karo - View, ViewModel, Manager, Network layer, badhe thi.
    func show(
        title: String,
        message: String = "",
        buttons: [AlertButtonModel] = [AlertButtonModel(title: "OK")]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
        self.isPresented = true
    }
}

// MARK: - ViewModifier - Native SwiftUI .alert() attach kare che
struct GlobalAlertModifier: ViewModifier {
    @ObservedObject var manager: AlertManager

    func body(content: Content) -> some View {
        content.alert(manager.title, isPresented: $manager.isPresented) {
            ForEach(manager.buttons) { button in
                Button(button.title, role: button.role, action: button.action)
            }
        } message: {
            Text(manager.message)
        }
    }
}

extension View {
    /// App na root view (WindowGroup content) par ek j vaar add karo.
    func withGlobalAlert(manager: AlertManager = .shared) -> some View {
        self.modifier(GlobalAlertModifier(manager: manager))
    }
}

// MARK: - USAGE EXAMPLE (App entry point) - ek j vaar add karvani
/*
 @main
 struct MyApp: App {
     var body: some Scene {
         WindowGroup {
             ContentView()
                 .withGlobalAlert()   // <-- iahi add karo, pachi badhe available
         }
     }
 }
*/

// MARK: - USAGE EXAMPLE 1 - Simple single button alert (native OK look)
/*
 AlertManager.shared.show(
     title: "Success",
     message: "Your data has been saved successfully."
 )
*/

// MARK: - USAGE EXAMPLE 2 - Multiple buttons with roles (Cancel / Destructive)
/*
 AlertManager.shared.show(
     title: "Delete Item?",
     message: "This action cannot be undone.",
     buttons: [
         AlertButtonModel(title: "Cancel", role: .cancel),
         AlertButtonModel(title: "Delete", role: .destructive) {
             print("Item deleted")
         }
     ]
 )
*/

// MARK: - USAGE EXAMPLE 3 - Custom actions with multiple choices
/*
 AlertManager.shared.show(
     title: "Choose an option",
     message: "Select how you want to proceed.",
     buttons: [
         AlertButtonModel(title: "Save as Draft") { print("Draft saved") },
         AlertButtonModel(title: "Publish Now") { print("Published") },
         AlertButtonModel(title: "Cancel", role: .cancel)
     ]
 )
*/
