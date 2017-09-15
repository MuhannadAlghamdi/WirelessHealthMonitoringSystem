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
	@IBOutlet weak var stopReading: UIBarButtonItem!
	@IBOutlet weak var startReading: UIBarButtonItem!
	@IBOutlet weak var BPMView: UILabel!
	@IBOutlet weak var tempCView: UILabel!
	@IBOutlet weak var tempFView: UILabel!
	@IBOutlet weak var signalChartView: LineChartView!
	@IBOutlet weak var circularBar: KDCircularProgress!
	@IBOutlet weak var heartBeatImageView: UIImageView!
	
	@IBAction func startReading(_ sender: Any) {
		signalTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(writeValue), userInfo: nil, repeats: true)
	}
	
	var signalTimer: Timer!
	var i = 0
	var buffer = 0
	var BPM = 0
	var IBI = 0
	var tempArray:[Int] = []
	var signalArray: [Int] = []
	var dataEntries: [ChartDataEntry] = []
	var characteristics = [String : CBCharacteristic]()
	
	// Return average temperature.
	func average(temp: [Int]) -> Double {
		var array = temp
		
		// Make array maximum size to 10.
		if array.count == 10 {
			array.remove(at: 0)
		}
		
		var total = 0
		for i in array {
			total += i
		}
		
		let count = array.count
		let average = total/count
		return Double(average)
	}
	
	// Called after the view has been loaded.
	override func viewDidLoad() {
		super.viewDidLoad()
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
	
	// Write function.
	func writeValue() {
		switch buffer {
		case 0:
			let data = ("\(buffer)" as NSString).data(using: String.Encoding.utf8.rawValue)
			peripheralDevice?.writeValue(data!, for: deviceCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
		case 1:
			let data = ("\(buffer)" as NSString).data(using: String.Encoding.utf8.rawValue)
			peripheralDevice?.writeValue(data!, for: deviceCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
		case 2:
			let data = ("\(buffer)" as NSString).data(using: String.Encoding.utf8.rawValue)
			peripheralDevice?.writeValue(data!, for: deviceCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
		default:
			break
		}
		
		// Increment buffer.
		if ((buffer + 1) >= 3) {
			buffer = 0
		} else {
			buffer += 1
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
		print(stringFromData)
		
		switch array[0] {
		case "0":
			// Get singal and update chart.
			signalArray.append(Int(array[1])!)
			setChart()
			break
		case "1":
			// Check if BPM has changed.
			if (BPM != Int(array[1])!) {
				let time = (Double(array[1])! / 300.0)
				animateHeartBeat(duration: time, delay: 0.0)
			}
			
			// Get BPM and update view.
			BPM = Int(array[1])!
			BPMView.text = array[1]
			updateProgressBar(days: Int(array[1])!, max: 1000)
			break
		case "2":
			// Get temperature and update view.
			tempArray.append(Int(array[1])!)
			
			var celsius = (average(temp: tempArray)/1024) * 500
			var fahrenheit = (celsius * 9)/5 + 32
			
			tempCView.text = "\(celsius.rounded())°C"
			tempFView.text = "\(fahrenheit.rounded())°F"
			break
		default:
			break
		}
		
		// Make signalArray maximum size to 90.
		if signalArray.count == 90 {
			signalArray.remove(at: 0)
		}
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
	
	// Update Progress bar.
	func updateProgressBar(days: Int, max: Int) -> Void {
		var counterDays = Double(days)
		let maxDays = Double(max)
		
		// Limit the bar from passing the container.
		if (counterDays >= (maxDays - 1.0)) {
			counterDays = maxDays
		}
		
		let newAngleValue = Int(360 * (counterDays / maxDays))
		circularBar.animate(toAngle: Double(newAngleValue), duration: 1.0, completion: nil)
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
