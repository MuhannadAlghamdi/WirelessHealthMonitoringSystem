//
//  TableViewController.swift
//  HealthMonitoring
//
//  Created by Muhannad Alghamdi on 5/17/17.
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

class SecondViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		// Clear devices dictionary.
		devices.removeAll(keepingCapacity: false)
		devicesRSSI.removeAll(keepingCapacity: false)
		// Initialize central manager on load.
		activeCentralManager = CBCentralManager(delegate: self, queue: nil)
		
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(SecondViewController.update), for: UIControlEvents.valueChanged)
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
	
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch (central.state) {
		case CBManagerState.poweredOff:
			// Can have different conditions for all states if needed - print generic message for now
			print("Bluetooth switched off or not initialized")
			break
		case CBManagerState.poweredOn:
			// Scan for peripherals if BLE is turned on
			central.scanForPeripherals(withServices: nil, options: nil)
			print("Searching for BLE Devices")
			break
		default:
			break
		}
	}
	
	// Check out the discovered peripherals to find Sensor Tag.
	func centralManager(_ central: CBCentralManager?, didDiscoverPeripheral peripheral: CBPeripheral?, advertisementData: [AnyHashable: Any]!, RSSI: NSNumber!) {
		if let central = central {
			if let peripheral = peripheral {
				// Get this device's UUID.
				if let name = peripheral.name {
					if(devices[name] == nil) {
						devices[name] = peripheral
						devicesRSSI.append(RSSI)
						self.tableView.reloadData()
					}
				}
			}
		}
	}
	
	// Discover services of the peripheral.
	func centralManager(_ central: CBCentralManager?, didConnect peripheral: CBPeripheral?) {
		if let central = central {
			if let peripheral = peripheral {
				// Discover services for the device.
				if let peripheralDevice = peripheralDevice {
					peripheralDevice.discoverServices(nil)
					if let navigationController = navigationController {
						navigationItem.title = "Connected to \(deviceName)"
					}
				}
			}
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral?, didDiscoverServices error: Error!) {
		if let peripheral = peripheral {
			// Iterate through the services of a particular peripheral.
			for service in peripheral.services! {
				let thisService = service as? CBService
				// Let's see what characteristics this service has.
				if let thisService = thisService {
					peripheral.discoverCharacteristics(nil, for: thisService)
					if let navigationController = navigationController {
						navigationItem.title = "Discovered Service for \(deviceName)"
					}
				}
			}
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral?, didDiscoverCharacteristicsFor service: CBService?, error: Error?) {
		if let peripheral = peripheral {
			if let service = service{
				// check the uuid of each characteristic to find config and data characteristics
				for charateristic in service.characteristics! {
					let thisCharacteristic = charateristic
					// Set notify for characteristics here.
					peripheral.setNotifyValue(true, for: thisCharacteristic)
					if let navigationController = navigationController {
						navigationItem.title = "Discovered Characteristic for \(deviceName)"
					}
					
					deviceCharacteristics = thisCharacteristic
				}
				
				// Now that we are setup, return to main view.
				if let navigationController = navigationController {
					navigationController.popViewController(animated: true)
				}
			}
		}
	}
	
	// Get data values when they are updated
	func peripheral(_ peripheral: CBPeripheral?, didUpdateValueFor characteristic: CBCharacteristic?, error: Error!) {
		print("Got some!")
	}
	
	func cancelConnection() {
		if let activeCentralManager = activeCentralManager{
			print("Died!")
			if let peripheralDevice = peripheralDevice {
				//println(peripheralDevice)
				activeCentralManager.cancelPeripheralConnection(peripheralDevice)
			}
		}
	}
	
	// If disconnected, start searching again
	func centralManager(_ central: CBCentralManager?, didDisconnectPeripheral peripheral: CBPeripheral?, error: Error?) {
		if let central = central {
			if let peripheral = peripheral {
				print("Disconnected")
				central.scanForPeripherals(withServices: nil, options: nil)
			}
		}
	}
	
	func writeValue(_ data: String) {
		let data = (data as NSString).data(using: String.Encoding.utf8.rawValue)
		if let peripheralDevice = peripheralDevice {
			if let deviceCharacteristics = deviceCharacteristics {
				peripheralDevice.writeValue(data!, for: deviceCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return devices.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// Let's get a cell.
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UITableViewCell
		// Turn the device dictionary into an array.
		let discoveredPeripheralArray = Array(devices.values)
		//println(discoveredPeripheralArray.count)
		// Set the main label of the cell to the name of the corresponding peripheral.
		if let cell = cell {
			if let name = discoveredPeripheralArray[indexPath.row].name {
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
				// Stop looking for more peripherals.
				activeCentralManager.stopScan()
				// Connect to this peripheral.
				activeCentralManager.connect(peripheralDevice!, options: nil)
				if let navigationController = navigationController {
					navigationItem.title = "Connecting \(deviceName)"
				}
			}
		}
	}
}


extension SecondViewController: MIPivotRootPage {
	
	func imageForPivotPage() -> UIImage? {
		return UIImage(named: "medical_report")
	}
}
