import FoundationEncore

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
                        Card(setupIntent: setupIntent, cardDetails: input.cardDetails) !! preconditionFailure(
                            """
                            Card could not be created with params:
                                - setupIntent: \(setupIntent)
                                - cardDetails: \(input.cardDetails)
                            """
                        )
                    }
                )
            } else {
                reset()
            }
        }
    }
}
