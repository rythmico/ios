import Foundation

final class CardSetupCoordinator: FailableActivityCoordinator<CardSetupParams, Card> {
    private let service: CardSetupServiceProtocol

    init(service: CardSetupServiceProtocol) {
        self.service = service
    }

    override func performTask(with input: CardSetupParams) {
        super.performTask(with: input)
        service.send(input) { [self] result in
            if let result = result {
                finish(
                    result.map { setupIntent in
                        guard
                            let card = Card(setupIntent: setupIntent, cardDetails: input.cardDetails)
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
