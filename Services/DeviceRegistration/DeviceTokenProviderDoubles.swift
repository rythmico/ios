import FoundationSugar

final class DeviceTokenProviderStub: DeviceTokenProvider {
    var result: Result<String, Error>

    init(result: Result<String, Error>) {
        self.result = result
    }

    func deviceToken(handler: @escaping ResultHandler) {
        switch result {
        case .success(let token):
            handler(token, nil)
        case .failure(let error):
            handler(nil, error)
        }
    }
}

final class DeviceTokenProviderDummy: DeviceTokenProvider {
    func deviceToken(handler: @escaping ResultHandler) {}
}
