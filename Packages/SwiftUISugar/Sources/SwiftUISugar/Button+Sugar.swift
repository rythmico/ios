extension Button where Label == Text {
    public init(_ titleKey: LocalizedStringKey, action: (() -> Void)?) {
        self.init(titleKey, action: action ?? {})
    }
}
