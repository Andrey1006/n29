import SwiftUI
import MapKit

struct NatureReserve: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    let imageName: String

    static func == (lhs: NatureReserve, rhs: NatureReserve) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

private enum ExploreColors {
    static let navBar = Color(red: 17, green: 17, blue: 17)
    static let background = Color(red: 29, green: 28, blue: 30)
    static let cardBackground = Color(red: 52, green: 52, blue: 52)
    static let accent = Color(red: 255, green: 187, blue: 0)
    static let segmentActive = Color(red: 54, green: 120, blue: 147)
    static let segmentInactive = Color.white.opacity(0.1)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.5)
    static let shadowColor = Color(red: 104, green: 0, blue: 0)
}

struct ExploreReservesView: View {
    @Environment(\.showTabBar) private var showTabBar

    enum ViewMode: String, CaseIterable {
        case map = "Map"
        case list = "List"
    }

    @State private var selectedMode: ViewMode = .map
    @State private var selectedReserve: NatureReserve?
    private let favoritesService = FavoritesService.shared
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
    )

    private let reserves: [NatureReserve] = [
        NatureReserve(id: "fiordland_newzealand", name: "Fiordland National Park", country: "New Zealand", latitude: -45.4, longitude: 167.2, imageName: "FiordlandNationalPark"),
        NatureReserve(id: "greatbarrierreef_australia", name: "Great Barrier Reef Marine Park", country: "Australia", latitude: -18.3, longitude: 147.7, imageName: "GreatBarrierReefMarinePark"),
        NatureReserve(id: "kruger_southafrica", name: "Kruger National Park", country: "South Africa", latitude: -24.0, longitude: 31.5, imageName: "KrugerNationalPark"),
        NatureReserve(id: "yellowstone_usa", name: "Yellowstone National Park", country: "United States", latitude: 44.6, longitude: -110.5, imageName: "YellowstoneNationalPark"),
        NatureReserve(id: "serengeti_tanzania", name: "Serengeti National Park", country: "Tanzania", latitude: -2.3, longitude: 34.8, imageName: "SerengetiNationalPark"),
        NatureReserve(id: "amazon_brazil", name: "Amazon Rainforest", country: "Brazil", latitude: -3.4, longitude: -60.0, imageName: "AmazonRainforest"),
        NatureReserve(id: "galapagos_ecuador", name: "Galápagos National Park", country: "Ecuador", latitude: -0.9, longitude: -89.6, imageName: "GalapagosNationalPark"),
        NatureReserve(id: "plitvice_croatia", name: "Plitvice Lakes National Park", country: "Croatia", latitude: 44.9, longitude: 15.6, imageName: "PlitviceLakesNationalPark"),
        NatureReserve(id: "banff_canada", name: "Banff National Park", country: "Canada", latitude: 51.5, longitude: -116.0, imageName: "BanffNationalPark"),
        NatureReserve(id: "tsingy_madagascar", name: "Tsingy de Bemaraha National Park", country: "Madagascar", latitude: -18.9, longitude: 44.6, imageName: "tsingyDeBemarahaNationalPark")
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                segmentedControl
                contentView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ExploreColors.background)
            .onAppear {
                showTabBar?.wrappedValue = true
                fitMapRegionToReserves()
            }
        }
        .navigationBarHidden(true)
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Explore Nature Reserves")
                        .font(.poppinsBold(size: 18))
                        .foregroundColor(ExploreColors.textPrimary)

                    Text("Tap on a pin to learn more")
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(ExploreColors.textSecondary)
                }

                Spacer()

                NavigationLink(destination: {
                    SettingsView()
                        .navigationBarBackButtonHidden(true)
                        .onAppear { showTabBar?.wrappedValue = false }
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
            ExploreColors.navBar
                .ignoresSafeArea()
                .shadow(color: ExploreColors.shadowColor, radius: 24, x: 0, y: 10)
        )
    }

    private var segmentedControl: some View {
        HStack(spacing: 10) {
            ForEach(ViewMode.allCases, id: \.self) { mode in
                Button(action: { selectedMode = mode }) {
                    HStack(spacing: 8) {
                        Image(systemName: mode == .map ? "map" : "list.bullet")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                        Text(mode.rawValue)
                            .font(.poppinsSemiBold(size: 14))
                    }
                    .foregroundColor(ExploreColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(selectedMode == mode ? ExploreColors.segmentActive : ExploreColors.segmentInactive)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
    }

    @ViewBuilder
    private var contentView: some View {
        switch selectedMode {
        case .map:
            mapView
        case .list:
            listView
        }
    }

    private func fitMapRegionToReserves() {
        guard !reserves.isEmpty else { return }
        let lats = reserves.map(\.latitude)
        let lons = reserves.map(\.longitude)
        let minLat = lats.min() ?? 0
        let maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0
        let maxLon = lons.max() ?? 0
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let spanLat = min(max((maxLat - minLat) * 1.4, 20), 180)
        let spanLon = min(max((maxLon - minLon) * 1.4, 40), 360)
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLon)
        )
    }

    private var mapView: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, annotationItems: reserves) { reserve in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: reserve.latitude, longitude: reserve.longitude)) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedReserve = reserve
                        }
                    }) {
                        ZStack {
                            if selectedReserve?.id == reserve.id {
                                Circle()
                                    .fill(ExploreColors.accent.opacity(0.3))
                                    .frame(width: 44, height: 44)
                                Circle()
                                    .stroke(ExploreColors.accent, lineWidth: 2)
                                    .frame(width: 44, height: 44)
                            }
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: selectedReserve?.id == reserve.id ? 36 : 28))
                                .foregroundColor(selectedReserve?.id == reserve.id ? ExploreColors.accent : Color(red: 100, green: 180, blue: 255))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            if let reserve = selectedReserve, let detailModel = ReserveDetailModel.model(forReserveId: reserve.id) {
                NavigationLink(destination: {
                    ReserveDetailView(reserve: detailModel)
                        .navigationBarBackButtonHidden(true)
                        .onAppear { showTabBar?.wrappedValue = false }
                }) {
                    reserveDetailCard(reserve)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }

    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(reserves) { reserve in
                    reserveListRow(reserve)
                }
            }
            .padding(20)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }

    private func reserveDetailCard(_ reserve: NatureReserve) -> some View {
        HStack(spacing: 16) {
            reserveThumbnail(reserve.imageName)
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(reserve.name)
                    .font(.poppinsBold(size: 16))
                    .foregroundColor(ExploreColors.textPrimary)
                Text(reserve.country)
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(ExploreColors.textSecondary)
            }

            Spacer()

            if favoritesService.isFavorite(reserveId: reserve.id) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 18))
                    .foregroundColor(ExploreColors.accent)
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ExploreColors.textSecondary)
        }
        .padding(16)
        .background(ExploreColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(ExploreColors.accent, lineWidth: 1)
        )
        .shadow(color: ExploreColors.accent, radius: 10, x: 0, y: 0)
    }

    private func reserveListRow(_ reserve: NatureReserve) -> some View {
        Group {
            if let detailModel = ReserveDetailModel.model(forReserveId: reserve.id) {
                NavigationLink(destination: {
                    ReserveDetailView(reserve: detailModel)
                        .navigationBarBackButtonHidden(true)
                        .onAppear { showTabBar?.wrappedValue = false }
                }) {
                    reserveListRowContent(reserve)
                }
                .buttonStyle(.plain)
            } else {
                reserveListRowContent(reserve)
            }
        }
    }

    private func reserveListRowContent(_ reserve: NatureReserve) -> some View {
        HStack(spacing: 16) {
            reserveThumbnail(reserve.imageName)
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(reserve.name)
                    .font(.poppinsBold(size: 16))
                    .foregroundColor(ExploreColors.textPrimary)
                Text(reserve.country)
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(ExploreColors.textSecondary)
            }

            Spacer()

            if favoritesService.isFavorite(reserveId: reserve.id) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 18))
                    .foregroundColor(ExploreColors.accent)
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ExploreColors.textSecondary)
        }
        .padding(16)
        .background(ExploreColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    @ViewBuilder
    private func reserveThumbnail(_ imageName: String) -> some View {
        if let uiImage = UIImage(named: imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            Rectangle()
                .fill(ExploreColors.segmentInactive)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 28))
                        .foregroundColor(ExploreColors.textSecondary)
                )
        }
    }
}

#Preview {
    ExploreReservesView()
}
