import processing.serial.*;
import java.awt.AWTException;
import java.awt.Robot;

Robot Cursor;
Serial myPort;
String received;

int[] xyCor = {0,0};
int[] change_in_coordinates = {0,0};
int[][] rectCor = {{0,0} , {0,0}};
//                 x1,y1    x2,y2
int rectCtr = 0;

int[] lineCor={0,0,0,0};
int lineCtr = 0;

// potantiometers
int red, green, blue, thickness, xCor, yCor;
int lastX = 1920/2,lastY = 1080/2;
boolean isPressed, saveSwitch;

// buttons
int but1, but2, but3, but4, but5;

void setup() 
{
  myPort = new Serial(this,"COM4",9600);
  try
  {
    Cursor = new Robot();
  }
  catch (AWTException e)
  {
    println("Robot class not supported by your system!");
    exit();
  }
  fullScreen();
  background(255);
}

void draw() 
{
  UI();
  calculateJoystick(xyCor[0],xyCor[1]);
  Cursor.mouseMove(lastX,lastY);
  cursor(CROSS);
   
  if (but1 == 1)
  {
    if(but2 == 1)
    {
      saveSwitch = true;
    }
    else
    {
      noStroke();
      fill(red,green,blue);
      ellipse(lastX, lastY, thickness, thickness);
    }
  }
  
  if(but2 == 0 && saveSwitch)
  {
    UI();
    saveFrame("resim.png");
    saveSwitch = false;
  }
  else if(but3 == 1)
  {
    noStroke();
    fill(255,255,255);
    ellipse(lastX, lastY, thickness, thickness);
  }
  
  if(but2 == 1 && but1 != 1)
  {
    background(255,255,255);
  }
  
  if(but4 == 1)
  {
    noStroke();
    fill(red,green,blue);
    rect(lastX, lastY, thickness, thickness);
  }
  
  if(but5==1)
  {
    isPressed = true;
  }

  if(but5 == 0 && isPressed)
  {
    lineCor[lineCtr] = lastX;
    lineCor[lineCtr+1] = lastY;
    lineCtr+=2;    
    isPressed = false;
  }

  if(lineCtr == 4)
  {
    stroke(red,green,blue);
    line(lineCor[0],lineCor[1],lineCor[2],lineCor[3]);
    lineCtr = 0;
  }
  UI();
}

void serialEvent(Serial myPort)
{
  received = myPort.readStringUntil('\n');
  
  if(received != null)
  {
      received = trim(received);
      
      int[] values = int(splitTokens(received,","));
      
      red = int(values[0] * 0.25); // converts max 1024 to max 256 
      green = int(values[1] * 0.25);
      blue = int(values[2] * 0.25);
      thickness = int(values[3] * 0.25);
      xyCor[0] = values[4];
      xyCor[1] = values[5];
      
      but1 = values[6];
      but2 = values[7];
      but3 = values[8];
      but4 = values[9];
      but5 = values[10];
  }
}

void calculateJoystick(int joystickX, int joystickY)
{
  int temp = 0;
  float xOffset = 0,yOffset = 0;
  float midPoint = 512;
  float sensivity = 0.009;
  float deadZone = 30; //30 pixel.
  if(millis() > 2000) 
  {
    xOffset = joystickX - midPoint;
    yOffset = joystickY - midPoint;
  }
  
  if(abs(xOffset) > deadZone)
  {  
    lastX += (xOffset * sensivity);
  }
  
  if(abs(yOffset) > deadZone)
  {
    temp = lastY;
    temp += (yOffset * sensivity);
    if(temp > 150)
      lastY += (yOffset * sensivity);
  }
}

void UI()
{
  fill(255);
  noStroke();
  rect(0,0,1920,150);
  
  textSize(24);
  textAlign(LEFT);
  fill(0);
  text("Red: " + (int)red + "\nGreen: " + (int)green+ "\nBlue: " + (int)blue  + "\nThickness: " + (int)thickness ,175,35);
  
  strokeWeight(10);
  stroke(0);
  fill(red,green,blue);
  rect(25,25,100,100);
}
