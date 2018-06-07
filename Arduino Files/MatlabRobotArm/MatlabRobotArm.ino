#include <LiquidCrystal.h>
#include <Servo.h>
#include <ArmServos.h>
#include <ArmServosSpeedControlled.h>
#include <RobotAsciiCom.h>

LiquidCrystal lcd(14, 15, 16, 17, 18, 19, 20);
#define LINE_1 0
#define LINE_2 1

// Construct instances of the classes
ArmServosSpeedControlled armServos;
RobotAsciiCom robotCom;

void setup() {
  Serial.begin(9600);
  lcd.begin(16, 2);
  armServos.attach();
  // Register functions to be called when a command is received
  robotCom.registerPositionCallback(positionCallback);
  robotCom.registerJointAngleCallback(jointAngleCallback);
  robotCom.registerGripperCallback(gripperCallback);
  lcd.clear();
  lcd.print("Ready");
}

// Called when a POSITION command is received from MATLAB
void positionCallback(int joint1Angle, int joint2Angle, int joint3Angle, int joint4Angle, int joint5Angle) {
  armServos.setPosition(joint1Angle, joint2Angle, joint3Angle, joint4Angle, joint5Angle);
  lcd.clear();
  lcd.print("Position:");
  lcd.setCursor(0, LINE_2);
  lcd.print(joint1Angle);
  lcd.print(" ");
  lcd.print(joint2Angle);
  lcd.print(" ");
  lcd.print(joint3Angle);
  lcd.print(" ");
  lcd.print(joint4Angle);
  lcd.print(" ");
  lcd.print(joint5Angle);
}

// Called when a JOINT ANGLE command is received from MATLAB
void jointAngleCallback(byte jointNumber, int jointAngle) {
  armServos.setJointAngle(jointNumber, jointAngle);
  lcd.clear();
  lcd.print("Joint angle:");
  lcd.setCursor(0, LINE_2);
  lcd.print("J");
  lcd.print(jointNumber);
  lcd.print(" move to ");
  lcd.print(jointAngle);
}

// Called when a GRIPPER command is received from MATLAB
void gripperCallback(int gripperDistance) {
  armServos.setGripperDistance(gripperDistance);
  lcd.clear();
  lcd.print("Gripper:");
  lcd.setCursor(0, LINE_2);
  lcd.print("Gripper to ");
  lcd.print(gripperDistance);
}   

void loop() {
  // Check if there is a new message from MATLAB
  if (Serial.available() > 0) {
    robotCom.handleRxByte(Serial.read());
  }
  armServos.updateServos(); // Continues moving the joints
}

