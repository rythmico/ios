import Foundation
import struct SwiftUI.Color

struct BookingApplication: Equatable, Decodable, Identifiable, Hashable {
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

    struct Student: Equatable, Decodable, Hashable {
        var name: String
        var age: Int
        var gender: Gender
        var about: String
    }

    var id: String
    var bookingRequestId: String
    var createdAt: Date
    var statusInfo: StatusInfo
    var instrument: Instrument
    var submitterName: String
    var submitterPrivateNote: String
    var student: Student
    var postcode: String
    var schedule: Schedule
    var privateNote: String
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
