import SwiftUI

private enum NotificationsColors {
    static let navBar = Color(red: 17, green: 17, blue: 17)
    static let background = Color(red: 29, green: 28, blue: 30)
    static let cellGradientStart = Color(red: 34, green: 34, blue: 34)
    static let cellGradientEnd = Color(red: 17, green: 17, blue: 17)
    static let accent = Color(red: 212, green: 175, blue: 55)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.4)
    static let shadowColor = Color(red: 104, green: 0, blue: 0)
    static let infoBannerBg = Color(red: 76, green: 175, blue: 80)
}

private struct NotificationItem: Identifiable {
    let id = UUID()
    let iconEmoji: String
    let iconBgColor: Color
    let title: String
    let description: String
    let timestamp: String
}

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.showTabBar) private var showTabBar
    private let notifications: [NotificationItem] = [
        NotificationItem(
            iconEmoji: "🌋",
            iconBgColor: Color(red: 17, green: 17, blue: 17),
            title: "Did you know?",
            description: "Yellowstone has over 500 geysers!",
            timestamp: "2 hours ago"
        ),
        NotificationItem(
            iconEmoji: "🐠",
            iconBgColor: Color(red: 230, green: 233, blue: 81),
            title: "Marine Life Discovery",
            description: "Explore marine life in the Great Barrier Reef.",
            timestamp: "5 hours ago"
        ),
        NotificationItem(
            iconEmoji: "🌳",
            iconBgColor: Color(red: 94, green: 102, blue: 132),
            title: "New Fact Added",
            description: "New fact added about the Amazon Rainforest.",
            timestamp: "1 day ago"
        ),
        NotificationItem(
            iconEmoji: "🦓",
            iconBgColor: Color(red: 186, green: 190, blue: 206),
            title: "Wildlife Update",
            description: "Serengeti migration season has begun!",
            timestamp: "2 days ago"
        ),
        NotificationItem(
            iconEmoji: "🦏",
            iconBgColor: Color(red: 206, green: 186, blue: 193),
            title: "Conservation News",
            description: "Kruger National Park celebrates conservation success.",
            timestamp: "3 days ago"
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(NotificationsColors.background)
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                Button(action: { dismiss() }) {
                    Image(.backButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Notifications")
                        .font(.poppinsBold(size: 18))
                        .foregroundColor(NotificationsColors.textPrimary)

                    Text("Stay updated with nature news")
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(NotificationsColors.textSecondary)
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
            NotificationsColors.navBar
                .ignoresSafeArea()
                .shadow(color: NotificationsColors.shadowColor, radius: 24, x: 0, y: 10)
        )
    }

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                infoBanner
                notificationList
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
    }

    private var infoBanner: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "info.circle")
                .font(.system(size: 24))
                .foregroundColor(Color(red: 76, green: 175, blue: 80))

            Text("These are static local notifications. No data is collected or sent online.")
                .font(.poppinsRegular(size: 14))
                .foregroundColor(NotificationsColors.textPrimary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(NotificationsColors.infoBannerBg.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var notificationList: some View {
        VStack(spacing: 12) {
            ForEach(notifications) { item in
                notificationCard(item: item)
            }
        }
    }

    private func notificationCard(item: NotificationItem) -> some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(item.iconBgColor)
                    .frame(width: 56, height: 56)

                Text(item.iconEmoji)
                    .font(.system(size: 24))
            }

            VStack(alignment: .leading, spacing: 14) {
                Text(item.title)
                    .font(.poppinsSemiBold(size: 18))
                    .foregroundColor(NotificationsColors.textPrimary)

                Text(item.description)
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(NotificationsColors.textSecondary)

                Text(item.timestamp)
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(NotificationsColors.textSecondary)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color(red: 52, green: 52, blue: 52))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    NotificationsView()
}
