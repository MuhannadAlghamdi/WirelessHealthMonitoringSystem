#define aref_voltage 5 	// Reference voltage for power supply.

int tempPin0 = 0;		// Temp sensor is connected to pin 0.
int tempReading;        // Reading from the sensor.

void setup(void) {
	Serial.begin(9600);
}

void loop(void) {
	// Get a temperaure reading from the temp sensor.
	tempReading = analogRead(tempPin0);
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
