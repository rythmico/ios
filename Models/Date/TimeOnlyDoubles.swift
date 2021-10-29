import FoundationEncore

extension TimeOnly {
    static var stub: TimeOnly {
        try! Self(hour: 17, minute: 30)
    }
}
