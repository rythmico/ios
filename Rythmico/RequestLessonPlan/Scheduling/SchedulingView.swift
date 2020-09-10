import SwiftUI
import Sugar

protocol SchedulingContext {
    func setSchedule(_ schedule: Schedule)
}

// TODO: refactor date logic into a manager class from
// which to observe available dates and times, with injectable calendar.
struct SchedulingView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var startDate: Date?
        @Published var startTime = Date(timeIntervalSinceReferenceDate: 0).setting(hour: 16)
        @Published var duration: Duration?
    }

    @ObservedObject private(set) var state: ViewState

    enum EditingFocus {
        case startDate
        case startTime
        case duration
    }

    @State private(set) var editingFocus: EditingFocus? = .none
    @Namespace private var startDatePickerAnimation

    private let instrument: Instrument
    private let context: SchedulingContext
    private let dateFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private let firstAvailableDate = Current.date() + (2, .day)

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
        "Enter when you want the " +
        "\(instrument.name) lessons".style(.bodyBold) +
        " to commence and for how long"
    }

    var startDateText: String { state.startDate.map(dateFormatter.string(from:)) ?? .empty }
    var durationText: String { state.duration.map { "\($0.rawValue) minutes" } ?? .empty }

    var nextButtonAction: Action? {
        guard
            let startDate = state.startDate,
            let startDateAndTime = Date(date: startDate, time: state.startTime),
            let duration = state.duration
        else {
            return nil
        }

        return {
            context.setSchedule(
                Schedule(startDate: startDateAndTime, duration: duration)
            )
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(title: "Lesson Schedule", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: .spacingLarge) {
                        HeaderContentView(title: "Start Date") {
                            ZStack {
                                if editingFocus != .startDate {
                                    CustomTextField(
                                        "Select a date...",
                                        text: .constant(startDateText),
                                        isEditable: false
                                    )
                                    .onTapGesture(perform: beginEditingStartDate)
                                    .transition(.opacity)
                                    .matchedGeometryEffect(
                                        id: startDatePickerAnimation,
                                        in: startDatePickerAnimation,
                                        properties: .size
                                    )
                                }

                                if editingFocus == .startDate {
                                    DatePicker(
                                        "",
                                        selection: Binding(
                                            get: { state.startDate ?? firstAvailableDate },
                                            set: { state.startDate = $0 }
                                        ),
                                        in: PartialRangeFrom(firstAvailableDate),
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding(.horizontal, .spacingUnit * 2)
                                    .padding(.top, .spacingUnit)
                                    .transition(.opacity)
                                    .matchedGeometryEffect(
                                        id: startDatePickerAnimation,
                                        in: startDatePickerAnimation,
                                        properties: .size
                                    )
                                }
                            }
                            .modifier(RoundedThinOutlineContainer(padded: false))
                        }

                        HStack(spacing: .spacingExtraSmall) {
                            HeaderContentView(title: "Time") {
                                DatePicker("", selection: $state.startTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .modifier(RoundedThinOutlineContainer(padded: false))
                                    .onTapGesture(perform: beginEditingStartTime)
                            }

                            HeaderContentView(title: "Duration") {
                                CustomTextField(
                                    "Duration...",
                                    text: .constant(durationText),
                                    isEditable: false
                                )
                                .modifier(RoundedThinOutlineContainer(padded: false))
                                .onTapGesture(perform: beginEditingDuration)
                            }
                        }

                        HeaderContentView(title: "Please note:") {
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

                    if editingFocus == .duration {
                        FloatingInputView(doneAction: endEditing) {
                            BetterPicker(
                                selection: Binding(
                                    get: { state.duration ?? .fortyFiveMinutes },
                                    set: { state.duration = $0 }
                                ),
                                formatter: { "\($0.rawValue) minutes" }
                            )
                        }
                        .zIndex(1)
                    }
                }
            }
        }
        .accentColor(.rythmicoPurple)
        .animation(.easeInOut(duration: .durationMedium), value: editingFocus)
        .testable(self)
    }

    func beginEditingStartDate() {
        editingFocus = .startDate

        if state.startDate == nil {
            state.startDate = firstAvailableDate
        }
    }

    func beginEditingStartTime() {
        editingFocus = .startTime
    }

    func beginEditingDuration() {
        editingFocus = .duration

        if state.duration == nil {
            state.duration = .oneHour
        }
    }

    func endEditing() {
        editingFocus = .none
    }
}

#if DEBUG
struct SchedulingViewPreview: PreviewProvider {
    static var previews: some View {
        SchedulingView(
            instrument: .guitar,
            state: SchedulingView.ViewState(),
            context: RequestLessonPlanContext()
        )
        .environment(\.locale, .init(identifier: "en_GB"))
        .previewDevices()
    }
}
#endif
