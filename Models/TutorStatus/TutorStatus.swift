import FoundationEncore

enum TutorStatus: Decodable, Equatable {
    case registrationPending(formURL: URL)

    case interviewPending
    case interviewFailed

    case dbsPending
    case dbsProcessing
    case dbsFailed

    case verified

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(Status.self, forKey: .status)
        switch status {
        case .registrationPending:
            let formURL = try container.decode(URL.self, forKey: .formURL)
            self = .registrationPending(formURL: formURL)
        case .interviewPending:
            self = .interviewPending
        case .interviewFailed:
            self = .interviewFailed
        case .dbsPending:
            self = .dbsPending
        case .dbsProcessing:
            self = .dbsProcessing
        case .dbsFailed:
            self = .dbsFailed
        case .verified:
            self = .verified
        }
    }

    private enum CodingKeys: String, CodingKey {
        case status
        case formURL
    }

    private enum Status: String, Decodable {
        case registrationPending = "REGISTRATION_PENDING"
        case interviewPending = "INTERVIEW_PENDING"
        case interviewFailed = "INTERVIEW_FAILED"
        case dbsPending = "DBS_PENDING"
        case dbsProcessing = "DBS_PROCESSING"
        case dbsFailed = "DBS_FAILED"
        case verified = "VERIFIED"
    }
}
