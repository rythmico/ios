import SwiftUI
import Sugar

protocol SchedulingContext {
    func setSchedule(_ schedule: Schedule)
}

// TODO: refactor date logic into a manager class from
// which to observe available dates and times, with injectable calendar.
struct SchedulingView: View, TestableView {
    fileprivate enum Const {
        static let earliestStartTime = Date(timeIntervalSinceReferenceDate: 0).setting(hour: 8) // 08:00
        static let fieldDateFormat = "EEEE d MMMM"
        static let fieldTimeFormat = "H:mm"
        static let pickerDateFormat = "E d MMM yyyy"
        static let pickerTimeFormat = "H:mm"
    }

    final class ViewState: ObservableObject {
        @Published var startDate: Date?
        @Published var startTime: Date?
        @Published var duration: Duration?
    }

    @ObservedObject private(set) var state: ViewState

    enum EditingFocus {
        case none
        case startDate
        case startTime
        case duration
    }

    @State private(set) var editingFocus: EditingFocus = .none

    private let instrument: Instrument
    private let context: SchedulingContext
    private let dateFormatter = DateFormatter().then { $0.dateFormat = Const.fieldDateFormat }
    private let timeFormatter = DateFormatter().then { $0.dateFormat = Const.fieldTimeFormat }
    private let availableDates = [Date](byAdding: 1, .day, from: Date() + (1, .day), times: 182)
    private let availableTimes = [Date](byAdding: 30, .minute, from: Const.earliestStartTime, times: 22)

    init(
        instrument: Instrument,
        state: ViewState,
        context: SchedulingContext
    ) {
        self.instrument = instrument
        self.state = state
        self.context = context
    }

    var subtitle: [MultiStyleText.Part] {
        UIScreen.main.isLarge || editingFocus.isNone
            ? "Enter when you want the " + "\(instrument.name) lessons".bold + " to commence and for how long"
            : .empty
    }

    var startDateText: String { state.startDate.map(dateFormatter.string(from:)) ?? .empty }
    var startTimeText: String { state.startTime.map(timeFormatter.string(from:)) ?? .empty }
    var durationText: String { state.duration.map { "\($0.rawValue) minutes" } ?? .empty }

    var nextButtonAction: Action? {
        guard
            let startDate = state.startDate,
            let startTime = state.startTime,
            let startDateAndTime = Date(date: startDate, time: startTime),
            let duration = state.duration
        else {
            return nil
        }

        return {
            self.context.setSchedule(
                Schedule(startDate: startDateAndTime, duration: duration)
            )
        }
    }

    var didAppear: Handler<Self>?
    var body: some View {
        TitleSubtitleContentView(title: "Lesson Schedule", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: .spacingLarge) {
                        TitleContentView(title: "Start Date") {
                            CustomTextField(
                                "Select a date...",
                                text: .constant(startDateText),
                                isEditable: false
                            )
                            .modifier(RoundedThinOutlineContainer(padded: false))
                            .onTapGesture(perform: beginEditingStartDate)
                        }

                        HStack(spacing: .spacingExtraSmall) {
                            TitleContentView(title: "Time") {
                                CustomTextField(
                                    "Start time...",
                                    text: .constant(startTimeText),
                                    isEditable: false
                                )
                                .modifier(RoundedThinOutlineContainer(padded: false))
                                .onTapGesture(perform: beginEditingStartTime)
                            }

                            TitleContentView(title: "Duration") {
                                CustomTextField(
                                    "Duration...",
                                    text: .constant(durationText),
                                    isEditable: false
                                )
                                .modifier(RoundedThinOutlineContainer(padded: false))
                                .onTapGesture(perform: beginEditingDuration)
                            }
                        }

                        VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                            Text("Please note:").rythmicoFont(.callout)
                            Text("Mon-Fri lessons £60 for 45-60 min.").rythmicoFont(.body)
                            Text("Weekend lessons £65 for 45-60 min.").rythmicoFont(.body)
                        }
                    }
                    .padding([.trailing, .bottom], .spacingMedium)
                    .onBackgroundTapGesture(perform: endEditing)
                }
                .padding(.leading, .spacingMedium)

                ZStack(alignment: .bottom) {
                    nextButtonAction.map { action in
                        FloatingView {
                            Button("Next", action: action).primaryStyle()
                        }
                        .zIndex(0)
                    }

                    if editingFocus.isStartDate {
                        FloatingInputView(doneAction: endEditing) {
                            BetterPicker(
                                options: availableDates,
                                selection: Binding(
                                    get: { self.state.startDate ?? self.availableDates[0] },
                                    set: { self.state.startDate = $0 }
                                ),
                                formatter: { self.dateFormatter.string(from: $0) }
                            )
                        }
                        .zIndex(1)
                    }

                    if editingFocus.isStartTime {
                        FloatingInputView(doneAction: endEditing) {
                            BetterPicker(
                                options: availableTimes,
                                selection: Binding(
                                    get: { self.state.startTime ?? self.availableTimes[0] },
                                    set: { self.state.startTime = $0 }
                                ),
                                formatter: { self.timeFormatter.string(from: $0) }
                            )
                        }
                        .zIndex(1)
                    }

                    if editingFocus.isDuration {
                        FloatingInputView(doneAction: endEditing) {
                            BetterPicker(
                                selection: Binding(
                                    get: { self.state.duration ?? .fortyFiveMinutes },
                                    set: { self.state.duration = $0 }
                                ),
                                formatter: { "\($0.rawValue) minutes" }
                            )
                        }
                        .zIndex(1)
                    }
                }
            }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: editingFocus)
        .onAppear { self.didAppear?(self) }
    }

    func beginEditingStartDate() {
        editingFocus = .startDate

        if state.startDate == nil {
            state.startDate = availableDates[0]
        }
    }

    func beginEditingStartTime() {
        editingFocus = .startTime

        if state.startTime == nil {
            state.startTime = availableTimes[0]
        }
    }

    func beginEditingDuration() {
        editingFocus = .duration

        if state.duration == nil {
            state.duration = .fortyFiveMinutes
        }
    }

    func endEditing() {
        editingFocus = .none
    }
}

struct SchedulingViewPreview: PreviewProvider {
    static var previews: some View {
        SchedulingView(
            instrument: .guitarStub,
            state: .init(),
            context: RequestLessonPlanContext()
        )
        .environment(\.locale, .init(identifier: "en_GB"))
        .previewDevices()
    }
}
