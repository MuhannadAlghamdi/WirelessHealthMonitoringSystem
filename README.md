# Wireless Health Monitoring System
This project can used to sensd body temperature and heart rate of a patient for monitoring physiological conditions using wireless sensor network (WSN) to send data to mobile app. The system is composed of Arduino microcontrollers (placed in the patient), LM35 sensor (used for the sense body temperature) and heart beat sensor (used for sensing heart rate), ZigBee, smartphones and softwares such as LabView and Xcode.


## Project Devices
### Arduino nano

![Alt text](/Users/muhannadalghamdi/Desktop/WirelessHealthMonitoringSystem/Pictures/arduino_nano.png "Optional title")
The Arduino Nano is a small, complete, and breadboard-friendly board based on the ATmega328 (Arduino Nano 3.x). It has more or less the same functionality of the Arduino Duemilanove, but in a different package. It lacks only a DC power jack, and works with a Mini-B USB cable instead of a standard one. This component is selected because its small and it can work with HM-10 BLE module.

### HM-10 BLE module


![Alt text](/Users/muhannadalghamdi/Desktop/WirelessHealthMonitoringSystem/Pictures/hm10_ble.png "Optional title")

The HM-10 is a readily available Bluetooth 4.0 module based on the Texas Instruments CC2540 and CC2541 Bluetooth low energy (BLE) System on Chip (SoC). This bluetooth module is cost low energy and it be suitable for IOS device like iphone or ipad. The pin on HM-10 for data translation are TX and RX, they are translate signal to remote port and receive signal from remote port. Those two pins can be connected with RX and TX on arduino board or other pin on arduino board.

### SEN-11574 Pulse Sensor

![Alt text](/Users/muhannadalghamdi/Desktop/WirelessHealthMonitoringSystem/Pictures/pulse_sensor.png "Optional title")

The Pulse Sensor Amped is a plug-and-play heart-rate sensor for Arduino. It can be used by students, artists, athletes, makers, and game & mobile developers who want to easily incorporate live heart-rate data into their projects.It essentially combines a simple optical heart rate sensor with amplification and noise cancellation circuitry making it fast and easy to get reliable pulse readings. Also, it sips power with just 4mA current draw at 5V so its great for mobile applications. This component is selected because its the only sensor to easy to find and its reading is accurately. For using this heartbeat sensor just connect its S pin to any arduino analog pin and also connect ground and 5v to arduino.

### LM35 Temperature Sensor

![Alt text](/Users/muhannadalghamdi/Desktop/WirelessHealthMonitoringSystem/Pictures/lm35.png "Optional title")
The Arduino Nano is a small, complete, and breadboard-friendly board based on the ATmega328 (Arduino Nano 3.x). It has more or less the same functionality of the Arduino Duemilanove, but in a different package. It lacks only a DC power jack, and works with a Mini-B USB cable instead of a standard one. This component is selected because its small and it can work with HM-10 BLE module.

## Device Design

In order to minimize the size of the device, we soldered all components including pulse sensor, temperature sensor, Bluetooth chip, and battery case onto the Arduino Nano then covered by a portable strap that can be attached to a patients wrist. This way will allow collected data to be sent to the iOS application continuously.

![Alt text](/Users/muhannadalghamdi/Desktop/WirelessHealthMonitoringSystem/Pictures/health_monitor_schematic.png  "Optional title")

Because the pulse sensor is a sensitive finger-type pulse detector; records data by using the amount of infrared light reflected by the blood flow inside of fingers, we designed a convenient finger clip that can be fits over a fingertip very safely as shown in Figure 2. The shape of the finger clip is flexible and capable to hold the sensor very formally, press it closely against the skin, and allow the wire to go out though the case. These features contributed to increase the stability of signal and improve the accuracy of data.

![Alt text](/Users/muhannadalghamdi/Desktop/WirelessHealthMonitoringSystem/Pictures/pulse_sensor_3d_clipper.png "Optional title")

## Algorithms
### Temperature Algorithm

The body temperature is measured by using LM35 sensor where temperature can be calculated in Celsius, Fahrenheit, or Kelvin. We defined the output pin of the LM35 temperature sensor to be

```arduino
int tempPin = 1;
```

Before we can get a Celsius reading, we must read the analog output voltage. Once we have the raw voltage, we then divide by 1024.0 times 5000 because there is 5000 millvolts in 5 volts.

```arduino
int rawVoltage = analogRead(tempPin);float milliVolts = (rawVoltage / 1024.0) ∗ 5000;
float tempC = milliVolts / 10;
```
### Heart Beat Algorithm

Pulse sensor is very common sensor for measuring heart beat rate by simply clipping the sensor over fingertip. So, when the Arduino is powered up and the Pulse Sensor is plugged into,

```arduino
int pulsePin = 0;
```

it constantly reads the sensor value and looks for the heart beat every 2 mS.

```arduino
Signal = analogRead(pulsePin); sampleCounter += 2;int N = sampleCounter − lastBeatTime;
```

First we read the Pulse Sensor then keep track of the time in mS with sampleCounter. Next, we monitor the time since the last beat to avoid noise.

### Bluetooth Algorithm (HM-10)

The HM-10 is a low coast Bluetooth module that can easily used with the Arduino using serial communication to send data to iOS application. Once the chip is configured, it relays the commands from the App by Bluetooth to the Arduino and replays the corresponding result to the App to be displayed. The function for processing these commands is shown below.

```arduino
  if (bluetoothSerial.available()) {
    char bluetoothData = bluetoothSerial.read();

    if (bluetoothData == '0') {
      // Convert Signal to char array.
      String str = zero + part + Signal;
      int str_len = str.length() + 1;
      char SignalArray[str_len];
      str.toCharArray(SignalArray, str_len);
      bluetoothSerial.write(SignalArray);
      
    } else if (bluetoothData == '1') {
      // Convert BPM to char array.
      String str = one + part + BPM;
      int str_len = str.length() + 1;
      char BPMArray[str_len];
      str.toCharArray(BPMArray, str_len);
      bluetoothSerial.write(BPMArray);
      
    } else if (bluetoothData == '2') {
      // Convert Temp to char array.
      String str = two + part + Temp;
      int str_len = str.length() + 1;
      char TempArray[str_len];
      str.toCharArray(TempArray, str_len);
      bluetoothSerial.write(TempArray);
    }
  }
```

### Bluetooth Algorithm (iOS)

In this part, we will show how to connect an iOS device with HM-10 to read data from the sensors and display it on the chart. First, we most import the CoreBluetooth Framework in the project

```swift
import CoreBluetooth
```

Now, to grab any data coming from the HM-10 and print it to the chart and labels, we have to add this function and call it every time we have to read a value from the sensor

```swift
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
```


