int LEDPin13 = 13;
int pulseSensorPin0 = 0;
// Stores raw data. Range from 0 - 1024.
int signal;
// The best signal as a beat.
int threshold = 550;

void setup() {
    pinMode(LEDPin13, OUTPUT);
    // Set's up Serial Communication at certain speed.
    Serial.begin(9600); 
}

void loop() {
    // Read the PulseSensor's value and assign it to signal.
    signal = analogRead(pulseSensorPin0);
    // Send the signal value to serial plotter.
    Serial.println(signal);

    // If the signal is above "550", then "turn-on" Arduino's on-Board LED.  
    if (signal > Threshold) {
        digitalWrite(LEDPin13,HIGH);          
    }
    // The sigal must be below "550", so "turn-off" this LED.
    else {
        digitalWrite(LEDPin13,LOW);
    }

    delay(10);
}