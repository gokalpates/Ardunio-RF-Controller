import processing.serial.*;

Serial myPort;
String buffer,filteredValues;

void setup()
{
  myPort = new Serial(this,"COM4",9600);
}

void draw()
{
  //Get data from ardunio
  if(myPort.available() > 0)
  {
    buffer = myPort.readStringUntil('\n');
    if(buffer != null)
    {
      filteredValues = buffer;
    }
  }
  // Draw
  println(filteredValues);
}
