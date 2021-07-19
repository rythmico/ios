import SwiftUISugar

enum CellAccessory {
    case disclosure
}

extension View {
    @ViewBuilder
    func cellAccessory(_ accessory: CellAccessory) -> some View {
        HStack(spacing: .grid(2)) {
            self
            switch accessory {
            case .disclosure: Image.disclosureIcon
            }
        }
    }
}
