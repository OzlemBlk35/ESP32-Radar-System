#include <ESP32Servo.h>

// Defines Trig and Echo pins of the Ultrasonic Sensor
const int trigPin = 14;
const int echoPin = 12;
const int ledPin  = 13;
const int SERVO_DELAY = 30; 

// Variables for the duration and the distance
long duration;
int distance;

Servo myServo; // Creates a servo object for controlling the servo motor

void setup() {
  pinMode(trigPin, OUTPUT);   // Sets the trigPin as an Output
  pinMode(echoPin, INPUT);    // Sets the echoPin as an Input
  pinMode(ledPin, OUTPUT);    
  Serial.begin(115200);     
  myServo.attach(27);        
}

void loop() {
  for (int i = 15; i <= 165; i++) {
    myServo.write(i);
    delay(SERVO_DELAY);
    distance = calculateDistance();

    if (distance > 0) {
      digitalWrite(ledPin, HIGH);
    } else {
      digitalWrite(ledPin, LOW);
    }

    Serial.print(i);
    Serial.print(" , ");
    Serial.print(distance);
    Serial.print(" cm");
    Serial.println();
  }

  for (int i = 165; i >= 15; i--) {
    myServo.write(i);
    delay(SERVO_DELAY);
    distance = calculateDistance();
  }
}

// Function for calculating the distance measured by the Ultrasonic sensor
int calculateDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH, 30000); // 30 ms timeout

  if (duration == 0) return 0; // Timeout 

  distance = duration * 0.034 / 2;

  if (distance >= 10 && distance <= 40) {
    return distance;
  } else {
    return 0;
  }
}







