//
//  ViewController.swift
//  HealthMonitoring
//
//  Created by Muhannad Alghamdi on 4/26/17.
//  Copyright © 2017 Muhannad. All rights reserved.
//

import UIKit
import Charts

class FirstViewController: UIViewController {
	@IBOutlet weak var lineChartView: LineChartView!
	@IBOutlet weak var lineChartView2: LineChartView!
	
	@IBOutlet weak var xConstraint: NSLayoutConstraint!
	@IBOutlet weak var heartBeat: UIImageView!
	@IBOutlet weak var circularBar: KDCircularProgress!
	
	var iterator = 0
	var chartTimer: Timer!
	var dataEntries: [ChartDataEntry] = []
	let BPM = [978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 899.0, 784.0, 674.0, 572.0, 480.0, 402.0, 340.0, 293.0, 263.0, 251.0, 254.0, 270.0, 299.0, 335.0, 377.0, 421.0, 465.0, 503.0, 535.0, 560.0, 574.0, 578.0, 573.0, 559.0, 539.0, 514.0, 485.0, 456.0, 425.0, 396.0, 370.0, 346.0, 327.0, 312.0, 302.0, 296.0, 293.0, 296.0, 301.0, 309.0, 322.0, 337.0, 353.0, 369.0, 386.0, 402.0, 417.0, 429.0, 440.0, 448.0, 453.0, 457.0, 456.0, 455.0, 451.0, 445.0, 439.0, 434.0, 434.0, 444.0, 470.0, 520.0, 594.0, 694.0, 808.0, 927.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 920.0, 818.0, 720.0, 626.0, 541.0, 464.0, 399.0, 346.0, 306.0, 280.0, 267.0, 270.0, 282.0, 306.0, 338.0, 373.0, 410.0, 444.0, 474.0, 499.0, 518.0, 528.0, 531.0, 525.0, 513.0, 496.0, 474.0, 451.0, 425.0, 400.0, 378.0, 356.0, 338.0, 322.0, 313.0, 306.0, 302.0, 303.0, 305.0, 310.0, 319.0, 330.0, 342.0, 356.0, 370.0, 383.0, 395.0, 406.0, 415.0, 423.0, 430.0, 435.0, 439.0, 441.0, 442.0, 442.0, 439.0, 436.0, 432.0, 426.0, 420.0, 415.0, 408.0, 402.0, 397.0, 392.0, 388.0, 383.0, 380.0, 377.0, 373.0, 370.0, 367.0, 365.0, 367.0, 379.0, 406.0, 460.0, 547.0, 666.0, 807.0, 958.0, 978.0, 978.0, 978.0, 978.0, 978.0, 979.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 979.0, 978.0, 978.0, 865.0, 761.0, 662.0, 572.0, 494.0, 428.0, 377.0, 341.0, 319.0, 309.0, 312.0, 323.0, 343.0, 366.0, 389.0, 411.0, 430.0, 444.0, 453.0, 456.0, 455.0, 448.0, 437.0, 423.0, 405.0, 387.0, 369.0, 351.0, 335.0, 320.0, 308.0, 299.0, 292.0, 289.0, 289.0, 293.0, 298.0, 306.0, 314.0, 322.0, 332.0, 343.0, 353.0, 363.0, 372.0, 381.0, 389.0, 397.0, 404.0, 409.0, 411.0, 411.0, 409.0, 404.0, 399.0, 393.0, 389.0, 384.0, 380.0, 376.0, 372.0, 368.0, 365.0, 361.0, 359.0, 356.0, 353.0, 352.0, 349.0, 347.0, 345.0, 343.0, 344.0, 352.0, 373.0, 414.0, 482.0, 579.0, 702.0, 842.0, 978.0, 978.0, 979.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 906.0, 794.0, 687.0, 587.0, 497.0, 422.0, 364.0, 320.0, 294.0, 285.0, 290.0, 309.0, 336.0, 370.0, 408.0, 444.0, 478.0, 504.0, 525.0, 538.0, 543.0, 541.0, 530.0, 513.0, 492.0, 467.0, 440.0, 412.0, 386.0, 362.0, 340.0, 322.0, 308.0, 297.0, 291.0, 288.0, 287.0, 290.0, 297.0, 308.0, 321.0, 335.0, 350.0, 365.0, 378.0, 391.0, 402.0, 411.0, 420.0, 426.0, 429.0, 431.0, 432.0, 431.0, 427.0, 421.0, 413.0, 404.0, 398.0, 395.0, 398.0, 416.0, 455.0, 519.0, 610.0, 723.0, 847.0, 968.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 978.0, 941.0, 839.0, 736.0, 639.0, 551.0, 471.0, 402.0, 346.0, 302.0, 273.0, 258.0, 256.0, 269.0, 292.0, 323.0, 362.0, 402.0, 441.0, 477.0, 505.0, 527.0, 540.0, 543.0, 539.0, 526.0, 508.0, 486.0, 459.0, 432.0, 406.0, 381.0, 358.0, 339.0, 324.0, 311.0, 303.0, 297.0]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		chartTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(setChart), userInfo: nil, repeats: true)
		animateHeartBeat(duration: , delay: 0.0)
	}
	
	func animateHeartBeat(duration: Double, delay: Double) -> Void {
		UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut,.repeat,.autoreverse], animations: {
			self.heartBeat.frame.size.height += 10
			self.heartBeat.frame.size.width += 10
		}, completion: nil)
	}
	
	func setChart() {
		print(">> \(iterator)")
		if iterator == BPM.count {
			iterator = 0
		}
		
		let dataEntry = ChartDataEntry(x: Double(iterator), y: BPM[iterator])
		dataEntries.append(dataEntry)
		
		let chartDataSet = LineChartDataSet(values: dataEntries, label: "Beat Per Minutes")
		chartDataSet.colors = [UIColor(red:0.97, green:0.07, blue:0.28, alpha:1.00)]
		chartDataSet.drawCubicEnabled = true
		chartDataSet.drawCircleHoleEnabled = false
		chartDataSet.drawCirclesEnabled = false
		chartDataSet.drawValuesEnabled = false
		
		let chartData = LineChartData(dataSet: chartDataSet)
		
		lineChartView.data = chartData
		lineChartView.noDataText = "No data available"
		lineChartView.isUserInteractionEnabled = false
		lineChartView.xAxis.drawLabelsEnabled = false
		lineChartView.rightAxis.drawLabelsEnabled = false
		lineChartView.xAxis.drawGridLinesEnabled = false
		lineChartView.leftAxis.drawGridLinesEnabled = false
		lineChartView.rightAxis.drawGridLinesEnabled = false
		lineChartView.xAxis.drawAxisLineEnabled = false
		lineChartView.rightAxis.drawAxisLineEnabled = false
		lineChartView.leftAxis.drawAxisLineEnabled = false
		lineChartView.chartDescription = nil
		lineChartView.notifyDataSetChanged()
		lineChartView.invalidateIntrinsicContentSize()
		//lineChartView.setVisibleXRangeMaximum(50.0)
		
		lineChartView2.data = chartData
		lineChartView2.noDataText = "No data available"
		lineChartView2.isUserInteractionEnabled = false
		lineChartView2.xAxis.drawLabelsEnabled = false
		lineChartView2.rightAxis.drawLabelsEnabled = false
		lineChartView2.xAxis.drawGridLinesEnabled = false
		lineChartView2.leftAxis.drawGridLinesEnabled = false
		lineChartView2.rightAxis.drawGridLinesEnabled = false
		lineChartView2.xAxis.drawAxisLineEnabled = false
		lineChartView2.rightAxis.drawAxisLineEnabled = false
		lineChartView2.leftAxis.drawAxisLineEnabled = false
		lineChartView2.chartDescription = nil
		lineChartView2.notifyDataSetChanged()
		lineChartView2.invalidateIntrinsicContentSize()
		//lineChartView.setVisibleXRangeMaximum(50.0)

		iterator += 1
	}
	
	func updateChart() -> Void {
		
	}

}

extension FirstViewController: MIPivotRootPage {
	
	func imageForPivotPage() -> UIImage? {
		return UIImage(named: "heart")
	}
}
