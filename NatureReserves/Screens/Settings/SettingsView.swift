import SwiftUI

private enum SettingsColors {
    static let navBar = Color(red: 17, green: 17, blue: 17)
    static let background = Color(red: 29, green: 28, blue: 30)
    static let cardBackground = Color(red: 52, green: 52, blue: 52)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let shadowColor = Color(red: 104, green: 0, blue: 0)
    static let toggleOn = Color(red: 76, green: 175, blue: 80)
    static let aboutGreen = Color(red: 34, green: 139, blue: 34)
    static let privacyGreen = Color(red: 40, green: 90, blue: 50)
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsOn = true
    @State private var pushOn = false
    @State private var vibrationOn = false
    @State private var soundEffectsOn = true

    private let settings = SettingsService.shared

    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SettingsColors.background)
        .onAppear {
            notificationsOn = settings.notificationsOn
            pushOn = settings.pushOn
            vibrationOn = settings.vibrationOn
            soundEffectsOn = settings.soundEffectsOn
        }
        .onChange(of: notificationsOn) { settings.notificationsOn = $0 }
        .onChange(of: pushOn) { settings.pushOn = $0 }
        .onChange(of: vibrationOn) { settings.vibrationOn = $0 }
        .onChange(of: soundEffectsOn) { settings.soundEffectsOn = $0 }
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                Button(action: { dismiss() }) {
                    Image("backButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Settings")
                        .font(.poppinsBold(size: 18))
                        .foregroundColor(SettingsColors.textPrimary)

                    Text("Customize your experience")
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(SettingsColors.textSecondary)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .background(
            SettingsColors.navBar
                .ignoresSafeArea()
                .shadow(color: SettingsColors.shadowColor, radius: 24, x: 0, y: 10)
        )
    }

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                togglesSection
                aboutSection
                privacySection
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
    }

    private var togglesSection: some View {
        VStack(spacing: 14) {
            toggleRow(title: "Notifications", isOn: $notificationsOn)

            toggleRow(title: "Push", isOn: $pushOn)

            toggleRow(title: "Vibration", isOn: $vibrationOn)

            toggleRow(title: "Sound Effects", isOn: $soundEffectsOn)
        }
    }

    private func toggleRow(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .font(.poppinsSemiBold(size: 16))
                .foregroundColor(SettingsColors.textPrimary)

            Spacer()

            Toggle("", isOn: isOn)
                .tint(SettingsColors.toggleOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(SettingsColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.system(size: 20))
                    .foregroundColor(SettingsColors.toggleOn)
                Text("About This App")
                    .font(.poppinsMedium(size: 18))
                    .foregroundColor(SettingsColors.textPrimary)
            }

            Text("World Reserves Explorer is an offline educational application designed to inspire curiosity about global conservation areas and protected ecosystems. The app works entirely without internet access and does not collect any personal data.")
                .font(.poppinsRegular(size: 14))
                .foregroundColor(SettingsColors.textPrimary)

            VStack(spacing: 8) {
                aboutRow(key: "Version", value: "1.0.0")
                aboutRow(key: "Platform", value: "iOS")
                aboutRow(key: "Data Storage", value: "Local Only")
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SettingsColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func aboutRow(key: String, value: String) -> some View {
        HStack {
            Text(key)
                .font(.poppinsRegular(size: 14))
                .foregroundColor(SettingsColors.textSecondary)
            Spacer()
            Text(value)
                .font(.poppinsRegular(size: 14))
                .foregroundColor(SettingsColors.textSecondary)
        }
    }

    private var privacySection: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("🔒 Your privacy is important. This app stores all data locally on your device and never sends information to external servers.")
                .font(.poppinsRegular(size: 14))
                .foregroundColor(SettingsColors.textPrimary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SettingsColors.toggleOn.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(SettingsColors.toggleOn, lineWidth: 1)
        }
    }
}

#Preview {
    SettingsView()
}
