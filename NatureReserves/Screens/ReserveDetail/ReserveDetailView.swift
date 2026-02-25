import SwiftUI

struct ReserveFactCard {
    let emoji: String
    let title: String
    let description: String
}

struct ReserveDetailModel {
    let reserveId: String
    let name: String
    let country: String
    let imageName: String
    let intro: String
    let factCards: [ReserveFactCard]
}

private enum ReserveDetailColors {
    static let background = Color(red: 29, green: 28, blue: 30)
    static let cardBackground = Color(red: 52, green: 52, blue: 52)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.5)
    static let favoriteGreen = Color(red: 76, green: 175, blue: 80)
}

struct ReserveDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let reserve: ReserveDetailModel
    var onBack: (() -> Void)?

    private let favoritesService = FavoritesService.shared
    @State private var isFavorite = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                imageSection
                contentSection
            }
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ReserveDetailColors.background)
        .ignoresSafeArea()
        .onAppear {
            isFavorite = favoritesService.isFavorite(reserveId: reserve.reserveId)
        }
    }

    private var imageSection: some View {
        ZStack(alignment: .topLeading) {
            Image(reserve.imageName)
                .resizable()
                .frame(height: 280)
            
            backButton
        }
    }

    private var backButton: some View {
        Button(action: {
            if let onBack {
                onBack()
            } else {
                dismiss()
            }
        }) {
            Image("backButton")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
        }
        .padding(.top, 60)
        .padding(.leading, 20)
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text(reserve.name)
                    .font(.poppinsSemiBold(size: 24))
                    .foregroundColor(ReserveDetailColors.textPrimary)

                Text(reserve.country)
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(ReserveDetailColors.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            Text(reserve.intro)
                .font(.poppinsRegular(size: 14))
                .foregroundColor(ReserveDetailColors.textPrimary)
                .padding(.horizontal, 20)

            ForEach(Array(reserve.factCards.enumerated()), id: \.offset) { _, card in
                factCardView(card)
            }
            .padding(.horizontal, 20)

            Button(action: {
                favoritesService.toggleFavorite(reserveId: reserve.reserveId)
                isFavorite = favoritesService.isFavorite(reserveId: reserve.reserveId)
            }) {
                HStack(spacing: 10) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                    Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .font(.poppinsSemiBold(size: 18))
                }
                .foregroundColor(ReserveDetailColors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(ReserveDetailColors.favoriteGreen)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
    }

    private func factCardView(_ card: ReserveFactCard) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(card.emoji)
                    .font(.system(size: 20))
                Text(card.title)
                    .font(.poppinsSemiBold(size: 18))
                    .foregroundColor(ReserveDetailColors.textPrimary)
            }

            Text(card.description)
                .font(.poppinsRegular(size: 14))
                .foregroundColor(ReserveDetailColors.textPrimary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ReserveDetailColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension ReserveDetailModel {
    static let fiordland = ReserveDetailModel(
        reserveId: "fiordland_newzealand",
        name: "Fiordland National Park",
        country: "New Zealand",
        imageName: "FiordlandNationalPark",
        intro: "Fiordland National Park is New Zealand's largest national park, covering nearly 4,900 square miles. Located on the South Island's southwest corner, it features dramatic fiords carved by ancient glaciers. Milford Sound and Doubtful Sound are the park's most famous fiords. The park receives exceptional rainfall, creating numerous waterfalls and lush rainforests. It forms part of Te Wahipounamu World Heritage Site.",
        factCards: [
            ReserveFactCard(
                emoji: "🦋",
                title: "Biodiversity",
                description: "The park provides habitat for rare and endangered species including the takahe and kākāpō. New Zealand fur seals, dolphins, and penguins inhabit the coastal waters. Ancient beech forests host unique insects and birds found nowhere else. The park's rivers support native fish species. Fiordland's isolation has preserved many species from introduced predators."
            ),
            ReserveFactCard(
                emoji: "⛰️",
                title: "Landscape",
                description: "Steep-sided fiords plunge dramatically into the Tasman Sea. Towering mountains rise directly from sea level to over 9,000 feet. Ancient rainforests blanket the landscape with dense vegetation. Glacial lakes mirror surrounding peaks in stunning reflections. Countless waterfalls cascade down sheer rock faces after rainfall."
            ),
            ReserveFactCard(
                emoji: "🌱",
                title: "Conservation Importance",
                description: "Invasive species control programs protect native wildlife, particularly flightless birds. The park supports intensive conservation efforts for critically endangered species. Remote wilderness areas remain largely untouched by human activity. Conservation challenges include balancing tourism with ecosystem protection. Climate change threatens glaciers and alpine ecosystems."
            )
        ]
    )

    static let greatBarrierReef = ReserveDetailModel(
        reserveId: "greatbarrierreef_australia",
        name: "Great Barrier Reef Marine Park",
        country: "Australia",
        imageName: "GreatBarrierReefMarinePark",
        intro: "The Great Barrier Reef Marine Park protects the world's largest coral reef system. Stretching over 1,400 miles along Queensland's coast, it covers approximately 133,000 square miles. The reef contains about 2,900 individual reefs and 900 islands. Visible from space, this living structure is Earth's largest single structure made by living organisms. It was designated a World Heritage Site in 1981.",
        factCards: [
            ReserveFactCard(
                emoji: "🦋",
                title: "Biodiversity",
                description: "The reef supports over 1,500 fish species and 400 types of hard and soft coral. Six of the world's seven sea turtle species breed here. The ecosystem includes 30 species of whales, dolphins, and porpoises. Over 200 bird species nest or roost on reef islands. The reef's biodiversity rivals that of tropical rainforests."
            ),
            ReserveFactCard(
                emoji: "⛰️",
                title: "Landscape",
                description: "The reef system includes fringing reefs, patch reefs, and barrier reefs. Crystal-clear waters reveal stunning underwater landscapes of coral formations. Shallow lagoons contrast with deep channels and ocean trenches. The reef crest faces the full force of ocean swells. Seagrass meadows and mangrove forests connect to the coral ecosystem."
            ),
            ReserveFactCard(
                emoji: "🌱",
                title: "Conservation Importance",
                description: "Climate change and coral bleaching pose the greatest threats to the reef. Marine park zoning protects various areas while allowing sustainable use. Conservation efforts address water quality, fishing practices, and coastal development. The reef's economic value through tourism and fishing motivates protection. International collaboration supports research and restoration initiatives."
            )
        ]
    )

    static let kruger = ReserveDetailModel(
        reserveId: "kruger_southafrica",
        name: "Kruger National Park",
        country: "South Africa",
        imageName: "KrugerNationalPark",
        intro: "Kruger National Park, established in 1898, is South Africa's flagship conservation area. Covering nearly 7,500 square miles, it is one of Africa's largest game reserves. The park stretches 220 miles north to south along South Africa's border with Mozambique. Kruger represents various ecosystems from riverine forests to savanna woodlands. Over one million visitors explore this remarkable wildlife sanctuary annually.",
        factCards: [
            ReserveFactCard(
                emoji: "🦋",
                title: "Biodiversity",
                description: "Kruger hosts an incredible diversity with 147 mammal species recorded. The park contains substantial populations of elephants, buffalo, and various antelope species. All of Africa's 'Big Five' game animals thrive here. Over 500 bird species make Kruger a premier birding destination. The park also supports 114 reptile species and numerous amphibians and fish."
            ),
            ReserveFactCard(
                emoji: "⛰️",
                title: "Landscape",
                description: "The landscape varies from granite hills in the south to basalt plains in the central regions. Six major rivers flow through the park, creating lush riparian corridors. Mopane woodlands dominate the northern sections while mixed bushveld characterizes the south. Rocky outcrops provide dramatic vistas and important habitat for rock-dwelling species. The diverse topography creates numerous ecological niches."
            ),
            ReserveFactCard(
                emoji: "🌱",
                title: "Conservation Importance",
                description: "Kruger pioneered scientific wildlife management in Africa. The park faces ongoing challenges from poaching, especially of rhinoceros for their horns. Conservation programs include fence removal to create transfrontier conservation areas. Community partnerships aim to balance conservation with local development needs. Advanced technology aids anti-poaching efforts and wildlife monitoring."
            )
        ]
    )

    static let yellowstone = ReserveDetailModel(
        reserveId: "yellowstone_usa",
        name: "Yellowstone National Park",
        country: "United States",
        imageName: "YellowstoneNationalPark",
        intro: "Yellowstone National Park was established in 1872 as the world's first national park. Located primarily in Wyoming and extending into Montana and Idaho, it sits atop a massive volcanic hotspot that powers over 10,000 thermal features. The park is home to Old Faithful geyser and the famous Grand Prismatic Spring. Its vast wilderness supports grizzly bears, gray wolves, bison, and elk, and remains one of the last nearly intact ecosystems in the Earth's northern temperate zone.",
        factCards: [
            ReserveFactCard(
                emoji: "🦋",
                title: "Biodiversity",
                description: "The park supports 67 mammal species, the largest concentration in the lower 48 states. The Greater Yellowstone Ecosystem provides critical habitat for grizzly bears, gray wolves, lynx, and wolverines. Over 300 bird species have been recorded. Native cutthroat trout thrive in rivers and lakes. Diverse plant communities are adapted to the region's volcanic soils and varied elevations."
            ),
            ReserveFactCard(
                emoji: "⛰️",
                title: "Landscape",
                description: "Yellowstone features dramatic landscapes including the Grand Canyon of the Yellowstone and towering waterfalls. Vast forests, river valleys, and expansive meadows cover the region. Over 10,000 thermal features include geysers, hot springs, mud pots, and fumaroles. Yellowstone Lake is the largest high-elevation lake in North America. Mountain ranges and geothermal basins define the park's unique scenery."
            ),
            ReserveFactCard(
                emoji: "🌱",
                title: "Conservation Importance",
                description: "Yellowstone serves as critical habitat for threatened and endangered species. The park pioneered wildlife conservation and natural resource protection in the United States. Wolf reintroduction and recovery programs have had lasting ecological impacts. Thermal features are protected as unique geological resources. The park works to balance millions of annual visitors with ecosystem preservation."
            )
        ]
    )

    static let serengeti = ReserveDetailModel(
        reserveId: "serengeti_tanzania",
        name: "Serengeti National Park",
        country: "Tanzania",
        imageName: "SerengetiNationalPark",
        intro: "Serengeti National Park in Tanzania is one of Africa's most iconic wildlife reserves. Established in 1951, the park covers approximately 5,700 square miles of grassland plains, savanna, and woodlands. The Serengeti is world-famous for the annual Great Migration of over 1.5 million wildebeest and hundreds of thousands of zebras. The name 'Serengeti' comes from the Maasai language meaning 'endless plains.' This UNESCO World Heritage Site represents one of the oldest and most scientifically important ecosystems on Earth.",
        factCards: [
            ReserveFactCard(
                emoji: "🦋",
                title: "Biodiversity",
                description: "The Serengeti supports the largest terrestrial mammal migration in the world. It is home to the 'Big Five': lions, leopards, elephants, buffalo, and rhinoceros. The park hosts over 500 bird species and numerous reptile and insect species. Large predator populations include lions, cheetahs, hyenas, and African wild dogs. The ecosystem supports diverse herbivores from tiny dik-diks to massive elephants."
            ),
            ReserveFactCard(
                emoji: "⛰️",
                title: "Landscape",
                description: "The landscape consists primarily of vast grassland plains dotted with acacia trees. Rocky outcrops called kopjes provide shelter and vantage points for predators. Seasonal rivers wind through the plains, supporting gallery forests. The northern region features rolling hills and woodlands. The southern plains transform dramatically between wet and dry seasons."
            ),
            ReserveFactCard(
                emoji: "🌱",
                title: "Conservation Importance",
                description: "The Serengeti ecosystem faces challenges from human population growth and poaching. Conservation efforts focus on maintaining migration corridors and combating illegal wildlife trade. The park serves as a model for community-based conservation in Africa. Research conducted here informs wildlife management strategies worldwide. Anti-poaching patrols and community education programs protect endangered species."
            )
        ]
    )

    static let amazon = ReserveDetailModel(
        reserveId: "amazon_brazil",
        name: "Amazon Rainforest",
        country: "Brazil (and 8 other countries)",
        imageName: "AmazonRainforest",
        intro: "The Amazon Rainforest spans approximately 2.1 million square miles across nine South American countries, with Brazil holding about 60% of its area. It produces roughly 20% of the world's oxygen and stores vast amounts of carbon. The Amazon River and its tributaries form the largest river system on Earth. Indigenous peoples have lived in harmony with the forest for thousands of years.",
        factCards: [
            ReserveFactCard(
                emoji: "🦋",
                title: "Biodiversity",
                description: "The Amazon holds approximately 10% of all species on Earth. It contains over 40,000 plant species, 1,300 bird species, and 3,000 types of fish. Iconic animals include jaguars, pink river dolphins, anacondas, and poison dart frogs. Many species remain undiscovered. The region's biodiversity is unmatched anywhere else on the planet."
            ),
            ReserveFactCard(
                emoji: "🌳",
                title: "Landscape",
                description: "The forest has a complex multi-layered structure with emergent trees reaching 200 feet. The forest floor receives only about 2% of sunlight. An extensive network of rivers and tributaries runs through the region. Seasonal flooding creates várzea, or flooded forests. Landscapes range from terra firme upland forests to swampy igapó regions."
            ),
            ReserveFactCard(
                emoji: "🌱",
                title: "Conservation Importance",
                description: "Deforestation from agriculture and logging poses major threats. Conservation efforts include protected reserves, indigenous land rights, and sustainable development initiatives. The forest is critical to global climate regulation. International cooperation works to combat illegal logging and land clearing. Scientists warn of a tipping point beyond which the forest could shift toward savanna."
            )
        ]
    )

    static let galapagos = ReserveDetailModel(
        reserveId: "galapagos_ecuador",
        name: "Galápagos National Park",
        country: "Ecuador",
        imageName: "GalapagosNationalPark",
        intro: "The Galápagos National Park encompasses 97% of the Galápagos Islands' land area. Located about 600 miles off Ecuador's coast, the islands are volcanic in origin. Charles Darwin's 1835 visit here contributed to his theory of evolution. The park was established in 1959 and became a UNESCO World Heritage Site in 1978. These islands remain one of the world's foremost destinations for viewing wildlife.",
        factCards: [
            ReserveFactCard(
                emoji: "🦋",
                title: "Biodiversity",
                description: "The islands host numerous endemic species found nowhere else on Earth. Giant tortoises, marine iguanas, and flightless cormorants exemplify unique adaptations. Darwin's finches demonstrate evolution through natural selection. The surrounding waters support hammerhead sharks, sea lions, and penguins. Over 500 fish species inhabit the marine reserve."
            ),
            ReserveFactCard(
                emoji: "⛰️",
                title: "Landscape",
                description: "Volcanic landscapes include active volcanoes, lava fields, and crater lakes. Each island possesses distinct geological features and age. Coastal areas feature rocky shores, sandy beaches, and mangrove swamps. The islands range from barren lava deserts to lush highland forests. Underwater volcanic formations create diverse marine habitats."
            ),
            ReserveFactCard(
                emoji: "🌱",
                title: "Conservation Importance",
                description: "Invasive species pose significant threats to native wildlife and plants. Strict visitor regulations limit impact and protect sensitive areas. The Charles Darwin Research Station conducts ongoing conservation research. Breeding programs have saved several species from extinction. Marine protection addresses illegal fishing and preserves ocean ecosystems."
            )
        ]
    )

    static let plitvice = ReserveDetailModel(
        reserveId: "plitvice_croatia",
        name: "Plitvice Lakes National Park",
        country: "Croatia",
        imageName: "PlitviceLakesNationalPark",
        intro: "Plitvice Lakes National Park is Croatia's oldest and largest national park. Established in 1949, it covers approximately 115 square miles of forested hills. The park is famous for its 16 terraced lakes connected by waterfalls. Natural travertine barriers created by moss, algae, and bacteria form the lakes. It became a UNESCO World Heritage Site in 1979.",
        factCards: [
            ReserveFactCard(
                emoji: "🦋",
                title: "Biodiversity",
                description: "The park protects one of Europe's last remaining primeval forests. Large mammals include brown bears, wolves, and European lynx. Over 160 bird species inhabit or migrate through the area. The lakes contain numerous fish species and rare amphibians. Ancient beech and fir forests provide crucial habitat."
            ),
            ReserveFactCard(
                emoji: "⛰️",
                title: "Landscape",
                description: "Cascading lakes descend through a forested landscape in spectacular fashion. Crystal-clear turquoise waters showcase the travertine formations beneath. The Upper Lakes occupy a dolomite valley surrounded by thick forests. The Lower Lakes cut through limestone canyons with dramatic waterfalls. Wooden walkways allow visitors to experience the landscape without damage."
            ),
            ReserveFactCard(
                emoji: "🌱",
                title: "Conservation Importance",
                description: "The park faces challenges from tourism pressure and surrounding development. Water quality monitoring ensures the delicate travertine formation process continues. Strict regulations protect the forest and prevent disturbance to wildlife. Conservation efforts maintain the natural hydrological processes. The park serves as an important research site for karst ecosystems."
            )
        ]
    )

    static let banff = ReserveDetailModel(
        reserveId: "banff_canada",
        name: "Banff National Park",
        country: "Canada",
        imageName: "BanffNationalPark",
        intro: "Banff National Park, established in 1885, is Canada's oldest national park. Located in the Canadian Rockies of Alberta, it covers 2,564 square miles of mountainous terrain. The park features dramatic peaks, glaciers, ice fields, and alpine meadows. Lake Louise and Moraine Lake are among the world's most photographed landscapes. Banff balances conservation with four million annual visitors.",
        factCards: [
            ReserveFactCard(
                emoji: "🦋",
                title: "Biodiversity",
                description: "The park supports 56 mammal species including grizzly bears, black bears, and wolves. Mountain goats and bighorn sheep navigate the rocky terrain. The park's forests contain whitebark pine, important for grizzly bear nutrition. Over 260 bird species have been recorded in the park. Alpine and subalpine zones host specially adapted plant communities."
            ),
            ReserveFactCard(
                emoji: "⛰️",
                title: "Landscape",
                description: "Towering mountain ranges dominate the landscape with peaks exceeding 10,000 feet. The Columbia Icefield feeds numerous glaciers throughout the region. Turquoise glacial lakes reflect surrounding mountain scenery. Dense coniferous forests cover lower elevations. Alpine meadows burst with wildflowers during brief summer seasons."
            ),
            ReserveFactCard(
                emoji: "🌱",
                title: "Conservation Importance",
                description: "Wildlife corridors and overpasses help animals safely cross the Trans-Canada Highway. Conservation challenges include balancing tourism with habitat protection. Climate change threatens glaciers and alpine ecosystems. The park participates in grizzly bear recovery and monitoring programs. Sustainable tourism initiatives aim to reduce environmental impact."
            )
        ]
    )

    static let tsingy = ReserveDetailModel(
        reserveId: "tsingy_madagascar",
        name: "Tsingy de Bemaraha National Park",
        country: "Madagascar",
        imageName: "tsingyDeBemarahaNationalPark",
        intro: "Tsingy de Bemaraha National Park protects Madagascar's extraordinary stone forest. Located in western Madagascar, the park covers approximately 600 square miles. The word 'tsingy' means 'where one cannot walk barefoot' in Malagasy. Sharp limestone pinnacles create an otherworldly landscape unlike anywhere else on Earth. The park became a UNESCO World Heritage Site in 1990.",
        factCards: [
            ReserveFactCard(
                emoji: "🦋",
                title: "Biodiversity",
                description: "The park hosts numerous endemic species found only in Madagascar. Lemur species including Decken's sifaka inhabit the forests between limestone formations. Over 100 bird species include several Madagascar endemics. Reptiles and amphibians have adapted to the unique karst environment. Many species remain undiscovered in inaccessible areas of the tsingy."
            ),
            ReserveFactCard(
                emoji: "⛰️",
                title: "Landscape",
                description: "Jagged limestone pinnacles rise like a forest of stone needles. The karst formation resulted from millions of years of erosion. Deep canyons and caves honeycomb the limestone plateau. Isolated patches of forest grow between the rock formations. The Manambolo River has carved spectacular gorges through the landscape."
            ),
            ReserveFactCard(
                emoji: "🌱",
                title: "Conservation Importance",
                description: "The park's remoteness provides natural protection but creates management challenges. Conservation efforts focus on preventing forest fires and illegal logging. The unique geology makes the area particularly vulnerable to disturbance. Local community involvement is essential for effective conservation. The tsingy formations are irreplaceable and require careful protection."
            )
        ]
    )

    static let allByReserveId: [String: ReserveDetailModel] = [
        fiordland.reserveId: fiordland,
        greatBarrierReef.reserveId: greatBarrierReef,
        kruger.reserveId: kruger,
        yellowstone.reserveId: yellowstone,
        serengeti.reserveId: serengeti,
        amazon.reserveId: amazon,
        galapagos.reserveId: galapagos,
        plitvice.reserveId: plitvice,
        banff.reserveId: banff,
        tsingy.reserveId: tsingy
    ]

    static func model(forReserveId reserveId: String) -> ReserveDetailModel? {
        ReserveDetailModel.allByReserveId[reserveId]
    }
}

#Preview {
    ReserveDetailView(reserve: .banff)
}
