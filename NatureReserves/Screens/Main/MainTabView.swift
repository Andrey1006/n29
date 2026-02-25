import SwiftUI

private struct SelectedTabKey: EnvironmentKey {
    static let defaultValue: Binding<MainTab>? = nil
}

private struct ShowTabBarKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var selectedTab: Binding<MainTab>? {
        get { self[SelectedTabKey.self] }
        set { self[SelectedTabKey.self] = newValue }
    }

    var showTabBar: Binding<Bool>? {
        get { self[ShowTabBarKey.self] }
        set { self[ShowTabBarKey.self] = newValue }
    }
}

enum MainTab: CaseIterable {
    case home
    case map
    case favorites
    case profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .map: return "Map"
        case .favorites: return "Favorites"
        case .profile: return "Profile"
        }
    }

    var systemImageName: String {
        switch self {
        case .home: return "house"
        case .map: return "map"
        case .favorites: return "star"
        case .profile: return "person"
        }
    }
}

private enum MainTabColors {
    static let background = Color(red: 17, green: 17, blue: 17)
    static let accent = Color(red: 255, green: 187, blue: 0)
    static let inactive = Color.white.opacity(0.5)
}

struct CustomTabBarView: View {
    @Binding var selectedTab: MainTab

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 32) {
                ForEach(MainTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: tab.systemImageName)
                                .font(.system(size: 20, weight: .bold))
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedTab == tab ? MainTabColors.accent : MainTabColors.inactive)

                            Text(tab.title)
                                .font(.poppinsRegular(size: 12))
                                .foregroundColor(selectedTab == tab ? MainTabColors.accent : MainTabColors.inactive)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .background(
            MainTabColors.background
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

struct MainTabView: View {
    @State private var selectedTab: MainTab = .home
    @State private var showTabBar = true

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                        .environment(\.selectedTab, $selectedTab)
                        .environment(\.showTabBar, $showTabBar)
                case .map:
                    ExploreReservesView()
                        .environment(\.showTabBar, $showTabBar)
                case .favorites:
                    FavoritesView()
                        .environment(\.showTabBar, $showTabBar)
                case .profile:
                    ProfileView()
                        .environment(\.showTabBar, $showTabBar)
                }
            }
            .ignoresSafeArea(edges: .bottom)

            if showTabBar {
                CustomTabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}

