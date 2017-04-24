#define PROCESSING_VISUALIZER 1
#define SERIAL_PLOTTER 2

// Variables.
int pulsePin = 0;							// Pulse Sensor purple wire connected to analog pin 0.
int blinkPin = 13;							// Pin to blink led at each beat.
int fadePin = 5;							// Pin to do fancy classy fading blink at each beat.
int fadeRate = 0;							// Used to fade LED on with PWM on fadePin.

// Volatile Variables, used in the interrupt service routine.
volatile int BPM;                           // Int that holds raw Analog in 0. Updated every 2mS.
volatile int Signal;                        // Holds the incoming raw data.
volatile int IBI = 600;                     // Int that holds the time interval between beats! Must be seeded!
volatile boolean Pulse = false;             // "True" when user's live heartbeat is detected. "False" when not a "live beat".
volatile boolean QS = false;                // becomes true when Arduoino finds a beat.

// SET THE SERIAL OUTPUT TYPE TO YOUR NEEDS
// PROCESSING_VISUALIZER works with Pulse Sensor Processing Visualizer
// https://github.com/WorldFamousElectronics/PulseSensor_Amped_Processing_Visualizer
// SERIAL_PLOTTER outputs sensor data for viewing with the Arduino Serial Plotter
// Run the Serial Plotter at 115200 baud.

static int outputType = SERIAL_PLOTTER;

void setup(){
	pinMode(blinkPin,OUTPUT);               // pin that will blink to your heartbeat!
	pinMode(fadePin,OUTPUT);                // pin that will fade to your heartbeat!
	Serial.begin(115200);                   // we agree to talk fast!
	interruptSetup();                       // Sets up to read Pulse Sensor signal every 2mS.

	// IF YOU ARE POWERING The Pulse Sensor AT VOLTAGE LESS THAN THE BOARD VOLTAGE,
	// UN-COMMENT THE NEXT LINE AND APPLY THAT VOLTAGE TO THE A-REF PIN
//  analogReference(EXTERNAL);
}

// Where the Magic Happens
void loop(){
	serialOutput() ;
	if (QS == true){                        // A Heartbeat Was Found
											// BPM and IBI have been Determined
											// Quantified Self "QS" true when arduino finds a heartbeat
		fadeRate = 255;                     // Makes the LED Fade Effect Happen
											// Set 'fadeRate' Variable to 255 to fade LED with pulse
		serialOutputWhenBeatHappens();      // A Beat Happened, Output that to serial.
		QS = false;                         // reset the Quantified Self flag for next time
	}

	ledFadeToBeat();                        // Makes the LED Fade Effect Happen
	delay(20);                              // take a break
}

void ledFadeToBeat(){
	fadeRate -= 15;                         //  set LED fade value
	fadeRate = constrain(fadeRate,0,255);   //  keep LED fade value from going into negative numbers!
	analogWrite(fadePin,fadeRate);          //  fade LED
  }
