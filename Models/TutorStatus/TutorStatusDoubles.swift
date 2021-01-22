import Foundation

extension TutorStatus {
    private enum Const {
        static let formURLStub = URL(string: "https://airtable.com/shrlakvOPUibGy562")!
    }

    static let notRegisteredStub = notRegistered(formURL: Const.formURLStub)
}
