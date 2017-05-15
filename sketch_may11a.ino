#include <SoftwareSerial.h>
#define TX 7
#define RX 8

int val;
int tempPin = 1;

SoftwareSerial mySerial(TX, RX); // TX, RX  

void setup()
{
Serial.begin(9600);
mySerial.begin(9600);

}
void loop()
{
int c;

val = analogRead(tempPin);
float mv = ( val/1024.0)*5000; 
float cel = mv/10;
float farh = (cel*9)/5 + 32;

int data = cel;

Serial.print("TEMPRATURE = ");
Serial.print(cel);
Serial.print("*C");
Serial.println();
delay(100);

if (mySerial.available()) {
    c = mySerial.read();  
    Serial.println("Got input:");
   
    if (c != 0)
    {
      Serial.println("  on");
      mySerial.write(data);
     }
   else
    {
      // Input value zero means "turn off LED".
      Serial.println("  off");
      //digitalWrite(LED_, LOW);
    }  
    //int a = digitalRead(TX);
    // Serial.println(a);
    // delay(10);
  }
/* uncomment this to get temperature in farenhite 
Serial.print("TEMPRATURE = ");
Serial.print(farh);
Serial.print("*F");
Serial.println();


*/
}

