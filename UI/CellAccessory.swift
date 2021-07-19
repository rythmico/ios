import SwiftUISugar

enum CellAccessory {
    case disclosure
}

extension View {
    @ViewBuilder
    func cellAccessory(_ accessory: CellAccessory?) -> some View {
        if let accessory = accessory {
            HStack(spacing: .grid(2)) {
                self
                switch accessory {
                case .disclosure: Image.disclosureIcon
                }
            }
        } else {
            self
        }
    }
}
