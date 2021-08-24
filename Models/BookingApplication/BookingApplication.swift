import FoundationEncore
import PhoneNumberKit
import struct SwiftUI.Color

struct BookingApplication: Equatable, Identifiable, Hashable {
    enum Status: String, Decodable, Hashable, CaseIterable {
        case pending = "PENDING"
        case cancelled = "CANCELLED"
        case retracted = "RETRACTED"
        case notSelected = "NOT_SELECTED"
        case selected = "SELECTED"
    }

    struct StatusInfo: Equatable, Decodable, Hashable {
        var status: Status
        var date: Date
    }

    enum AddressInfo: Equatable, Decodable, Hashable {
        case postcode(String)
        case address(Address)

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let postcode = try container.decodeIfPresent(String.self, forKey: .postcode)
            let address = try container.decodeIfPresent(Address.self, forKey: .address)
            switch (postcode, address) {
            case (_, let address?):
                self = .address(address)
            case (let postcode?, _):
                self = .postcode(postcode)
            case (nil, nil):
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [CodingKeys]([.postcode, .address]),
                        debugDescription: "Missing required keys 'postcode'/'address'"
                    )
                )
            }
        }
    }

    var id: String
    var bookingRequestId: String
    var createdAt: Date
    var statusInfo: StatusInfo
    var instrument: Instrument
    var submitterName: String
    var submitterPrivateNote: String
    @E164PhoneNumberOptional
    var phoneNumber: PhoneNumber?
    var student: Student
    var addressInfo: AddressInfo
    var schedule: Schedule
    var privateNote: String
}

extension BookingApplication: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            id: container.decode(String.self, forKey: .id),
            bookingRequestId: container.decode(String.self, forKey: .bookingRequestId),
            createdAt: container.decode(Date.self, forKey: .createdAt),
            statusInfo: container.decode(StatusInfo.self, forKey: .statusInfo),
            instrument: container.decode(Instrument.self, forKey: .instrument),
            submitterName: container.decode(String.self, forKey: .submitterName),
            submitterPrivateNote: container.decode(String.self, forKey: .submitterPrivateNote),
            phoneNumber: container.decode(E164PhoneNumberOptional.self, forKey: .phoneNumber).wrappedValue,
            student: container.decode(Student.self, forKey: .student),
            addressInfo: AddressInfo(from: decoder),
            schedule: container.decode(Schedule.self, forKey: .schedule),
            privateNote: container.decode(String.self, forKey: .privateNote)
        )
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case bookingRequestId
        case createdAt
        case statusInfo
        case instrument
        case submitterName
        case submitterPrivateNote
        case phoneNumber
        case student
        case postcode // AddressInfo
        case address // AddressInfo
        case schedule
        case privateNote
    }
}

extension BookingApplication.Status {
    var title: String {
        switch self {
        case .pending: return "Pending"
        case .cancelled: return "Cancelled"
        case .retracted: return "Retracted"
        case .notSelected: return "Not Selected"
        case .selected: return "Selected"
        }
    }

    var summary: String {
        switch self {
        case .pending: return "Pending tutor selection"
        case .cancelled: return "Cancelled by submitter"
        case .retracted: return "Retracted by you"
        case .notSelected: return "Not selected"
        case .selected: return "Selected"
        }
    }

    var color: Color {
        switch self {
        case .pending: return .orange
        case .cancelled: return .gray
        case .retracted: return .gray
        case .notSelected: return .red
        case .selected: return .green
        }
    }
}
