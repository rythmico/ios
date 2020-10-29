import PhoneNumberKit

extension PhoneNumber {
    static let stub = try! E164PhoneNumber(e164Value: "+447402421160").wrappedValue
}
