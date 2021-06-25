extension PreviewDevice {
    public enum Name: String, CaseIterable {
        case iphoneSE = "iPhone SE"
        case iphoneSE2 = "iPhone SE (2nd generation)"
        case iphone11Pro = "iPhone 11 Pro"
    }
}

extension View {
    public func previewDevice(_ name: PreviewDevice.Name) -> some View {
        previewDevice(PreviewDevice(rawValue: name.rawValue))
    }

    public func previewDevices(_ names: [PreviewDevice.Name] = PreviewDevice.Name.allCases) -> some View {
        ForEach(names, id: \.rawValue, content: previewDevice)
    }
}
