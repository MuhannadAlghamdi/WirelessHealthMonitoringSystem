int pulseSensorPin0 = 0;    // The analog pin is connected to pulse sensor.
int ledPin13 = 13;          // LED light is connected to pin 13.
int threshold = 550;        // The best beat signal.
int signalReading;          // Store pulse sensor value.

void setup() {
    pinMode(ledPin13, OUTPUT);
    // Set's up Serial Communication at certain speed.
    Serial.begin(9600); 
}

void loop() {
    // Read the pulse sensor's value and assign it to signal.
    signalReading = analogRead(pulseSensorPin0);
    // Send the signal value to serial plotter.
    Serial.println(signalReading);

    // If the signal is above "550", then "turn-on" Arduino's on-Board LED.  
    if (signalReading > threshold) {
        digitalWrite(ledPin13,HIGH);          
    }
    // The sigal must be below "550", so "turn-off" this LED.
    else {
        digitalWrite(ledPin13,LOW);
    }

    delay(10);
}
