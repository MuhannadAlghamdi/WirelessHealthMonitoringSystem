int pulsePin = 0;

// Volatile Variables, used in the interrupt service routine.
volatile int BPM;							// Int that holds raw Analog in 0. Updated every 2mS.
volatile int Signal;						// Holds the incoming raw data.
volatile int IBI = 600;						// Int that holds the time interval between beats! Must be seeded!
volatile boolean Pulse = false;				// "True" when user's live heartbeat is detected. "False" when not a "live beat".
volatile boolean QS = false;				// becomes true when Arduoino finds a beat.

void setup() {
	Serial.begin(115200);
	interruptSetup();						// Sets up to read Pulse Sensor signal every 2mS.
}

void loop() {
	serialOutput();
	delay(20);
}

void serialOutput() {
	Serial.print(BPM);
	Serial.print(",");
	Serial.print(IBI);
	Serial.print(",");
	Serial.println(Signal);
}