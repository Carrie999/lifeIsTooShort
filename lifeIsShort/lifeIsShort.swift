//
//  lifeIsShort.swift
//  lifeIsShort
//
//  Created by  玉城 on 2024/11/15.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}



struct ProgressSection2: View {
    let title: String
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
//            Spacer()
            HStack{
                Text(title)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                Spacer()
                Text(String(format: "%.0f%%", progress * 100))
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                    .font(.system(size: 12))
            }.padding(0)
       
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 10)
                        .cornerRadius(10).padding(0)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 10)
                        .cornerRadius(10).padding(0)
                    
                   
                    
                    
                }
            }
        Spacer()
               
        } .frame(height: 10)
    }
}

struct lifeIsShortEntryView : View {
    var entry: Provider.Entry
    @State private var progress: (day: Double, week: Double, month: Double, year: Double) = (0, 0, 0, 0)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    
    
    private func updateProgress() {
        let now = Date()
        let calendar = Calendar.current
        
        // 计算日进度
        let secondsInDay = 24.0 * 60.0 * 60.0
        let elapsedSecondsToday = Double(calendar.component(.hour, from: now) * 3600 +
                                         calendar.component(.minute, from: now) * 60 +
                                         calendar.component(.second, from: now))
        progress.day = elapsedSecondsToday / secondsInDay
        
        // 计算周进度
        let weekday = calendar.component(.weekday, from: now)
        let adjustedWeekday = weekday == 1 ? 7 : weekday - 1 // 调整为周一为1
        progress.week = (Double(adjustedWeekday - 1) * 24 * 3600 + elapsedSecondsToday) / (7 * 24 * 3600)
        
        // 计算月进度
        let daysInMonth = Double(calendar.range(of: .day, in: .month, for: now)?.count ?? 30)
        let day = Double(calendar.component(.day, from: now))
        progress.month = (day - 1 + elapsedSecondsToday / secondsInDay) / daysInMonth
        
        // 计算年进度
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        let secondsFromStartOfYear = now.timeIntervalSince(startOfYear)
        let secondsInYear = Double(calendar.isLeapYear(date: now) ? 366 : 365) * secondsInDay
        progress.year = secondsFromStartOfYear / secondsInYear
    }

    var body: some View {
        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)

//            Text("Emoji:")
//            Text(entry.emoji)
//            
            
            VStack(spacing: 25) {
                
                ProgressSection2(title: NSLocalizedString("progress1", comment: "今日进度"), progress: progress.day)
                ProgressSection2(title: NSLocalizedString("progress2", comment: "今周进度"), progress: progress.week)
                ProgressSection2(title: NSLocalizedString("progress3", comment: "本月进度"), progress: progress.month)
                ProgressSection2(title: NSLocalizedString("progress4", comment: "今年进度"), progress: progress.year)
               
          
            }
            .padding(.horizontal, 5)
            .onAppear {
                updateProgress()
            }
            .onReceive(timer) { _ in
                updateProgress()
            }
            
            
        }
    }
}




struct lifeIsShort: Widget {
    let kind: String = "lifeIsShort"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                lifeIsShortEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                lifeIsShortEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName(NSLocalizedString("progress6", comment: "Life Progress") )
        .description(NSLocalizedString("progress7", comment: "Track grogress of your day,week,month,year"))
    }
}





extension Calendar {
    func isLeapYear(date: Date) -> Bool {
        let year = component(.year, from: date)
        return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    }
}


#Preview(as: .systemSmall) {
    lifeIsShort()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
