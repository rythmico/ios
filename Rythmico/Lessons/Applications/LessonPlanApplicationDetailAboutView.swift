import SwiftUI

struct LessonPlanApplicationDetailAboutView: View, VisibleView {
    @StateObject
    var coordinator: APIActivityCoordinator<GetPortfolioRequest>
    @State
    var isVisible = false

    var tutor: LessonPlan.Tutor

    var body: some View {
        ZStack {
            content
        }
        .visible(self)
        .onAppearOrForeground(self, perform: fetchPortfolio)
        .onDisappear(perform: coordinator.cancel)
        .alertOnFailure(coordinator)
    }

    @ViewBuilder
    private var content: some View {
        switch coordinator.state {
        case .ready, .suspended, .finished(.failure), .idle:
            Color(.systemBackground)
        case .loading:
            ZStack {
                Color(.systemBackground)
                ActivityIndicator(color: .rythmicoGray90)
            }
        case .finished(.success(let portfolio)):
            PortfolioView(tutor: tutor, portfolio: portfolio)
        }
    }

    private func fetchPortfolio() {
        coordinator.start(with: .init(tutorId: tutor.id))
    }
}

#if DEBUG
struct LessonPlanApplicationDetailAboutView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanApplicationDetailAboutView(
            coordinator: Current.coordinator(for: \.portfolioFetchingService)!,
            tutor: .charlotteStub
        )
    }
}
#endif
