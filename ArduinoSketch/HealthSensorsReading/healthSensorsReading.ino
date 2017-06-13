#include <SoftwareSerial.h>
#define TX 7						// RX is digital pin 8 (connect to TX of other device)
#define RX 8						// TX is digital pin 7 (connect to RX of other device)
SoftwareSerial bluetoothSerial(TX, RX);

String zero = "0"; String one = "1"; String two = "2"; String part = ",";

int pulsePin = 0;
int tempPin = 1;

int Temp;
volatile int BPM;					        // Int that holds raw Analog in 0. Updated every 2mS.
volatile int Signal;				      // Holds the incoming raw data.
volatile int IBI = 600;				    // Int that holds the time interval between beats! Must be seeded!
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
  Serial.print(Signal);
  Serial.print(",");
  Serial.print(BPM);
  Serial.print(",");
  Serial.println(Temp);

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
      Temp = analogRead(tempPin);
      String str = two + part + Temp;
      int str_len = str.length() + 1;
      char TempArray[str_len];
      str.toCharArray(TempArray, str_len);
      bluetoothSerial.write(TempArray);
    }
  }
}
