//
//  SecondViewController.swift
//  HealthMonitoring
//
//  Created by Muhannad Alghamdi on 4/26/17.
//  Copyright © 2017 Muhannad. All rights reserved.
//

import UIKit
import Charts

class SecondViewController: UIViewController {
	@IBOutlet weak var barChartView: BarChartView!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
		let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
		
		setChart(dataPoints: months, values: unitsSold)
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	func setChart(dataPoints: [String], values: [Double]) {
		var dataEntries: [BarChartDataEntry] = []
		
		for i in 0..<dataPoints.count {
			let dataEntry = BarChartDataEntry(x: values[i], y: Double(i))
			dataEntries.append(dataEntry)
		}
		
		let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
		
		let chartData = BarChartData(dataSet: chartDataSet)
		barChartView.data = chartData
	}
}

extension SecondViewController: MIPivotRootPage {
	
	func imageForPivotPage() -> UIImage? {
		return UIImage(named: "medical_report")
	}
}
