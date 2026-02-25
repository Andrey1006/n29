import SwiftUI

enum RootScreen {
    case createProfile
    case onboarding
    case mainTab
}

struct RootView: View {
    @StateObject private var authState = AuthStateObserver()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @State private var currentScreen: RootScreen = .createProfile

    var body: some View {
        Group {
            switch currentScreen {
            case .createProfile:
                CreateProfileView(
                    onAuthSuccess: { goAfterAuth() },
                    onAnonymousSuccess: { goToOnboarding() }
                )
            case .onboarding:
                OnboardingView(onComplete: { finishOnboarding() })
            case .mainTab:
                MainTabView()
            }
        }
        .onChange(of: authState.isLoggedIn) { isLoggedIn in
            if !isLoggedIn {
                currentScreen = .createProfile
            } else {
                resolveInitialScreen()
            }
        }
        .onAppear(perform: resolveInitialScreen)
    }

    private func resolveInitialScreen() {
        if !authState.isLoggedIn {
            currentScreen = .createProfile
        } else if !hasCompletedOnboarding {
            currentScreen = .onboarding
        } else {
            currentScreen = .mainTab
        }
    }

    private func goAfterAuth() {
        if hasCompletedOnboarding {
            currentScreen = .mainTab
        } else {
            goToOnboarding()
        }
    }

    private func goToOnboarding() {
        currentScreen = .onboarding
    }

    private func finishOnboarding() {
        hasCompletedOnboarding = true
        currentScreen = .mainTab
    }
}

#Preview {
    RootView()
}
