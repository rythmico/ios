import FoundationSugar

extension TutorStatus {
    private enum Const {
        static let formURLStub = URL(string: "https://airtable.com/shrlakvOPUibGy562")!
    }

    static let registrationPendingStub = registrationPending(formURL: Const.formURLStub)
}
