//
//  ContentView.swift
//  lifeIsTooShort
//
//  Created by  玉城 on 2024/11/15.
//
import Foundation
import SwiftUI

struct ContentView: View {
    
    func hexToColor(hex: String, alpha: Double = 1.0) -> Color {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }
        
        let scanner = Scanner(string: formattedHex)
        var color: UInt64 = 0
        
        if scanner.scanHexInt64(&color) {
            let red = Double((color & 0xFF0000) >> 16) / 255.0
            let green = Double((color & 0x00FF00) >> 8) / 255.0
            let blue = Double(color & 0x0000FF) / 255.0
            return Color(red: red, green: green, blue: blue, opacity: alpha)
        } else {
            // 返回默认颜色，当转换失败时
            return Color.black
        }
    }
    
    // 定义选择器的绑定变量
    @State private var currentAge: Int = UserDefaults.standard.integer(forKey: "currentAge") == 0 ? 25 : UserDefaults.standard.integer(forKey: "currentAge")
    @State private var targetAge: Int = UserDefaults.standard.integer(forKey: "targetAge") == 0 ? 85 : UserDefaults.standard.integer(forKey: "targetAge")
    
    // 控制弹出层显示
    @State private var isCurrentAgePickerPresented = false
    @State private var isTargetAgePickerPresented = false
    @State private var selectedTab = 0
    
    @State private var progress: (day: Double, week: Double, month: Double, year: Double) = (0, 0, 0, 0)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        NavigationView {
           
         
            VStack(spacing: 30) {
                // 选择当前年龄按钮
                
                HStack{
                    
                    Button(action: {
                        isCurrentAgePickerPresented = true
                    }) {
                        Text("当前年龄: \(currentAge > 0 ? "\(currentAge)" : "未选择")")
                            .font(.title2)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $isCurrentAgePickerPresented) {
                        AgePickerView(
                            selectedAge: $currentAge,
                            ageRange: 1...100,
                            title:  NSLocalizedString("nowAge", comment:"当前年龄"),
                            onSave: {
                                saveCurrentAge()
                            }
                        )
                    }
                    
                    // 选择目标年龄按钮
                    Button(action: {
                        isTargetAgePickerPresented = true
                    }) {
                        Text("目标寿命: \(targetAge > 0 ? "\(targetAge)" : "未选择")")
                            .font(.title2)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $isTargetAgePickerPresented) {
                        AgePickerView(
                            selectedAge: $targetAge,
                            ageRange: 75...100,
                            title: NSLocalizedString("goalAge", comment:"目标寿命"),
                            onSave: {
                                saveTargetAge()
                            }
                        )
                    }
                    
                }
                
                
                
                
                // 显示已选择的年龄
                VStack {
                    
                    
                    
                    // 顶部标签栏
                    HStack {
                        TabButton(title:  NSLocalizedString("remainTime", comment:"剩余时间"), isSelected: selectedTab == 0) {
                            selectedTab = 0
                        }
                       
                       
                        TabButton(title: NSLocalizedString("remainProgress", comment:"时间进度"), isSelected: selectedTab == 1) {
                            selectedTab = 1
                        }
                        TabButton(title:  NSLocalizedString("remainLife", comment:"人生进度"), isSelected: selectedTab == 2) {
                            selectedTab = 2
                        }
                    }
                    //                             .padding()
                    
                    // 内容区域
                    TabView(selection: $selectedTab) {
                        
                        VStack{
                            
                            Spacer().frame(height: 20)
                            ScrollView(.vertical) {
                                //                                            Text("当前年龄：\(currentAge)")
                                //                                            Text("目标年龄：\(targetAge)")
                                
                                // 计算并显示剩余时间
                                if currentAge > 0 && targetAge > currentAge {
                                    let remainingYears = targetAge - currentAge
                                    let remainingMonths = remainingYears * 12
                                    let remainingWeeks = remainingYears * 52
                                    let remainingDays = remainingYears * 365
                                    let remainingHours = remainingDays * 24
                                    
//                                    StyledText(text: "\(remainingHours) \(NSLocalizedString("hour", comment: "小时"))")
                                    
                                    
                                    
                                    
//                                    StyledText(
//                                        text: "\(remainingHours) \(NSLocalizedString("hour", comment: "小时"))",
////                                        textColor: .black,
//                                        backgroundColor: DataColor.hexToColor(hex: "d40305")
//                                    )
//                                    StyledText(
//                                        text: "\(remainingHours) \(NSLocalizedString("hour", comment: "小时"))",
////                                        textColor: .black,
//                                        backgroundColor: DataColor.hexToColor(hex: " d53d1a")
//                                    )
//                                    StyledText(
//                                        text: "\(remainingHours) \(NSLocalizedString("hour", comment: "小时"))",
////                                        textColor: .black,
//                                        backgroundColor: DataColor.hexToColor(hex: "fd9112")
//                                    )
//                                    StyledText(
//                                        text: "\(remainingHours) \(NSLocalizedString("hour", comment: "小时"))",
////                                        textColor: .black,
//                                        backgroundColor: DataColor.hexToColor(hex: "f2ca00")
//                                    )
//                                    
                             
                                    
                                    StyledText(
                                        text: "\(remainingHours) \(NSLocalizedString("hour", comment: "小时"))"
                                    )
                                    StyledText(text: "\(remainingDays) \(NSLocalizedString("day", comment: "天"))")
                                    
                                    StyledText(text: "\(remainingWeeks) \(NSLocalizedString("week", comment: "周"))")
                                    StyledText(text: "\(remainingMonths) \(NSLocalizedString("month", comment:"月"))")
                                    StyledText(text: "\(remainingYears) \(NSLocalizedString("year", comment: "年"))")

                                } else {
                                    Text("请选择有效的年龄")
                                        .foregroundColor(.red)
                                }
                            }
                            
                            
                            
                        }
                        .tag(0)
                        
                        
                      
                        
                        VStack{
                            Spacer().frame(height: 20)
                            VStack(spacing: 25) {
                                
                                ProgressSection(title: NSLocalizedString("progress1", comment: "今日进度") , progress: progress.day)
                                ProgressSection(title: NSLocalizedString("progress2", comment: "今周进度"), progress: progress.week)
                                ProgressSection(title: NSLocalizedString("progress3", comment: "本月进度"), progress: progress.month)
                                ProgressSection(title: NSLocalizedString("progress4", comment: "今年进度"), progress: progress.year)
                                if currentAge > 0 && targetAge > currentAge {
                                    ProgressSection(title: NSLocalizedString("progress5", comment: "人生进度"), progress: Double(currentAge) / Double(targetAge))
                                }
                          
                            }
                            .padding()
                            .onAppear {
                                updateProgress()
                            }
                            .onReceive(timer) { _ in
                                updateProgress()
                            }
                            Spacer()
                        }.tag(1)
                        
                        
                        VStack{
                            if currentAge > 0 && targetAge > currentAge {
                                AgeBlocksView(currentAge: currentAge, targetAge: targetAge)
                            }
                            
                        }.tag(2)
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    
                    
                    
                }
                .font(.headline)
                .padding(.horizontal, 5)
                
                Spacer()
            }
           
            .padding()
//            .navigationTitle("Life is too short!")
        }
        .edgesIgnoringSafeArea(.all)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            loadAges()
        }
    }
    
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
    
    // 保存当前年龄到 UserDefaults
    private func saveCurrentAge() {
        UserDefaults.standard.set(currentAge, forKey: "currentAge")
    }
    
    // 保存目标年龄到 UserDefaults
    private func saveTargetAge() {
        UserDefaults.standard.set(targetAge, forKey: "targetAge")
    }
    
    // 从 UserDefaults 加载年龄数据
    private func loadAges() {
        currentAge = UserDefaults.standard.integer(forKey: "currentAge") == 0 ? 25 : UserDefaults.standard.integer(forKey: "currentAge")
        targetAge = UserDefaults.standard.integer(forKey: "targetAge") == 0 ? 85 : UserDefaults.standard.integer(forKey: "targetAge")

    }
}




