//
//  BluetoothTableViewController.swift
//  HealthMonitor
//
//  Created by Muhannad Alghamdi on 5/19/17.
//  Copyright © 2017 Muhannad. All rights reserved.
//

import UIKit
import CoreBluetooth

var activeCentralManager: CBCentralManager?
var peripheralDevice: CBPeripheral?

var devices: Dictionary<String, CBPeripheral> = [:]
var deviceName: String?
var devicesRSSI = [NSNumber]()
var devicesServices: CBService!
var deviceCharacteristics: CBCharacteristic!

class BLETableViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		// Clear devices dictionary.
		devices.removeAll(keepingCapacity: false)
		devicesRSSI.removeAll(keepingCapacity: false)
		// Initialize central manager on load
		activeCentralManager = CBCentralManager(delegate: self, queue: nil)
		
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(BLETableViewController.update), for: UIControlEvents.valueChanged)
		self.refreshControl = refreshControl
	}
	
	func update() {
		// Clear devices dictionary.
		devices.removeAll(keepingCapacity: false)
		devicesRSSI.removeAll(keepingCapacity: false)
		// Initialize central manager on load
		activeCentralManager = CBCentralManager(delegate: self, queue: nil)
		self.refreshControl?.endRefreshing()
	}
	
	func cancelConnection() {
		if let activeCentralManager = activeCentralManager {
			print("Died!")
			if let peripheralDevice = peripheralDevice {
				//println(peripheralDevice)
				activeCentralManager.cancelPeripheralConnection(peripheralDevice)
			}
		}
	}
	
	// Invoked when the central manager’s state is updated.
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch (central.state) {
		case CBManagerState.poweredOff:
			// Can have different conditions for all states if needed - print generic message for now.
			print("Bluetooth switched off or not initialized")
			break
		case CBManagerState.poweredOn:
			// Scan for peripherals if BLE is turned on.
			central.scanForPeripherals(withServices: nil, options: nil)
			print("Searching for BLE Devices")
			break
		default:
			break
		}
	}
	
	// Check out the discovered peripherals to find Sensor Tag.
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		// Get this device's UUID.
		if let name = peripheral.name {
			if (devices[name] == nil) {
				devices[name] = peripheral
				devicesRSSI.append(RSSI)
				self.tableView.reloadData()
			}
		}
	}
	
	// If disconnected, start searching again.
	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		print("Disconnected")
		central.scanForPeripherals(withServices: nil, options: nil)
	}
	
	// Discover services of the peripheral.
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		// Discover services for the device.
		if let peripheralDevice = peripheralDevice {
			peripheralDevice.discoverServices(nil)
			navigationItem.title = "Connected to \(String(describing: deviceName))"
		}
	}
	
	// Invoked when you discover the peripheral’s available services.
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		// Iterate through the services of a particular peripheral.
		for service in peripheral.services! {
			let thisService = service as? CBService
			// Let's see what characteristics this service has.
			if let thisService = thisService {
				peripheral.discoverCharacteristics(nil, for: thisService)
				navigationItem.title = "Discovered Service for \(String(describing: deviceName))"
				}
			}
		}
	
	// Invoked when you discover the characteristics of a specified service.
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		// check the uuid of each characteristic to find config and data characteristics.
		for charateristic in service.characteristics! {
			let thisCharacteristic = charateristic
			// Set notify for characteristics here.
			peripheral.setNotifyValue(true, for: thisCharacteristic)
			navigationItem.title = "Discovered Characteristic for \(String(describing: deviceName))"
			deviceCharacteristics = thisCharacteristic
		}
		
		// Now that we are setup, return to main view.
		navigationController?.popViewController(animated: true)
	}
	
	// Get data values when they are updated
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		print("Got some!")
	}
	
	// Tells the data source to return the number of rows in a given section of a table view.
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return devices.count
	}
	
	// Asks the data source for a cell to insert in a particular location of the table view.
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
		// Turn the device dictionary into an array.
		let discoveredPeripheralArray = Array(devices.values)
		//println(discoveredPeripheralArray.count)
		
		// Set the main label of the cell to the name of the corresponding peripheral.
		if let cell = cell {
			if let name = discoveredPeripheralArray[indexPath.row].name{
				if let textLabelText = cell.textLabel {
					textLabelText.text = name
				}
				
				if let detailTextLabel = cell.detailTextLabel {
					detailTextLabel.text = devicesRSSI[indexPath.row].stringValue
				}
			}
		}
		
		return cell!
	}
	
	// Tells the delegate that the specified row is now selected.
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (devices.count > 0) {
			// Get an array of peripherals.
			let discoveredPeripheralArray = Array(devices.values)
			
			// Set the peripheralDevice to the corresponding row selected.
			peripheralDevice = discoveredPeripheralArray[indexPath.row]
			
			// Attach the peripheral delegate.
			if let peripheralDevice = peripheralDevice {
				peripheralDevice.delegate = self
				deviceName = peripheralDevice.name!
			} else {
				deviceName = " "
			}
			
			if let activeCentralManager = activeCentralManager {
				// Stop looking for peripherals.
				activeCentralManager.stopScan()
				
				// Connect to this peripheral.
				activeCentralManager.connect(peripheralDevice!, options: nil)
				navigationItem.title = "Connecting \(String(describing: deviceName))"
			}
		}
	}
}
