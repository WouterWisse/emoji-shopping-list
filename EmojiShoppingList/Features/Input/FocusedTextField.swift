import UIKit
import SwiftUI

struct FocusedTextField: UIViewRepresentable {
    var onSubmit: (String) -> Void
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.delegate = context.coordinator
        textField.placeholder = NSLocalizedString("Add to list...", comment: "Add to list...")
        textField.font = .input
        textField.clearButtonMode = .whileEditing
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {}
    
    // MARK: Coordinator
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var onSubmit: (String) -> Void
        
        init(onSubmit: @escaping (String) -> Void) {
            self.onSubmit = onSubmit
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard let text = textField.text else { return true }
            
            if text.isEmpty {
                textField.resignFirstResponder()
            } else {
                self.onSubmit(text)
                textField.text = ""
            }
            
            return true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSubmit: onSubmit)
    }
}
