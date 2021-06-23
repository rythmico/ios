import FoundationSugar

struct STPSetupIntentStub: STPSetupIntentProtocol {
    let paymentMethodID: String?

    init(paymentMethodID: String) {
        self.paymentMethodID = paymentMethodID
    }
}

struct STPSetupIntentFake: STPSetupIntentProtocol {
    let paymentMethodID: String? = UUID.stub.uuidString
}

final class CardSetupServiceStub: CardSetupServiceProtocol {
    var result: Output
    var delay: TimeInterval?

    init(result: Output, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func send(_ input: Input, completion: @escaping Completion) {
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
    private(set) var latestInput: Input?

    var result: Output

    init(result: Output = nil) {
        self.result = result
    }

    func send(_ input: Input, completion: @escaping Completion) {
        sendCount += 1
        latestInput = input
        result.map(completion)
    }
}

final class CardSetupServiceDummy: CardSetupServiceProtocol {
    func send(_ input: Input, completion: @escaping Completion) {}
}
