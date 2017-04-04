#define aref_voltage 5 	// Reference voltage for power supply.

int tempPin = 0;	// The analog pin is connected to temp sensor.
int tempReading;        // The analog reading from the sensor.
int lightPin1 = 3;      // Put the LED light on pin 5.
int lightPin2 = 4;      // Put the LED light on pin 6.
int lightPin3 = 5;      // Put the LED light on pin 9.

void setup(void) {
	Serial.begin(9600);
	pinMode(lightPin1, OUTPUT);
	pinMode(lightPin2, OUTPUT);
	pinMode(lightPin3, OUTPUT);
}

void loop(void) {
	// Get a temperaure reading from the temp sensor.
	tempReading = analogRead(tempPin);
	Serial.print("Temp reading = ");
	Serial.print(tempReading);
	
	// Converting reading to voltage.
	float voltage = tempReading * aref_voltage;
	voltage /= 1024.0;
	
	// Print out the voltage.
	Serial.print(" = ");
	Serial.print(voltage);
	Serial.println(" volts");
	
	// Converting voltage to degree.
	float temperatureC = (voltage – 0.5) * 100;
	Serial.print(temperatureC);
	Serial.println(" degrees C");
	
	// Converting to Fahrenheight.
	float temperatureF = (temperatureC * 9.0 / 5.0) + 32.0;
	Serial.print(temperatureF);
	Serial.println(" degrees F");

	delay(1000);
}
