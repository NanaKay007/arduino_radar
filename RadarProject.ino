#include <Servo.h> //library for controlling the servo
#include <NewPing.h> //library for controlling ultrasonic sensor

Servo myServo;
#define TRIGGER_PIN 12 
#define ECHO_PIN 11
#define MAX_DISTANCE 200 //set ultrasonic range to 200cm

//initialize the sonar object for the ultrasonic sensor
NewPing sonar(TRIGGER_PIN,ECHO_PIN,MAX_DISTANCE);


void setup() { 
  Serial.begin(115200);
  myServo.attach(13);
  myServo.write(0); //sets the servo at 0 degrees
}

void loop() {
  //rotates the servo by a half turn (from 0 to 180 degrees)
  for (int i = 0; i <= 180; i++){
    myServo.write(i);
    
    int distance = sonar.ping_cm();
    /*
     * writes the (angle,distance) pairs to the serial port
     */
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");  
    delay(10); // the delay ensures a steady continuous rotation for the servo
  }

  //rotates the servo by another half turn in the opposite direction
  //(from 180 back to 0)
  for (int j = 180; j >= 0; j--){
    myServo.write(j);
    int distance = sonar.ping_cm();
    Serial.print(j);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
    delay(10);
  } 
  
}
