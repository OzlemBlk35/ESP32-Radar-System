
import processing.serial.*;

Serial myPort;
int centerX, centerY;
int maxDistance = 100;
int screenWidth = 800, screenHeight = 600;
float angleOffset = 0;
boolean objectDetected = false;
color backgroundColor = color(0, 10, 30);
color gridColor = color(0, 100, 130, 80);
color scanLineColor = color(0, 255, 0, 180);
color objectColor = color(255, 0, 0);
color textColor = color(0, 255, 170);

float sweepAngle = 0;
ArrayList<RadarPoint> radarPoints = new ArrayList<RadarPoint>();

void settings() {
  size(screenWidth, screenHeight);
}

void setup() {
  centerX = width / 2;
  centerY = height;

  try {
    String portName = Serial.list()[0];
    myPort = new Serial(this, portName, 9600);
    println("Bağlanan port: " + portName);
  } catch (Exception e) {
    println("Seri port bağlantısı yapılamadı! Simülasyon modunda çalışılıyor.");
    println(e);
  }

  smooth();
}

void draw() {
  background(backgroundColor);
  
  drawRadarGrid();
  
  if (myPort != null && myPort.available() > 0) {
    String inData = myPort.readStringUntil('\n');
    if (inData != null) {
      inData = trim(inData);
      String[] data = split(inData, ",");
      if (data.length >= 2) {
        try {
          int distance = Integer.parseInt(data[0]);
          int angle = Integer.parseInt(data[1]);
          addRadarPoint(distance, angle);
        } catch (NumberFormatException e) {
          println("Veri dönüştürülemedi: " + inData);
        }
      }
    }
  } else {
    if (frameCount % 5 == 0) {
      float randomDistance = random(10, maxDistance);
      if (abs(sweepAngle - 25) < 10 && random(1) > 0.7) {
        randomDistance = random(5, 15);
      }
      addRadarPoint(randomDistance, (int)sweepAngle);
    }
  }
  
  drawSweepLine();
  drawRadarPoints();
  displayDetectionStatus();
  drawInfoPanel();
}

void drawRadarGrid() {
  noFill();
  
  for (int r = 50; r <= 200; r += 50) {
    stroke(gridColor);
    arc(centerX, centerY, r*2, r*2, PI, TWO_PI);
    fill(textColor);
    textSize(12);
    textAlign(RIGHT, CENTER);
    int distance = (r/200) * maxDistance;
    text(distance + " cm", centerX - r - 5, centerY - r/2);
  }
  
  for (int angle = 0; angle <= 180; angle += 30) {
    float rad = radians(angle);
    stroke(gridColor);
    line(centerX, centerY, 
         centerX + cos(PI + rad) * 200, 
         centerY + sin(PI + rad) * 200);
    
    if (angle > 0 && angle < 180) {
      fill(textColor);
      textSize(12);
      textAlign(CENTER, CENTER);
      float labelX = centerX + cos(PI + rad) * 220;
      float labelY = centerY + sin(PI + rad) * 220;
      text(angle + "°", labelX, labelY);
    }
  }
  
  stroke(gridColor, 150);
  line(centerX - 200, centerY, centerX + 200, centerY);
}

void drawSweepLine() {
  stroke(scanLineColor);
  strokeWeight(2);
  float rad = radians(sweepAngle);
  line(centerX, centerY, 
       centerX + cos(PI + rad) * 200, 
       centerY + sin(PI + rad) * 200);
  
  noStroke();
  fill(scanLineColor, 40);
  arc(centerX, centerY, 400, 400, PI, PI + rad);
  
  sweepAngle = (sweepAngle + 1) % 180;
  strokeWeight(1);
}

void addRadarPoint(float distance, int angle) {
  RadarPoint newPoint = new RadarPoint(distance, angle);
  radarPoints.add(newPoint);
  
  if (distance < 20) {
    objectDetected = true;
  } else {
    objectDetected = false;
  }
  
  if (radarPoints.size() > 100) {
    radarPoints.remove(0);
  }
}

void drawRadarPoints() {
  for (int i = 0; i < radarPoints.size(); i++) {
    RadarPoint point = radarPoints.get(i);
    point.display();
    point.update();
    
    if (point.alpha <= 0) {
      radarPoints.remove(i);
      i--;
    }
  }
}

void displayDetectionStatus() {
  textAlign(CENTER, CENTER);
  textSize(20);
  
  if (objectDetected) {
    fill(255, 0, 0, 100 + 100 * sin(frameCount * 0.1));
    ellipse(centerX, 50, 300, 70);
    
    fill(255);
    text("NESNE ALGILANDI!", centerX, 50);
    
    textSize(16);
    fill(255, 200, 200);
    text("DİKKAT! Yakında nesne tespit edildi.", centerX, 80);
  } else {
    fill(0, 150, 0, 70);
    ellipse(centerX, 50, 300, 70);
    
    fill(textColor);
    text("Nesne Algılanmadı", centerX, 50);
  }
}

void drawInfoPanel() {
  fill(0, 30, 60, 200);
  noStroke();
  rect(width - 200, height - 100, 190, 90, 10);
  
  fill(textColor);
  textAlign(LEFT, CENTER);
  textSize(14);
  text("Radar Durumu: AKTİF", width - 190, height - 80);
  text("Tarama Alanı: 180°", width - 190, height - 60);
  text("Menzil: " + maxDistance + " cm", width - 190, height - 40);
  text("Açı: " + nf(sweepAngle, 0, 1) + "°", width - 190, height - 20);
}

class RadarPoint {
  float distance;
  int angle;
  float alpha = 255;
  
  RadarPoint(float d, int a) {
    distance = d;
    angle = a;
  }
  
  void update() {
    alpha -= 2;
  }
  
  void display() {
    float rad = radians(angle);
    float displayDistance = map(distance, 0, maxDistance, 0, 200);
    
    float x = centerX + displayDistance * cos(PI + rad);
    float y = centerY + displayDistance * sin(PI + rad);
    
    color pointColor;
    if (distance < 20) {
      pointColor = color(255, 0, 0);
    } else if (distance < 50) {
      pointColor = color(255, 255, 0);
    } else {
      pointColor = color(0, 255, 0);
    }
    
    noStroke();
    fill(red(pointColor), green(pointColor), blue(pointColor), alpha);
    ellipse(x, y, 10, 10);
    
    fill(red(pointColor), green(pointColor), blue(pointColor), alpha * 0.5);
    ellipse(x, y, 20, 20);
  }
}
