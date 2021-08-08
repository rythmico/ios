extension TimeZone {
    public static var neutral: Self {
        TimeZone(secondsFromGMT: 0) !! preconditionFailure("TimeZone.init(secondsFromGMT: 0) returned nil")
    }
}
