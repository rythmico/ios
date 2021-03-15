import SwiftUI

struct LessonPlanApplicationDetailAboutView: View {
    @ObservedObject
    var coordinator: APIActivityCoordinator<GetPortfolioRequest>

    var tutor: Tutor

    var body: some View {
        ZStack {
            content
        }
        .onAppear(perform: fetchPortfolio)
        .onDisappear(perform: coordinator.cancel)
        .alertOnFailure(coordinator)
    }

    @ViewBuilder
    private var content: some View {
        switch coordinator.state {
        case .ready, .suspended, .finished(.failure), .idle:
            Color.clear
        case .loading:
            ActivityIndicator(color: .rythmicoGray90).frame(maxWidth: .infinity, maxHeight: .infinity)
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
            coordinator: Current.portfolioFetchingCoordinator(),
            tutor: .charlotteStub
        )
    }
}
#endif
