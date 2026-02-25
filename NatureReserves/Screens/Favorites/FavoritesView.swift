import SwiftUI

private enum FavoritesColors {
    static let navBar = Color(red: 17, green: 17, blue: 17)
    static let background = Color(red: 29, green: 28, blue: 30)
    static let accent = Color(red: 212, green: 175, blue: 55)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.5)
    static let separatorStart = Color(red: 104, green: 0, blue: 0)
    static let separatorEnd = Color(red: 17, green: 17, blue: 17)
}

struct FavoritesView: View {
    @Environment(\.showTabBar) private var showTabBar
    @State private var favoriteReserves: [ReserveDetailModel] = []

    private let favoritesService = FavoritesService.shared
    private var reservesCount: Int { favoriteReserves.count }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                contentView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(FavoritesColors.background)
            .onAppear {
                showTabBar?.wrappedValue = true
                refreshFavorites()
            }
        }
        .navigationBarHidden(true)
    }

    private func refreshFavorites() {
        favoriteReserves = favoritesService.favoriteIds().compactMap { ReserveDetailModel.model(forReserveId: $0) }
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Favorite Reserves")
                        .font(.poppinsBold(size: 18))
                        .foregroundColor(FavoritesColors.textPrimary)

                    Text("\(reservesCount) reserves saved")
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(FavoritesColors.textSecondary)
                }

                Spacer()

                NavigationLink(destination: {
                    SettingsView()
                        .navigationBarBackButtonHidden(true)
                        .onAppear { showTabBar?.wrappedValue = false }
                        .onDisappear { showTabBar?.wrappedValue = true }
                }) {
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
            FavoritesColors.navBar
                .ignoresSafeArea()
                .shadow(color: FavoritesColors.separatorStart, radius: 24, x: 0, y: 10)
        )
    }

    @ViewBuilder
    private var contentView: some View {
        if favoriteReserves.isEmpty {
            emptyState
        } else {
            favoritesList
        }
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "heart")
                .font(.system(size: 50))
                .foregroundColor(FavoritesColors.textSecondary)

            Text("You haven't added any reserves yet")
                .font(.poppinsBold(size: 24))
                .foregroundColor(FavoritesColors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Text("Explore the map and save your favorites!")
                .font(.poppinsRegular(size: 14))
                .foregroundColor(FavoritesColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
        .padding(.bottom, 100)
    }

    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(favoriteReserves, id: \.reserveId) { reserve in
                    NavigationLink(destination: {
                        ReserveDetailView(reserve: reserve)
                            .navigationBarBackButtonHidden(true)
.onAppear { showTabBar?.wrappedValue = false }
                        .onDisappear { refreshFavorites() }
                    }) {
                        HStack(spacing: 16) {
                            if let uiImage = UIImage(named: reserve.imageName) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(FavoritesColors.textSecondary.opacity(0.3))
                                    .frame(width: 64, height: 64)
                                    .overlay(Image(systemName: "photo").foregroundColor(FavoritesColors.textSecondary))
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(reserve.name)
                                    .font(.poppinsBold(size: 16))
                                    .foregroundColor(FavoritesColors.textPrimary)
                                Text(reserve.country)
                                    .font(.poppinsRegular(size: 14))
                                    .foregroundColor(FavoritesColors.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(FavoritesColors.textSecondary)
                        }
                        .padding(16)
                        .background(Color(red: 52, green: 52, blue: 52))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    FavoritesView()
}
