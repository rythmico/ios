import SwiftUI

enum RootViewData {
    case unauthenticated(OnboardingView)
    case authenticated(MainTabView)

    var onboardingView: OnboardingView? {
        guard case .unauthenticated(let onboardingView) = self else {
            return nil
        }
        return onboardingView
    }

    var mainTabView: MainTabView? {
        guard case .authenticated(let mainTabView) = self else {
            return nil
        }
        return mainTabView
    }
}

struct RootView: View, ViewModelable {
    @ObservedObject var viewModel: RootViewModel

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            viewData.onboardingView.zIndex(1).transition(AnyTransition.move(edge: .leading))
            viewData.mainTabView.zIndex(2).transition(AnyTransition.move(edge: .trailing))
        }
        .animation(.easeInOut(duration: 0.35), value: viewData.mainTabView != nil)
    }
}
