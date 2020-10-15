import Foundation

struct STPSetupIntentStub: STPSetupIntentProtocol {
    let paymentMethodID: String?

    init(paymentMethodID: String) {
        self.paymentMethodID = paymentMethodID
    }
}

struct STPSetupIntentFake: STPSetupIntentProtocol {
    let paymentMethodID: String? = UUID().uuidString
}

final class CardSetupServiceStub: CardSetupServiceProtocol {
    var result: Output
    var delay: TimeInterval?

    init(result: Output, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func send(_ params: Params, completion: @escaping Completion) {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
                completion(result)
            }
        } else {
            completion(result)
        }
    }
}

final class CardSetupServiceSpy: CardSetupServiceProtocol {
    private(set) var sendCount = 0
    private(set) var latestParams: Params?

    var result: Output

    init(result: Output = nil) {
        self.result = result
    }

    func send(_ params: Params, completion: @escaping Completion) {
        sendCount += 1
        latestParams = params
        result.map(completion)
    }
}

final class CardSetupServiceDummy: CardSetupServiceProtocol {
    func send(_ params: Params, completion: @escaping Completion) {}
}