// 自定义标签按钮
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(title)
                    .foregroundColor(isSelected ? .blue : .gray)
                    .padding(.bottom, 8)
                
                // 选中指示器
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(isSelected ? .blue : .clear)
            }
        }
        .frame(maxWidth: .infinity)
    }
}



struct StyledText: View {
    let text: String
    
    // 可传入的参数
    let fontSize: Font
    let fontWeight: Font.Weight
    let textColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    // 初始化时传入参数，提供默认值
    init(
        text: String,
        fontSize: Font = .title,
        fontWeight: Font.Weight = .bold,
        textColor: Color = .white,
        backgroundColor: Color = .blue,
        cornerRadius: CGFloat = 10,
        shadowRadius: CGFloat = 5
    ) {
        self.text = text
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    var body: some View {
        HStack {
            Text(text)
                .font(fontSize)
                .fontWeight(fontWeight)
                .foregroundColor(textColor)
                .padding()
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
            Spacer()
        }
        .frame(height: 80)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
    }
}





struct AgeBlocksView: View {
    let currentAge: Int
    let targetAge: Int
    
    var remainingYears: Int { targetAge - currentAge }
    var remainingMonths: Int { remainingYears * 12 }
    var remainingWeeks: Int { remainingYears * 52 }
    
    var body: some View {
        VStack(spacing: 20) {
            
            ScrollView(.vertical) {
                // 年方块可视化
                Text("人生进度-年")
                    .font(.headline)
                VStack{
                    BlockGridView(total: targetAge, filled: currentAge, blockColor: .blue, emptyColor: .gray)
                }.padding()
                
                
                
                // 月方块可视化
                Text("人生进度-月")
                    .font(.headline)
                VStack{
                    BlockGridView2(total: targetAge * 12, filled: currentAge * 12, blockColor: .green, emptyColor: .gray)
                }.padding()
                
                
                //             周方块可视化
                //           Text("剩余周数")
                //               .font(.headline)
                //
                //                VStack{
                //           BlockGridView2(total:  targetAge * 52, filled: currentAge * 52, blockColor: .purple, emptyColor: .gray)
                //            }.padding()
                
                
            }
        }
        .padding()
    }
}

struct BlockGridView: View {
    let total: Int
    let filled: Int
    let blockColor: Color
    let emptyColor: Color
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 25)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(0..<total, id: \.self) { index in
                Rectangle()
                    .fill(index < filled ? blockColor : emptyColor)
                    .frame(width: 10, height: 10)
                    .cornerRadius(2)
            }
        }
    }
}

