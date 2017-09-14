#include <SoftwareSerial.h>
#define TX 8            // RX is digital pin 8 (connect to TX of other device)
#define RX 7            // TX is digital pin 7 (connect to RX of other device)
SoftwareSerial bluetoothSerial(TX, RX);

int pulsePin = 0;
int tempPin = 1;

volatile int Temp;
volatile int Signal;              // Holds the incoming raw data.
volatile int BPM;                 // Int that holds raw Analog in 0. Updated every 2mS.
volatile int IBI = 600;           // Int that holds the time interval between beats! Must be seeded!
volatile boolean Pulse = false;   // "True" when user's live heartbeat is detected. "False" when not a "live beat".
volatile boolean QS = false;      // becomes true when Arduoino finds a beat.

void setup() {
  Serial.begin(9600);
  bluetoothSerial.begin(9600);

  // Sets up to read Pulse Sensor signal every 2mS.
  interruptSetup();
}

void loop() {
  delay(20);
  serialOutput();
}

void serialOutput() {
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

  Serial.print(Signal);
  Serial.print(",");
  Serial.print(BPM);
  Serial.print(",");
  Serial.println(Temp);
}
