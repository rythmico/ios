import CoreDTO
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
        @Published var startDate: DateOnly?
        @Published var startTime: TimeOnly?
        @Published var duration: Schedule.Duration?

        // TODO: remove, have separate date and time props in Schedule
        var startDateAndTime: Date? {
            unwrap(startDate, startTime).map {
                Date(date: $0, time: $1, timeZone: Current.timeZone())
            }
        }
    }

    @ObservedObject private(set)
    var state: ViewState
    var instrument: Instrument
    var setter: Binding<Schedule>.Setter

    private let firstAvailableDate = try! Current.date() + (2, .day, .neutral)
    private let defaultStartTime = try! TimeOnly(hour: 18, minute: 00)
    private let defaultDuration: Schedule.Duration = .oneHour

    @SpacedTextBuilder
    var subtitle: Text {
        "Enter when you want the"
        "\(instrument.assimilatedName) lessons".text.rythmicoFontWeight(.subheadlineMedium)
        "to commence and for how long"
    }

    var startDateText: String? { state.startDate?.formatted(custom: "EEEE d MMMM", locale: Current.locale()) }
    var startTimeText: String? { state.startTime?.formatted(style: .short, locale: Current.locale()) }
    var durationText: String? { state.duration?.title }

    var scheduleInfoText: String? {
        guard
            let startDate = state.startDate,
            let startTime = state.startTime,
            let duration = state.duration,
            let endTime = try? startTime + (duration.rawValue, .minute)
        else {
            return nil
        }
        let day = startDate.formatted(custom: "EEEE", locale: Current.locale())
        let time = TimeOnlyInterval(start: startTime, end: endTime).formatted(style: .short, locale: Current.locale())
        let startDay = startDate.formatted(custom: "EEEE d MMMM", locale: Current.locale())
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
                                if let $startDate = Binding($state.startDate) {
                                    DateOnlyPicker(selection: $startDate) { $selection in
                                        DatePicker(
                                            "",
                                            selection: $selection,
                                            in: firstAvailableDate...,
                                            displayedComponents: .date
                                        )
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                    }
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
                                        inputMode: .timeOnlyPicker(selection: $state.startTime.or(defaultStartTime)),
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
            state.startDate =?? DateOnly(firstAvailableDate, timeZone: .neutral)
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
            instrument: .stub(.guitar),
            setter: { _ in }
        )
    }
}
#endif
