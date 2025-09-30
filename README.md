# ESP32 Radar Project

This project is a **radar system** developed using an **ESP32**, **servo motor**, and **HC-SR04 ultrasonic distance sensor**.  
The ESP32, programmed in Arduino IDE, moves the ultrasonic sensor across specific angles using the servo motor and measures distances.  
The measured data is then sent via the serial port to **Processing IDE**, where it is visualized as a radar-like interface.  

## 🚀 Features
- Distance measurement in the 0° – 180° range using an ultrasonic sensor  
- Scanning motion with a servo motor  
- Programming with Arduino IDE on ESP32  
- Real-time radar visualization with Processing IDE  
- Detected objects displayed with radar-style green effects  

## 🛠 Hardware Used
- ESP32 Development Board  
- SG90 Servo Motor  
- HC-SR04 Ultrasonic Sensor  
- Jumper wires  
- Breadboard  

## 💻 Software Used
- Arduino IDE (for programming ESP32)  
- Processing IDE (for radar visualization)  

## ⚙️ Setup
1. Install the ESP32 board package in Arduino IDE.  
2. Upload the `.ino` file from the `Arduino/` folder to the ESP32.  
3. Open Processing IDE and run the `.pde` file from the `Processing/` folder.  
4. Update the **COM port** in the Processing code according to your device.  
5. Once the ESP32 is running, you can see the radar visualization on the Processing screen. 


## 🔎 Working Principle
- The servo motor rotates step by step to specific angles.  
- At each angle, the ultrasonic sensor measures the distance.  
- The ESP32 sends the angle and distance data via the serial port to Processing.  
- Processing draws the objects on the radar screen based on the received data.  

## 📸 Screenshots
 <img width="430" height="523" alt="image" src="https://github.com/user-attachments/assets/3f6378af-5d6c-40ba-9a4d-77d0a2a438fa" />
  <img width="530" height="600" alt="Ekran Görüntüsü (446)" src="https://github.com/user-attachments/assets/77fa5537-acc4-4be2-bffe-dd7dfb3e1d3f" />



---

👩‍💻 Developed by **Özlem Balıkçı**
