import FoundationEncore
import TutorDO

extension TutorDTO.ProfileStatus {
    private enum Const {
        static let formURLStub: URL = "https://airtable.com/shrlakvOPUibGy562"
    }

    static let registrationPendingStub = registrationPending(formURL: Const.formURLStub)
}
