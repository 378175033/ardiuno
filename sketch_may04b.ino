#include <SoftwareSerial.h>
#include <Metro.h> // Include Metro library

SoftwareSerial mySerial(10, 11); // RX, TX
const int buttonPin = 4;     // the number of the pushbutton pin
int buttonState = 0;         // variable for reading the pushbutton status
const String id = "a";
String otherId = "";
String sendStr = "";

Metro metro0 = Metro(150); 
Metro metro1 = Metro(50);   // butten


void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(4800);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  pinMode(buttonPin, INPUT);
//   set the data rate for the SoftwareSerial port
  mySerial.begin(4800);
}

void loop() { // run over and over
  if (metro0.check() == 1) { 
    if (mySerial.available()>0) {
      otherId = mySerial.readStringUntil('\n');
      sendStr = id + "," + otherId;
//      if (otherId.length() < 3){
//        sendStr = 3;  
//      }
//    }else{
//      sendStr = id;
//    }
    mySerial.println(sendStr);
//    Serial.write(sendStr);
    Serial.println(sendStr);
    sendStr = "";
  }
  }
//  if (metro1.check() == 1) { 
//    buttonState = digitalRead(buttonPin);
//    // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
//    if (buttonState == HIGH) {
//      Serial.println(3);
//      mySerial.println(3);
//    } 
//  }
}
