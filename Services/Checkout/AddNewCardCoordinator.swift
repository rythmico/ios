import Foundation

final class AddNewCardCoordinator: FailableActivityCoordinator<AddNewCardServiceParams, Checkout.Card> {
    private let service: AddNewCardServiceProtocol

    init(service: AddNewCardServiceProtocol) {
        self.service = service
    }

    override func performTask(with input: AddNewCardServiceParams) {
        super.performTask(with: input)
        service.send(input) { [self] result in
            if let result = result {
                finish(
                    result.map { setupIntent in
                        guard
                            let card = Checkout.Card(setupIntent: setupIntent, cardDetails: input.cardDetails)
                        else {
                            preconditionFailure(
                                """
                                Card could not be created with params:
                                    - setupIntent: \(setupIntent)
                                    - cardDetails: \(input.cardDetails)
                                """
                            )
                        }
                        return card
                    }
                )
            } else {
                reset()
            }
        }
    }
}
