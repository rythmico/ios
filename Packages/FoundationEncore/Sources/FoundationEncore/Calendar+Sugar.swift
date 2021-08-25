extension Calendar {
    public static var neutral: Self {
        Calendar(identifier: .iso8601) => {
            $0.timeZone = .neutral
            $0.locale = .neutral
        }
    }
}
