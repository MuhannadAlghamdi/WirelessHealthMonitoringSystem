int Signal;
int Threshold = 550;
int PulseSensorPurplePin = 0;

void setup() {
	Serial.begin(9600);
}
void loop() {
	Signal = analogRead(PulseSensorPurplePin);
	Serial.println(Signal);
	delay(10);
}