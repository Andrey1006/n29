import SwiftUI

private struct FactItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

private enum FactsColors {
    static let navBar = Color(red: 17, green: 17, blue: 17)
    static let background = Color(red: 29, green: 28, blue: 30)
    static let cardBackground = Color(red: 52, green: 52, blue: 52)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let shadowColor = Color(red: 104, green: 0, blue: 0)
}

struct InterestingFactsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.showTabBar) private var showTabBar
    @State private var expandedIds: Set<UUID> = []

    private let facts: [FactItem] = [
        FactItem(
            title: "Yellowstone Geothermal Wonders",
            description: "Yellowstone is home to more than 500 active geysers, which represents the largest concentration in the world. The park sits on top of a massive volcanic system that powers these incredible thermal features. It spans across three U.S. states: Wyoming, Montana, and Idaho. Yellowstone was established in 1872 and became the first national park in the entire world. Gray wolves were successfully reintroduced to the park in 1995 after decades of absence. Their return dramatically reshaped the ecosystem through a phenomenon known as a trophic cascade. The park contains vast forests of lodgepole pine, subalpine fir, and Engelmann spruce. Yellowstone Lake is one of the largest high-elevation lakes in North America. Free-roaming bison herds, the largest in the United States, roam freely across its expansive plains. Over four million visitors explore this remarkable natural laboratory every year."
        ),
        FactItem(
            title: "The Great Migration",
            description: "The Serengeti hosts the world's largest terrestrial mammal migration annually. Over 1.5 million wildebeest participate in this circular journey across the ecosystem. They are joined by approximately 200,000 zebras and 350,000 gazelles in this spectacular movement. The migration follows seasonal rains in search of fresh grazing and water. Predators including lions, leopards, and crocodiles follow the herds throughout their journey. The Mara River crossing is one of nature's most dramatic and dangerous wildlife spectacles. This ancient migration pattern has occurred for over one million years. The movement of these animals helps maintain the health of the grassland ecosystem. Thousands of wildebeest calves are born within a synchronized three-week period. This incredible natural phenomenon attracts wildlife enthusiasts and researchers from around the globe."
        ),
        FactItem(
            title: "Amazon's Oxygen Production",
            description: "The Amazon Rainforest produces approximately 20% of the world's oxygen supply. It contains more than 40,000 different plant species, many still unknown to science. The forest stores an estimated 150-200 billion tons of carbon in its vegetation and soils. The Amazon River system contains about 20% of the world's fresh water. Over 400 indigenous tribes call the Amazon home, each with unique cultures and languages. The forest's canopy creates its own weather system, with trees releasing moisture that forms clouds. Scientists estimate that a new species is discovered in the Amazon every three days on average. The forest floor receives only about 2% of sunlight due to the dense canopy above. Deforestation has already claimed about 17% of the original Amazon forest. The Amazon's health is critical to regulating the global climate and weather patterns."
        ),
        FactItem(
            title: "Kruger's Wildlife Density",
            description: "Kruger National Park hosts more species of large mammals than any other African game reserve. The park is home to approximately 12,000 elephants, one of the largest populations on the continent. It contains over 1,000 leopards, though these elusive cats are rarely seen by visitors. The park's bird checklist includes over 500 species, making it a world-class birding destination. Ancient baobab trees, some over 1,000 years old, dot the northern landscape. The Kruger supports more than 147 mammal species within its boundaries. Archaeological sites in the park contain evidence of human habitation dating back thousands of years. The park employs advanced technology including drones and AI to combat rhinoceros poaching. Over 2,000 plant species provide diverse habitats and food sources for wildlife. The park's management pioneered many modern wildlife conservation techniques still used worldwide."
        ),
        FactItem(
            title: "Great Barrier Reef Coral Cities",
            description: "The Great Barrier Reef is the world's largest living structure, visible even from outer space. It comprises approximately 2,900 individual reefs and 900 islands spread over a vast area. The reef provides habitat for about 1,500 fish species and one-third of the world's soft corals. Six of the world's seven sea turtle species use the reef for nesting and feeding. Coral polyps, tiny animals related to jellyfish, build the massive reef structures through calcium carbonate secretion. The reef supports commercial fisheries worth billions of dollars to Australia's economy. Climate change has caused several major coral bleaching events in recent decades. Scientists estimate the reef's age at approximately 500,000 years old. The reef ecosystem includes not just coral but also seagrass beds and mangrove forests. Conservation efforts include coral restoration programs and water quality improvement initiatives."
        ),
        FactItem(
            title: "Banff's Mountain Wildlife",
            description: "Banff National Park was Canada's first national park, established in 1885. The park contains over 1,000 glaciers within its mountainous terrain. Grizzly bears in Banff can weigh up to 800 pounds and live for 25 years. The park's highway features wildlife overpasses and underpasses to prevent animal-vehicle collisions. Lake Louise's stunning turquoise color comes from glacial rock flour suspended in the water. The park sits within the Canadian Rocky Mountain Parks UNESCO World Heritage Site. Banff's forests contain ancient whitebark pine trees that provide crucial food for grizzly bears. The Columbia Icefield, partially in the park, is the largest ice field in the Rocky Mountains. Over four million visitors explore Banff's wilderness areas each year. The park pioneered the concept of wildlife corridors to maintain genetic diversity in animal populations."
        ),
        FactItem(
            title: "Galápagos Unique Evolution",
            description: "The Galápagos Islands inspired Charles Darwin's groundbreaking theory of evolution by natural selection. Giant tortoises on the islands can live for over 100 years and weigh up to 900 pounds. Each major island developed its own distinct species of plants and animals through isolation. Marine iguanas are the world's only lizards that forage in the ocean for food. The islands host the only penguin species found north of the equator. Approximately 80% of land birds, 97% of reptiles, and 30% of plants are endemic to the Galápagos. The islands' volcanic origin means some islands are still forming through ongoing eruptions. Blue-footed boobies perform elaborate mating dances that have become iconic symbols of the islands. Strict conservation rules limit where tourists can visit and require certified naturalist guides. The Galápagos Marine Reserve is one of the largest marine protected areas in the world."
        ),
        FactItem(
            title: "Plitvice's Waterfall Wonderland",
            description: "Plitvice Lakes National Park contains 16 terraced lakes connected by spectacular waterfalls. The lakes' distinctive colors range from azure to green, gray, or blue depending on minerals and organisms. Travertine barriers that form the lakes grow at a rate of about one centimeter per year. The park receives over one million visitors annually, making it Croatia's most popular attraction. Brown bears, though rarely seen, inhabit the park's ancient forests along with wolves. The park's forests represent some of the last remaining primeval forests in Europe. Over 70 waterfalls cascade through the park, with heights ranging from a few feet to over 250 feet. The park's unique hydrological and biological processes create a constantly changing landscape. Wooden walkways allow visitors to walk directly over and beside the flowing waters. The park's elevation ranges from 1,200 feet to over 4,200 feet above sea level."
        ),
        FactItem(
            title: "Fiordland's Remote Wilderness",
            description: "Fiordland National Park is one of the wettest places on Earth, receiving over 23 feet of rain annually in some areas. Milford Sound, the park's most famous fiord, was carved by glaciers during the last ice age. The critically endangered kākāpō, a flightless nocturnal parrot, survives only through intensive conservation efforts. Bottlenose dolphins regularly swim in the fiords alongside visitors on boat tours. The park's Sutherland Falls drops 1,904 feet, making it one of the world's tallest waterfalls. Ancient Gondwana forests in the park contain plants dating back to when New Zealand was part of a supercontinent. The Milford Track is often called the finest walk in the world for its stunning scenery. The park's mountains rise dramatically from sea level to over 9,000 feet in just a few miles. Fiordland receives so much rain that temporary waterfalls appear on rock faces during storms. The park's remote location and harsh terrain keep large areas virtually untouched by humans."
        ),
        FactItem(
            title: "Tsingy's Stone Forest",
            description: "The tsingy formations consist of razor-sharp limestone pinnacles that can cut through shoes and skin. These unique formations developed over millions of years through erosion by acidic rainwater. The word 'tsingy' comes from a Malagasy word meaning 'where one cannot walk barefoot.' The stone forest creates such difficult terrain that many areas remain completely unexplored by scientists. Lemurs have adapted to navigate the sharp limestone by developing thick calloused feet and hands. The park contains caves and underground rivers flowing through the porous limestone. Some limestone spires reach heights of over 200 feet, creating a surreal landscape. The tsingy provides a natural fortress that has protected unique species from predators and human disturbance. During the dry season, the stone forest becomes an oven, with temperatures exceeding 104°F. The park's biodiversity includes many species found nowhere else on Earth due to its isolation and unique habitat."
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FactsColors.background)
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
                    Text("Interesting Facts")
                        .font(.poppinsBold(size: 18))
                        .foregroundColor(FactsColors.textPrimary)

                    Text("About Nature Reserves")
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(FactsColors.textSecondary)
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
            FactsColors.navBar
                .ignoresSafeArea()
                .shadow(color: FactsColors.shadowColor, radius: 24, x: 0, y: 10)
        )
    }

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(facts) { fact in
                    factCard(fact)
                }
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
    }

    private func factCard(_ fact: FactItem) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.25)) {
                if expandedIds.contains(fact.id) {
                    expandedIds.remove(fact.id)
                } else {
                    expandedIds.insert(fact.id)
                }
            }
        }) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 12) {
                    Text(fact.title)
                        .font(.poppinsBold(size: 18))
                        .foregroundColor(FactsColors.textPrimary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: expandedIds.contains(fact.id) ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(FactsColors.textPrimary)
                }
                .padding(20)
                
                if !expandedIds.contains(fact.id) {
                    Text(fact.description)
                        .font(.poppinsRegular(size: 14))
                        .foregroundColor(FactsColors.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }

                if expandedIds.contains(fact.id) {
                    Text(fact.description)
                        .font(.poppinsRegular(size: 14))
                        .foregroundColor(FactsColors.textSecondary)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(FactsColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    InterestingFactsView()
}
