import SwiftUIEncore

struct SchedulingView: View, FocusableView, TestableView {
    enum Focus: FocusEnum {
        case startDate
        case startTime
        case duration

        static var usingKeyboard = [startTime, duration]
    }

    @StateObject
    var focusCoordinator = FocusCoordinator(keyboardDismisser: Current.keyboardDismisser, endEditingOnBackgroundTap: false)

    final class ViewState: ObservableObject {
        @Published var startDate: Date?
        @Published var startTime: Date?
        @Published var duration: Schedule.Duration?

        var startDateAndTime: Date? {
            unwrap(startDate, startTime).map {
                Date(date: $0, time: $1, timeZone: Current.timeZone)
            }
        }
    }

    @ObservedObject private(set)
    var state: ViewState
    var instrument: Instrument
    var setter: Binding<Schedule>.Setter

    private let firstAvailableDate = try! Current.date() + (2, .day, Current.timeZone)
    private let defaultStartTime = try! Current.date() => ([.minute, .second, .nanosecond], 0, Current.timeZone)
    private let defaultDuration: Schedule.Duration = .oneHour

    @SpacedTextBuilder
    var subtitle: Text {
        "Enter when you want the"
        "\(instrument.assimilatedName) lessons".text.rythmicoFontWeight(.subheadlineMedium)
        "to commence and for how long"
    }

    private static let dateFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private static let timeFormatter = Current.dateFormatter(format: .preset(date: .none, time: .short))

    private static let scheduleInfoDayFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private static let scheduleInfoStartDayFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private static let scheduleInfoDurationFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))

    var startDateText: String? { state.startDate.map(Self.dateFormatter.string(from:)) }
    var startTimeText: String? { state.startTime.map(Self.timeFormatter.string(from:)) }
    var durationText: String? { state.duration?.title }

    var scheduleInfoText: String? {
        guard
            let startDateAndTime = state.startDateAndTime,
            let duration = state.duration,
            let endDateAndTime = Current.calendar().date(byAdding: .minute, value: duration.rawValue, to: startDateAndTime)
        else {
            return nil
        }
        let day = Self.scheduleInfoDayFormatter.string(from: startDateAndTime)
        let time = Self.scheduleInfoDurationFormatter.string(from: startDateAndTime, to: endDateAndTime)
        let startDay = Self.scheduleInfoStartDayFormatter.string(from: startDateAndTime)
        return "Lessons will be scheduled every \(day) \(time) starting \(startDay)"
    }

    var nextButtonAction: Action? {
        unwrap(state.startDateAndTime, state.duration).map(Schedule.init).mapToAction(setter)
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView("Lesson Schedule", subtitle) { padding in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: .grid(5)) {
                        TextFieldHeader("Start Date") {
                            CustomEditableTextField(
                                placeholder: "Select a date...",
                                text: startDateText,
                                isEditing: focus == .startDate,
                                editAction: beginEditingStartDate
                            ) {
                                if let startDateBinding = Binding($state.startDate) {
                                    DatePicker(
                                        "",
                                        selection: startDateBinding,
                                        in: firstAvailableDate...,
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding([.top, .horizontal], .grid(2))
                                }
                            }
                        }

                        HStack(spacing: .grid(3)) {
                            TextFieldHeader("Time") {
                                Container(style: .field) {
                                    CustomTextField(
                                        "Time...",
                                        text: .constant(startTimeText ?? .empty),
                                        inputMode: DatePickerInputMode(
                                            selection: $state.startTime.or(defaultStartTime),
                                            mode: .time
                                        ),
                                        inputAccessory: .doneButton,
                                        onEditingChanged: onEditingStartTimeChanged
                                    )
                                }
                            }

                            TextFieldHeader("Duration") {
                                Container(style: .field) {
                                    CustomTextField(
                                        "Duration...",
                                        text: .constant(durationText ?? .empty),
                                        inputMode: PickerInputMode(
                                            selection: $state.duration.or(defaultDuration),
                                            formatter: \.title
                                        ),
                                        inputAccessory: .doneButton,
                                        onEditingChanged: onEditingDurationChanged
                                    )
                                }
                            }
                        }

                        if let scheduleInfoText = scheduleInfoText {
                            InfoBanner(text: scheduleInfoText)
                        }
                    }
                    .frame(maxWidth: .grid(.max))
                    .padding([.trailing, .bottom], padding.trailing)
                }
                .padding(.leading, padding.leading)

                ZStack(alignment: .bottom) {
                    nextButtonAction.map { action in
                        FloatingView {
                            RythmicoButton("Next", style: .primary(), action: action)
                        }
                        .zIndex(0)
                    }
                }
            }
        }
        .testable(self)
        .accentColor(.rythmico.picoteeBlue)
        .onReceive(focusCoordinator.$focus, perform: onFocusChanged)
        .animation(.easeInOut(duration: .durationMedium), value: focus)
    }

    func beginEditingStartDate() { focus = .startDate }
    func onEditingStartTimeChanged(_ isEditing: Bool) { focus = isEditing ? .startTime : .none }
    func onEditingDurationChanged(_ isEditing: Bool) { focus = isEditing ? .duration : .none }

    func onFocusChanged(_ focus: Focus?) {
        guard let focus = focus else { return }
        switch focus {
        case .startDate:
            state.startDate =?? firstAvailableDate
        case .startTime:
            state.startTime =?? defaultStartTime
        case .duration:
            state.duration =?? defaultDuration
        }
    }
}

#if DEBUG
struct SchedulingViewPreview: PreviewProvider {
    static var previews: some View {
        SchedulingView(
            state: SchedulingView.ViewState(),
            instrument: .guitar,
            setter: { _ in }
        )
    }
}
#endif
