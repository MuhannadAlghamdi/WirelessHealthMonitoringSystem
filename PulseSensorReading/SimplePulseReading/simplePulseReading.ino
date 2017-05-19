#include <SoftwareSerial.h>
#define TX 7 // RX is digital pin 8 (connect to TX of other device)
#define RX 8 // TX is digital pin 7 (connect to RX of other device)
SoftwareSerial bluSerial(TX, RX);

int Signal;
String SignalString;
int Threshold = 550;
int PulsePin = 0;

void setup() {
  Serial.begin(9600);
  bluSerial.begin(9600);
}

void loop() {
  Signal = analogRead(PulsePin);

  if (bluSerial.available()) {
    char data = bluSerial.read();
    Serial.print("Input: ");
    Serial.println(data);

    String str = String(Signal);
    int str_len = str.length() + 1;
    char char_array[str_len];
    str.toCharArray(char_array, str_len);

    if (data != '0') {
      Serial.print("Signal: ");
      Serial.println(Signal);
      bluSerial.write(char_array);

    } else {
      Serial.print("ELSE: ");
      Serial.println(6);
      bluSerial.write('6');
    }
  }

  delay(10);
}
