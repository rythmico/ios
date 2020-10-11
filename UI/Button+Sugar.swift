import SwiftUI

extension Button where Label == Text {
    init(_ titleKey: LocalizedStringKey, action: (() -> Void)?) {
        self.init(titleKey, action: action ?? {})
    }
}
