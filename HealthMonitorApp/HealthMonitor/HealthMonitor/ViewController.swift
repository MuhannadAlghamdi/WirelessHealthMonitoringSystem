//
//  ViewController.swift
//  HealthMonitor
//
//  Created by Muhannad Alghamdi on 5/19/17.
//  Copyright © 2017 Muhannad. All rights reserved.
//

import UIKit
import Charts
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
	var i = 0
	var BPM = 0
	var signalTimer: Timer!
	var signalArray: [Int] = []
	var dataEntries: [ChartDataEntry] = []
	
	@IBOutlet weak var BPMView: UILabel!
	@IBOutlet weak var signalChartView: LineChartView!
	@IBOutlet weak var xConstraint: NSLayoutConstraint!
	@IBOutlet weak var heartBeatImageView: UIImageView!
	@IBOutlet weak var circularBar: KDCircularProgress!
	@IBOutlet weak var startSignalsView: UIButton!
	@IBOutlet weak var stopSignalsView: UIButton!
	
	// Start reading from HM-10.
	@IBAction func startSignalsButton(_ sender: Any) {
		signalTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(writeValue), userInfo: nil, repeats: true)
		startSignalsView.isHidden = true
		stopSignalsView.isHidden = false
	}
	
	// Stop reading from HM-10.
	@IBAction func stopSignalsButton(_ sender: Any) {
		self.view.layer.removeAllAnimations()
		signalTimer.invalidate()
		signalTimer = nil
		startSignalsView.isHidden = false
		stopSignalsView.isHidden = true
	}
	
	// Called after the view has been loaded.
	override func viewDidLoad() {
		super.viewDidLoad()
		stopSignalsView.isHidden = true
	}
	
	// Notifies the view controller that its view is about to be added to a view hierarchy.
	override func viewWillAppear(_ animated: Bool) {
		if let activeCentralManager = activeCentralManager {
			activeCentralManager.delegate = self
		}
		
		if let peripheralDevice = peripheralDevice {
			peripheralDevice.delegate = self
		}
	}
	
	// Write function
	func writeValue() {
		let select = "1"
		let data = (select as NSString).data(using: String.Encoding.utf8.rawValue)
		if let peripheralDevice = peripheralDevice {
			if let deviceCharacteristics = deviceCharacteristics {
				peripheralDevice.writeValue(data!, for: deviceCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
			}
		}
	}
	
	// ?
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch (central.state) {
		case CBManagerState.poweredOff:
			print("Bluetooth switched off or not initialized")
			break
		case CBManagerState.poweredOn:
			print("Bluetooth ON")
			break
		default:
			break
		}
	}
	
	// Get data values when they are updated.
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		let stringFromData = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)!
		var array = stringFromData.components(separatedBy: ",")
		
		if (array.count >= 3) {
			print(stringFromData)
			
			// Append signal into signalArray.
			if (array[0] != "") {
				signalArray.append(Int(array[0])!)
				setChart()
			}
			
			// Update BPM and heartBeatImageView.
			if (array[1] != "") {
				if (BPM != Int(array[1])!) {
					let time = (Double(array[1])! / 300.0)
					animateHeartBeat(duration: time, delay: 0.0)
				}
				
				BPM = Int(array[1])!
				BPMView.text = array[1]
			}
			
			// Make signalArray maximum size to 60.
			if signalArray.count == 60 {
				signalArray.remove(at: 0)
			}
		}
		
		print(stringFromData)
	}
	
	// Animate heartBeatImageView.
	func animateHeartBeat(duration: Double, delay: Double) -> Void {
		UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut, .autoreverse, .repeat], animations: {
			if (self.heartBeatImageView.frame.size.height < 132.0) {
				self.heartBeatImageView.frame.size.height += 50
				self.heartBeatImageView.frame.size.width += 50
			}
		}, completion: nil)
	}
	
	func setChart() {
		dataEntries = []
		for i in 0..<signalArray.count {
			let dataEntry = ChartDataEntry(x: Double(i), y: Double(signalArray[i]))
			dataEntries.append(dataEntry)
		}
		
		let chartDataSet = LineChartDataSet(values: dataEntries, label: "Heat Beat Signal")
		chartDataSet.colors = [UIColor(red:0.97, green:0.07, blue:0.28, alpha:1.00)]
		chartDataSet.drawCubicEnabled = true
		chartDataSet.drawCircleHoleEnabled = false
		chartDataSet.drawCirclesEnabled = false
		chartDataSet.drawValuesEnabled = false
		
		let chartData = LineChartData(dataSet: chartDataSet)
		signalChartView.data = chartData
		signalChartView.noDataText = "No data available"
		signalChartView.isUserInteractionEnabled = false
		signalChartView.xAxis.drawLabelsEnabled = false
		signalChartView.rightAxis.drawLabelsEnabled = false
		signalChartView.xAxis.drawGridLinesEnabled = false
		signalChartView.leftAxis.drawGridLinesEnabled = false
		signalChartView.rightAxis.drawGridLinesEnabled = false
		signalChartView.xAxis.drawAxisLineEnabled = false
		signalChartView.rightAxis.drawAxisLineEnabled = false
		signalChartView.leftAxis.drawAxisLineEnabled = false
		signalChartView.leftAxis.axisMaximum = 1000.0
		signalChartView.leftAxis.axisMinimum = 0.0
		signalChartView.chartDescription = nil
		signalChartView.notifyDataSetChanged()
		signalChartView.invalidateIntrinsicContentSize()
	}
}
