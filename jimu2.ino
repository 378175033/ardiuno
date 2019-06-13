#include <SoftwareSerial.h>
#include <Metro.h> // Include Metro library

SoftwareSerial mySerial(10, 11); // RX, TX
const int buttonPin = 4;     // the number of the pushbutton pin
int buttonState = 0;         // variable for reading the pushbutton status
const String id = "e";
String otherId = "";
String sendStr = "";
String sendId = "";
Metro metro0 = Metro(700); 



void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(57600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  pinMode(buttonPin, INPUT);
  // set the data rate for the SoftwareSerial port
  mySerial.begin(57600);
}

void loop() { // run over and over
  if (metro0.check() == 1) { 
      buttonState = digitalRead(buttonPin);
    // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
    if (buttonState == HIGH) {
      sendId=id+"B";
    }else{
      sendId=id;
      }
    if (mySerial.available()>0) {
      otherId = mySerial.readStringUntil('\n');
      sendStr = sendId+ "," + otherId;
    }else{
      sendStr = sendId;
    }
    mySerial.println(sendStr);
    Serial.println(sendStr);
  }

  
}