struct BlockGridView2: View {
    let total: Int
    let filled: Int
    let blockColor: Color
    let emptyColor: Color
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 30)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(0..<total, id: \.self) { index in
                Rectangle()
                    .fill(index < filled ? blockColor : emptyColor)
                    .frame(width: 6, height: 6)
                    .cornerRadius(1)
            }
        }
    }
}



struct AgePickerView: View {
    @Binding var selectedAge: Int
    let ageRange: ClosedRange<Int>
    let title: String
    let onSave: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(title, selection: $selectedAge) {
                    ForEach(ageRange, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Spacer().frame(height: 40)
                
                Button("确定") {
                    onSave()
                    dismiss()
                }
                .font(.system(size: 20, weight: .bold))

                .padding(.vertical, 20)
                .padding(.horizontal, 120) // 水平内边距增加，按钮更宽
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                Spacer()
            }
            .navigationTitle(title)
            .navigationBarItems(trailing: Button("取消") {
                dismiss()
            })
        }
    }
}



struct ProgressSection: View {
    let title: String
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .cornerRadius(10)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 20)
                        .cornerRadius(10)
                    
                    Text(String(format: "%.0f%%", progress * 100))
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                }
            }
            .frame(height: 20)
        }
    }
}



//struct ProgressSection2: View {
//    let title: String
//    let progress: Double
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            
//            HStack{
//                Text(title)
//                    .foregroundColor(.gray)
//                    .font(.headline)
//                Spacer()
//                Text(String(format: "%.0f%%", progress * 100))
//                    .foregroundColor(.gray)
//                    .padding(.leading, 8)
//            }
//            
//            GeometryReader { geometry in
//                ZStack(alignment: .leading) {
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.3))
//                        .frame(height: 14)
//                        .cornerRadius(10)
//                    
//                    Rectangle()
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [.blue, .purple]),
//                                startPoint: .leading,
//                                endPoint: .trailing
//                            )
//                        )
//                        .frame(width: geometry.size.width * progress, height: 14)
//                        .cornerRadius(10)
//                    
//                   
//                    
//                    
//                }
//            }
//            .frame(height: 14)
//        }
//    }
//}

extension Calendar {
    func isLeapYear(date: Date) -> Bool {
        let year = component(.year, from: date)
        return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    }
}




#Preview {
    ContentView()
}



class DataColor {
    
    static func hexToColor(hex: String, alpha: Double = 1.0) -> Color {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }
        
        let scanner = Scanner(string: formattedHex)
        var color: UInt64 = 0
        
        if scanner.scanHexInt64(&color) {
            let red = Double((color & 0xFF0000) >> 16) / 255.0
            let green = Double((color & 0x00FF00) >> 8) / 255.0
            let blue = Double(color & 0x0000FF) / 255.0
            return Color(red: red, green: green, blue: blue, opacity: alpha)
        } else {
            // 返回默认颜色，当转换失败时
            return Color.black
        }
    }

}

extension Color {
    func toHexString() -> String {
           guard let components = UIColor(self).cgColor.components else {
               return "#000000"
           }
           let red = components[0]
           let green = components[1]
           let blue = components[2]
           
           return String(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
    }
    
    
}

