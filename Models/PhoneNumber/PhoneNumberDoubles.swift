import FoundationEncore

extension PhoneNumber {
    static let stub = try! PhoneNumberKit().parse("+441632960208", ignoreType: true)
}
