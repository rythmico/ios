import class UIKit.UIDevice

extension APIClientInfo {
    public init?(bundle: BundleProtocol, device: UIDeviceProtocol) {
        guard
            let id = (bundle.id?.rawValue).flatMap(APIClientInfo.ID.init),
            let version = bundle.version,
            let build = bundle.build
        else {
            return nil
        }
        self.init(
            id: id,
            version: version,
            build: build.rawValue,
            device: device.modelIdentifier,
            os: device.systemNameAndVersion
        )
    }

    public static var current: APIClientInfo? {
        APIClientInfo(bundle: Bundle.main, device: UIDevice.current)
    }
}
