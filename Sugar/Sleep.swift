import func Darwin.POSIX.unistd.sleep

@discardableResult
public func sleep(_ time: Double) -> Double {
    Double(usleep(useconds_t(time * 1000000)))
}
