import WidgetKit
import SwiftUI

struct WidgetData: Codable {
    let currentBalance: Double
    let dailyLimit: Double
    let spentToday: Double
    let streakCount: Int
    let topCategories: [CategoryData]
    let weeklyTrend: [Double]
}

struct CategoryData: Codable {
    let category: String
    let amount: Double
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: previewData)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), data: loadData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), data: loadData())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func loadData() -> WidgetData {
        let userDefaults = UserDefaults(suiteName: "group.com.yigityildirim35.pretio")
        let balance = userDefaults?.double(forKey: "current_balance") ?? 0.0
        let limit = userDefaults?.double(forKey: "daily_limit") ?? 500.0
        let spent = userDefaults?.double(forKey: "spent_today") ?? 0.0
        let streak = userDefaults?.integer(forKey: "streak_count") ?? 0
        
        let categoriesJson = userDefaults?.string(forKey: "top_categories") ?? "[]"
        let weeklyTrendJson = userDefaults?.string(forKey: "weekly_trend") ?? "[0,0,0,0,0,0,0]"
        
        // Parsing simplified for brevity
        return WidgetData(
            currentBalance: balance,
            dailyLimit: limit,
            spentToday: spent,
            streakCount: streak,
            topCategories: [], // Ideally parsed from JSON
            weeklyTrend: [0.3, 0.5, 0.2, 0.8, 0.4, 0.6, 0.1] // Mock for layout
        )
    }

    private var previewData: WidgetData {
        WidgetData(currentBalance: 250.0, dailyLimit: 500.0, spentToday: 150.0, streakCount: 5, topCategories: [], weeklyTrend: [0.3, 0.7, 0.4, 0.9, 0.2, 0.5, 0.8])
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: WidgetData
}

struct PretioWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Color(hex: "112117").ignoresSafeArea()
            
            switch family {
            case .systemSmall:
                SmallWidgetView(data: entry.data)
            case .systemMedium:
                MediumWidgetView(data: entry.data)
            case .systemLarge:
                LargeWidgetView(data: entry.data)
            default:
                SmallWidgetView(data: entry.data)
            }
        }
    }
}

// 1x1 Widget (Small)
struct SmallWidgetView: View {
    let data: WidgetData
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(180))
                
                Circle()
                    .trim(from: 0, to: CGFloat(min(data.spentToday / data.dailyLimit, 1.0)) * 0.5)
                    .stroke(Color(hex: "2BEE79"), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(180))
                
                VStack {
                    Text("\(Int(data.dailyLimit - data.spentToday)) TL")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text("Limit")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
            }
            .frame(width: 100, height: 50)
            
            HStack {
                Text("🔥 \(data.streakCount)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "2BEE79"))
            }
        }
    }
}

// 2x1 Widget (Medium)
struct MediumWidgetView: View {
    let data: WidgetData

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 6)
                Circle()
                    .trim(from: 0, to: CGFloat(min(data.spentToday / data.dailyLimit, 1.0)))
                    .stroke(Color(hex: "2BEE79"), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Image("AppIcon") // Placeholder for Logo
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .frame(width: 70, height: 70)
            .padding(.leading)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(data.spentToday)) TL Harcandı")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 2) {
                    CategoryBar(name: "Market", progress: 0.6)
                    CategoryBar(name: "Ulaşım", progress: 0.3)
                    CategoryBar(name: "Eğlence", progress: 0.1)
                }
            }
            .padding(.leading, 8)
            Spacer()
        }
    }
}

struct CategoryBar: View {
    let name: String
    let progress: CGFloat
    
    var body: some View {
        HStack {
            Text(name)
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .frame(width: 50, alignment: .leading)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 4)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "2BEE79"))
                    .frame(width: 80 * progress, height: 4)
            }
        }
    }
}

// 4x2 Widget (Large)
struct LargeWidgetView: View {
    let data: WidgetData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Haftalık Trend")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding([.top, .leading])
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(0..<7) { i in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "2BEE79"))
                            .frame(height: CGFloat(data.weeklyTrend[i] * 100))
                        Text(dayLabel(i))
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            Spacer()
        }
    }
    
    func dayLabel(_ i: Int) -> String {
        let days = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"]
        return days[i]
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

@main
struct PretioWidget: Widget {
    let kind: String = "PretioWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PretioWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pretio")
        .description("Harcamalarını ana ekranından takip et.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
