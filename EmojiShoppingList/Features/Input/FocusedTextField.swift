import UIKit
import SwiftUI

struct FocusedTextField: UIViewRepresentable {
    var onSubmit: (String) -> Void
    var focusDidChange: (Bool) -> Void
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .roundedRect
        textField.delegate = context.coordinator
        textField.placeholder = NSLocalizedString("Add to list...", comment: "Add to list...")
        textField.font = .input
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.autocapitalizationType = .words
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {}
    
    // MARK: Coordinator
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var onSubmit: (String) -> Void
        var focusDidChange: (Bool) -> Void
        
        init(
            onSubmit: @escaping (String) -> Void,
            focusDidChange: @escaping (Bool) -> Void
        ) {
            self.onSubmit = onSubmit
            self.focusDidChange = focusDidChange
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard let text = textField.text else { return true }
            
            if text.isEmpty {
                textField.resignFirstResponder()
                self.focusDidChange(false)
            } else {
                self.onSubmit(text)
                textField.text = ""
            }
            
            return true
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.focusDidChange(true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            onSubmit: onSubmit,
            focusDidChange: focusDidChange
        )
    }
}
