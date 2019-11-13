//
//  ResultsViewController.swift
//  SuffrageID
//
//  Created by Jeremy Conkin on 11/8/18.
//  Copyright © 2018 Slalom. All rights reserved.
//

import UIKit
import Charts

class ResultsViewController: ChartDemoViewController
{
    static var votingResults:[Double] = [0,0,0,0,0,0,0,0,0,0,0,0]
    static var numMales:Double = 0
    static var numFemales:Double = 0
    static var numUnspecified:Double = 0
    
    @IBOutlet var chartView: HorizontalBarChartView!
    @IBOutlet var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeBarChart()
    }
    
    private func initializePieChart() {
        
        
        self.setup(pieChartView: pieChartView)
        
        pieChartView.delegate = self
        
        let l = pieChartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        
        // entry label styling
        pieChartView.entryLabelColor = .white
        pieChartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        pieChartView.holeColor = NSUIColor.clear
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    private func initializeBarChart() {
        
        // Do any additional setup after loading the view.
        self.title = "Polling Data"
        self.options = [.toggleValues,
                        .toggleIcons,
                        .toggleHighlight,
                        .animateX,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData]
        
        self.setup(barLineChartView: chartView)
        
        chartView.delegate = self
        
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.drawGridBackgroundEnabled = false
        
        chartView.maxVisibleCount = 60
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 10
        xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = false
        rightAxis.axisMinimum = 0
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = true
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
        chartView.fitBars = true
        
        updateChartData()
        chartView.animate(yAxisDuration: 2.5)
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setDataCount(12, range: 100)
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let barWidth = 9.0
        let spaceForBar = 10.0
        
        let yVals = (0..<3).map { (i) -> BarChartDataEntry in
            let val = (i == 2) ? ResultsViewController.numFemales : ((i == 1) ? ResultsViewController.numMales : ResultsViewController.numUnspecified)
            let data = BarChartDataEntry(x: Double(i)*spaceForBar, y: val, icon: #imageLiteral(resourceName: "jeff"))
            return data
        }
        
        let set1 = BarChartDataSet(values: yVals, label: "DataSet")
        set1.colors = [
            NSUIColor(red: 043.0/255.0, green: 095.0/255.0, blue: 174.0/255.0, alpha: 1),
            NSUIColor(red: 225.0/255.0, green: 000.0/255.0, blue: 012.0/255.0, alpha: 1),
            NSUIColor(red: 116.0/255.0, green: 177.0/255.0, blue: 217.0/255.0, alpha: 1)
        ]
        set1.drawIconsEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
        data.barWidth = barWidth
        
        chartView.data = data
        
        
        
        let votingTotals = ResultsViewController.votingResults.reduce(0, +)
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            let numVotesForCandidate = ResultsViewController.votingResults[i]
            return PieChartDataEntry(value: numVotesForCandidate/votingTotals * 100,
                                     label: numVotesForCandidate > 0 ? parties[i % parties.count] : "Other",
                                     icon: #imageLiteral(resourceName: "anthony"))
        }
        
        let pieSet = PieChartDataSet(values: entries, label: "Polling Results")
        pieSet.drawIconsEnabled = false
        pieSet.sliceSpace = 2
        
        
        pieSet.colors = [
            NSUIColor(red: 043.0/255.0, green: 095.0/255.0, blue: 174.0/255.0, alpha: 1),
            NSUIColor(red: 225.0/255.0, green: 000.0/255.0, blue: 012.0/255.0, alpha: 1),
            NSUIColor(red: 116.0/255.0, green: 177.0/255.0, blue: 217.0/255.0, alpha: 1)
        ]
        
        let pieData = PieChartData(dataSet: pieSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        pieData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        pieData.setValueFont(.systemFont(ofSize: 11, weight: .light))
        pieData.setValueTextColor(.white)
        
        pieChartView.data = pieData
        pieChartView.highlightValues(nil)
    }
}
