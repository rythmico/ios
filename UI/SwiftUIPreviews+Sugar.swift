import SwiftUI

extension PreviewDevice {
    enum Name: String, CaseIterable {
        case iphoneSE = "iPhone SE"
        case iphone6s = "iPhone 6s"
        case iphone11Pro = "iPhone 11 Pro"
    }
}

extension View {
    func previewDevice(_ name: PreviewDevice.Name) -> some View {
        previewDevice(PreviewDevice(rawValue: name.rawValue))
    }

    func previewDevices(_ names: [PreviewDevice.Name] = PreviewDevice.Name.allCases) -> some View {
        ForEach(names, id: \.rawValue, content: previewDevice)
    }
}
