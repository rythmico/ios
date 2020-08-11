import SwiftUI

extension View {
    func sheet<Content>(item: Binding<Content?>, onDismiss: (() -> Void)? = nil) -> some View where Content: Identifiable & View {
        sheet(item: item, onDismiss: onDismiss, content: { $0 })
    }
}
