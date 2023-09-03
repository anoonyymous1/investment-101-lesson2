//
//  StockView.swift
//  investment 101
//
//  Created by Celine Tsai on 25/7/23.
//

import SwiftUI


struct Stock: Identifiable {
    let id = UUID()
    let code: String
    let name: String
    let performance: [Double]
    let price: Double
    let isPriceIncreased: Bool
}

enum DisplayMode {
    case percentageIncrease
    case totalValue
}

struct StockView: View {
    @State private var displayMode: DisplayMode = .percentageIncrease
    @State private var selectedStock: Stock?
    
    let stocks = [
        Stock(code: "AAPL", name: "Apple Inc.", performance: [0.8, 0.9, 1.2, 1.5, 1.3], price: 145.32, isPriceIncreased: true),
        Stock(code: "GOOG", name: "Alphabet Inc.", performance: [0.7, 0.8, 0.9, 0.7, 0.6], price: 2578.15, isPriceIncreased: false),
        Stock(code: "MSFT", name: "Microsoft Corporation", performance: [1.1, 1.2, 1.3, 1.2, 1.4], price: 277.65, isPriceIncreased: true),
        Stock(code: "AMZN", name: "Amazon.com, Inc.", performance: [1.5, 1.4, 1.3, 1.6, 1.7], price: 3567.89, isPriceIncreased: true),
    ]
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Stocks")
                    .font(.largeTitle)
                    .padding(.all)
                List(stocks) { stock in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(stock.code)
                                .font(.headline)
                            Text(stock.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        StockGraphView(performance: stock.performance)
                            .frame(width: 50, height: 30)
                            .padding(.top, 4)
                            .padding(.horizontal, 10)
                        VStack {
                            Text("\(stock.price, specifier: "%.2f")")
                                .font(.headline)
                            Button(action: {
                                toggleDisplayMode(for: stock)
                            }) {
                                Text(displayText(for: stock))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(priceChangeButtonColor(for: stock))
                                    .cornerRadius(8)
                            }
                            
                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(.top, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedStock = stock
                    }
                }
                .navigationBarHidden(true) // Hide the navigation bar
                .navigationBarBackButtonHidden(true) // Hide the back button
            }
        }
        .sheet(item: $selectedStock) { stock in
            StockDetailView(stock: stock)
        }
    }
    
    func toggleDisplayMode(for stock: Stock) {
        switch displayMode {
        case .percentageIncrease:
            displayMode = .totalValue
        case .totalValue:
            displayMode = .percentageIncrease
        }
    }
    
    func displayText(for stock: Stock) -> String {
        switch displayMode {
        case .totalValue:
            let priceChange = stock.isPriceIncreased ? "+\(stock.price)" : "-\(stock.price)"
            return priceChange
        case .percentageIncrease:
            let percentageIncrease = calculatePercentageIncrease(for: stock)
            return String(format: "%.2f%%", percentageIncrease)
        }
    }
    
    func calculatePercentageIncrease(for stock: Stock) -> Double {
        let firstPrice = stock.performance.first ?? 0
        let currentPrice = stock.price
        let percentageIncrease = ((currentPrice - firstPrice) / firstPrice) * 100
        return Double(String(format: "%.2f", percentageIncrease)) ?? 0
    }
    
    func priceChangeButtonColor(for stock: Stock) -> Color {
        return stock.isPriceIncreased ? .green : .red
    }
}

struct StockGraphView: View {
    let performance: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let points = calculateGraphPoints(geometry: geometry)
                path.addLines(points)
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
    
    func calculateGraphPoints(geometry: GeometryProxy) -> [CGPoint] {
        let width = geometry.size.width
        let height = geometry.size.height
        let maxPerformance = performance.max() ?? 0
        let minPerformance = performance.min() ?? 0
        let performanceRange = maxPerformance - minPerformance
        
        return performance.enumerated().map { index, value in
            let x = CGFloat(index) * width / CGFloat(performance.count - 1)
            let y = height - CGFloat((value - minPerformance) / performanceRange) * height
            return CGPoint(x: x, y: y)
        }
    }
}

struct StockDetailView: View {
    let stock: Stock
    
    var body: some View {
        VStack {
            Text(stock.code)
                .font(.title)
            Text(stock.name)
                .font(.caption)
                .foregroundColor(.secondary)
            StockGraphView(performance: stock.performance)
                .frame(height: 150)
            Spacer()
            HStack {
                Button(action: {
                    // Perform buy action
                }) {
                    Text("Buy")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                Button(action: {
                    // Perform sell action
                }) {
                    Text("Sell")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView()
    }
}
