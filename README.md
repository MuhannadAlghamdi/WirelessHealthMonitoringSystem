# Wireless Health Monitoring System

This project can be used to measure body temperature and heart rate of a patient for monitoring physiological conditions using wireless sensor network (WSN). The system is composed of two phases: health monitoring device embedded on a patient's body and iOS mobile app for doctors to evaluate current condition of patient.

![Alt text](https://github.com/MhAlghamdi/WirelessHealthMonitoringSystem/blob/PreUpdate/Images/animated_gif.gif "Optional title")

## Project Devices
### Arduino nano

![Alt text](https://github.com/MhAlghamdi/WirelessHealthMonitoringSystem/blob/PreUpdate/Images/arduino_nano.png "Optional title")

The Arduino Nano is a small, complete, and breadboard-friendly board based on the ATmega328 (Arduino Nano 3.x). It has more or less the same functionality of the Arduino Duemilanove, but in a different package. It lacks only a DC power jack, and works with a Mini-B USB cable instead of a standard one. This component is selected because its small and it can work with HM-10 BLE module.

### HM-10 BLE module


![Alt text](https://github.com/MhAlghamdi/WirelessHealthMonitoringSystem/blob/PreUpdate/Images/hm10_ble.png "Optional title")

The HM-10 is a readily available Bluetooth 4.0 module based on the Texas Instruments CC2540 and CC2541 Bluetooth low energy (BLE) System on Chip (SoC). This bluetooth module is cost low energy and it be suitable for iOS device like iphone or ipad. The pin on HM-10 for data translation are TX and RX, they are translate signal to remote port and receive signal from remote port. Those two pins can be connected with RX and TX on arduino board or other pin on arduino board.

### SEN-11574 Pulse Sensor

![Alt text](https://github.com/MhAlghamdi/WirelessHealthMonitoringSystem/blob/PreUpdate/Images/pulse_sensor.png "Optional title")

The Pulse Sensor Amped is a plug-and-play heart-rate sensor for Arduino. It can be used by students, artists, athletes, makers, and game & mobile developers who want to easily incorporate live heart-rate data into their projects.It essentially combines a simple optical heart rate sensor with amplification and noise cancellation circuitry making it fast and easy to get reliable pulse readings. Also, it sips power with just 4mA current draw at 5V so its great for mobile applications. This component is selected because its the only sensor to easy to find and its reading is accurately. For using this heartbeat sensor just connect its S pin to any arduino analog pin and also connect ground and 5v to arduino.

### LM35 Temperature Sensor

![Alt text](https://github.com/MhAlghamdi/WirelessHealthMonitoringSystem/blob/PreUpdate/Images/lm35.png "Optional title")

LM35 is a precision IC temperature sensor with its output proportional to the temperature (in oC).
The sensor circuitry is sealed and therefore it is not subjected to oxidation and other processes.
With LM35, temperature can be measured more accurately than with a thermistor. It also possess
low self heating and does not cause more than 0.1 oC temperature rise in still air. The operating
temperature range is from -55C to 150C. The output voltage varies by 10 mV in response to every
C rise/fall in ambient temperature, i.e., its scale factor is 0.01V/ C. For using this sensor just
connect output pin to any arduino analog pin and also connect Gnd and 5V to arduino.

## Device Design

In order to minimize the size of the device, we soldered all components including pulse sensor, temperature sensor, Bluetooth chip, and battery case onto the Arduino Nano then covered by a portable strap that can be attached to a patients wrist. This way will allow collected data to be sent to the iOS application continuously.

![Alt text](https://github.com/MhAlghamdi/WirelessHealthMonitoringSystem/blob/PreUpdate/Images/health_monitor_schematic.png  "Optional title")

## Algorithms
### Temperature Algorithm

The body temperature is measured by using LM35 sensor where temperature can be calculated in Celsius, Fahrenheit, or Kelvin. We defined the output pin of the LM35 temperature sensor to be

```arduino
int tempPin = 1;
```

Before we can get a Celsius reading, we must read the analog output voltage. Once we have the raw voltage, we then divide by 1024.0 times 5000 because there is 5000 millvolts in 5 volts.

```arduino
int rawVoltage = analogRead(tempPin);
float milliVolts = (rawVoltage / 1024.0) ∗ 5000;
float tempC = milliVolts / 10;
```
### Heart Beat Algorithm

Pulse sensor is very common sensor for measuring heart beat rate by simply clipping the sensor over fingertip. So, when the Arduino is powered up and the Pulse Sensor is plugged into,

```arduino
int pulsePin = 0;
```

it constantly reads the sensor value and looks for the heart beat every 2 mS.

```arduino
Signal = analogRead(pulsePin); sampleCounter += 2;
int N = sampleCounter − lastBeatTime;
```

First we read the Pulse Sensor then keep track of the time in mS with sampleCounter. Next, we monitor the time since the last beat to avoid noise.

### Bluetooth Algorithm (HM-10)

The HM-10 is a low coast Bluetooth module that can easily used with the Arduino using serial communication to send data to iOS application. Once the chip is configured, it relays the commands from the App by Bluetooth to the Arduino and replays the corresponding result to the App to be displayed. The function for processing these commands is shown below.

```arduino
if (bluetoothSerial.available()) {
    char bluetoothData = bluetoothSerial.read();

    if (bluetoothData == '0') {
        // Convert Signal to char array.
        String sep = "0,";
        String str = sep + Signal;
        int strlen = str.length() + 1;
        char SignalArray[strlen];
        str.toCharArray(SignalArray, strlen);
        bluetoothSerial.write(SignalArray);
    } else if (bluetoothData == '1') {
        // Convert BPM to char array.
        String sep = "1,";
        String str = sep + BPM;
        int strlen = str.length() + 1;
        char BPMArray[strlen];
        str.toCharArray(BPMArray, strlen);
        bluetoothSerial.write(BPMArray);
    } else if (bluetoothData == '2') {
        // Convert Temp to char array.
        Temp = analogRead(tempPin);
        String sep = "2,";
        String str = sep + Temp;
        int strlen = str.length() + 1;
        char TempArray[strlen];
        str.toCharArray(TempArray, strlen);
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
}
```

## Calculation of BPM and Temperature

Heart rate is measured by systolic heart rate which measures the pressure in our blood vessels when your heart beats and the diastolic heart rate which measures the pressure in your blood vessels when your heart rests between beats. Calculating these values and comparing it with the body temperature, we would be able to make a close estimation of human health condition as shown in the table below.

| Normal  | Abnormal | High |
| ------------- | ------------- | ------------- |
| The average normal temperature is 98.6F (37C).  | Hypothermia: 95F (35C) or below. | High fever: 103F (39.5C) or above.  |
| Normal resting heart rate is between 60 and 100 BPM. | If heart rate is closer to 60 bpm or lower. | If heart rate is closer to 150 bpm or higher. |

## Application

After verifying that all signals are measured and calculated in Arduino, as shown below, we were able to send these data to the App and display it using multiple different style to represent data.

![Alt text](https://github.com/MhAlghamdi/WirelessHealthMonitoringSystem/blob/PreUpdate/Images/signal1.png  "Optional title")

The circular chart represents the overall health to the patent. The first third portion of the circuit indicates the health is normal but when it passes the half of the circle, it will alarm the user that the health condition is abnormal.

The heart is dynamically change its speed of beating based of the BPM. The chart shows a life signal visualization of heart rate which is beneficial to the user to see the timeline of activities. Finally, body temperature and BPM are displayed in numerical values at the bottom of the App.
