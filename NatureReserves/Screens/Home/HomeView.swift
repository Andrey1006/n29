import SwiftUI

private enum HomeColors {
    static let navBar = Color(red: 17, green: 17, blue: 17)
    static let background = Color(red: 29, green: 28, blue: 30)
    static let cellGradientStart = Color(red: 34, green: 34, blue: 34)
    static let cellGradientEnd = Color(red: 17, green: 17, blue: 17)
    static let accent = Color(red: 212, green: 175, blue: 55)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.5)
}

private enum HomeGridAction {
    case exploreMap
    case popularReserves
    case interestingFacts
    case favorites
    case notifications
}

private struct HomeGridItem: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let action: HomeGridAction
}

struct HomeView: View {
    @Environment(\.selectedTab) private var selectedTabBinding
    @Environment(\.showTabBar) private var showTabBar

    @State private var navigationPath = NavigationPath()
    @State private var displayName = "Username"
    @State private var avatarId = 1

    private let profileService = UserProfileService.shared

    private let gridItems: [HomeGridItem] = [
        HomeGridItem(iconName: "homeIcon1", title: "Explore Map", action: .exploreMap),
        HomeGridItem(iconName: "homeIcon3", title: "Interesting Facts", action: .interestingFacts),
        HomeGridItem(iconName: "homeIcon4", title: "Favorites", action: .favorites),
        HomeGridItem(iconName: "homeIcon5", title: "Notifications", action: .notifications)
    ]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                headerView
                contentView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(HomeColors.background)
            .onAppear {
                showTabBar?.wrappedValue = true
                displayName = profileService.getDisplayName()
                avatarId = profileService.getAvatarId()
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .interestingFacts:
                    InterestingFactsView()
                        .navigationBarBackButtonHidden(true)
                        .environment(\.showTabBar, showTabBar)
                        .onAppear { showTabBar?.wrappedValue = false }
                case .notifications:
                    NotificationsView()
                        .navigationBarBackButtonHidden(true)
                        .environment(\.showTabBar, showTabBar)
                        .onAppear { showTabBar?.wrappedValue = false }
                case .settings:
                    SettingsView()
                        .navigationBarBackButtonHidden(true)
                        .environment(\.showTabBar, showTabBar)
                        .onAppear { showTabBar?.wrappedValue = false }
                }
            }
        }
    }
}

private enum HomeRoute: Hashable {
    case interestingFacts
    case notifications
    case settings
}

extension HomeView {

    private var headerView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                Image(avatarId >= 1 && avatarId <= 4 ? ["icon1", "icon2", "icon3", "icon4"][avatarId - 1] : "avatarPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(displayName) 👋")
                        .font(.poppinsSemiBold(size: 14))
                        .foregroundColor(HomeColors.textPrimary)
                    
                    Text("Explore the world's nature reserves.")
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(HomeColors.textSecondary)
                }

                Spacer()

                Button(action: { navigationPath.append(HomeRoute.settings) }) {
                    Image(.settingsButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .background(
            HomeColors.navBar
                .ignoresSafeArea()
                .shadow(color: Color(red: 104, green: 0, blue: 0), radius: 24, x: 0, y: 10)
        )
    }

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                gridCell(item: gridItems[0])
                
                HStack(spacing: 16) {
                    gridCell(item: gridItems[1])
                    gridCell(item: gridItems[2])
                }
                
                gridCell(item: gridItems[3])
            }
            .padding(20)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
        .navigationBarHidden(true)
    }

    private func handleGridAction(_ action: HomeGridAction) {
        switch action {
        case .exploreMap:
            selectedTabBinding?.wrappedValue = .map
        case .popularReserves:
            break
        case .interestingFacts:
            navigationPath.append(HomeRoute.interestingFacts)
        case .favorites:
            selectedTabBinding?.wrappedValue = .favorites
        case .notifications:
            navigationPath.append(HomeRoute.notifications)
        }
    }

    private func gridCell(item: HomeGridItem) -> some View {
        Button(action: { handleGridAction(item.action) }) {
            VStack(alignment: .leading, spacing: 12) {
                Image(item.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                Spacer()
                Spacer()

                Text(item.title)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(HomeColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(
                LinearGradient(
                    colors: [HomeColors.cellGradientStart, HomeColors.cellGradientEnd],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
}
