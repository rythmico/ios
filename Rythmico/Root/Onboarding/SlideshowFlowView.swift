import SwiftUISugar

// TODO: maybe build on top of Flow module?

protocol SlideshowFlowStep: CaseIterable, Hashable where AllCases: RandomAccessCollection, AllCases.Index == Int {}

extension SlideshowFlowStep {
    private var index: AllCases.Index? {
        Self.allCases.firstIndex(of: self)
    }

    fileprivate static func step(at index: AllCases.Index) -> Self? {
        Self.allCases[safe: index]
    }

    var previous: Self? {
        index.map { $0 - 1 }.flatMap(Self.step)
    }

    var next: Self? {
        index.map { $0 + 1 }.flatMap(Self.step)
    }
}

struct SlideshowFlowView<Step: SlideshowFlowStep, Content: View, EndButton: View>: View {
    @State
    private var step: Step
    @ViewBuilder
    private var content: (Step) -> Content
    @ViewBuilder
    private var endButton: EndButton

    init(
        _ stepType: Step.Type,
        @ViewBuilder content: @escaping (Step) -> Content,
        @ViewBuilder endButton: @escaping () -> EndButton
    ) {
        let initialStep = Step.step(at: 0) !! preconditionFailure("No step cases found in type \(stepType)")
        self._step = .init(initialValue: initialStep)
        self.content = content
        self.endButton = endButton()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton.padding(.leading, .grid(1.5))
            VStack(spacing: .grid(5)) {
                PagingView(
                    data: Step.allCases,
                    selection: $step,
                    spacing: 0,
                    accentColor: .clear,
                    showsIndicator: false,
                    content: content
                )
                bottomButton.padding(.horizontal, .grid(5))
            }
        }
        .animation(.rythmicoSpring(duration: .durationShort), value: step)
        .accentColor(.rythmico.picoteeBlue)
        .padding(.bottom, .grid(5))
    }

    @ViewBuilder
    var backButton: some View {
        if let back = back {
            BackButton(action: back)
        } else {
            BackButton(action: {}).hidden()
        }
    }

    @ViewBuilder
    var bottomButton: some View {
        if let next = next {
            RythmicoButton("Next", style: .primary(), action: next)
        } else {
            endButton
        }
    }

    private var back: Action? { step.previous.mapToAction(go) }
    private var next: Action? { step.next.mapToAction(go) }

    private func go(to step: Step) {
        guard self.step != step else { return }
        self.step = step
    }
}

#if DEBUG
struct SlideshowFlowView_Previews: PreviewProvider {
    enum Step: SlideshowFlowStep {
        case one
        case two
        case three
    }

    static var previews: some View {
        SlideshowFlowView(Step.self) { step in
            switch step {
            case .one:
                Text("One").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
            case .two:
                Text("Two").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.green)
            case .three:
                Text("Three").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
            }
        } endButton: {
            RythmicoButton("Done", style: .secondary(), action: nil)
        }
    }
}
#endif
