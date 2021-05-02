#include  <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"

int rPotPin = A0;
int gPotPin = A1;
int bPotPin = A2;
int tPotPin = A3;
int joyStickX = A4;
int joyStickY = A5;
int buttonPin[5] = {2,3,4,5,6};

RF24 radio(9,10);
const uint64_t pipe = 0xE8E8F0F0E1LL;

struct packet 
{
   int rAnalogValue,gAnalogValue,bAnalogValue,tAnalogValue,
       xAnalogValue,yAnalogValue,
       buttonValue[5];
};

packet packetInstance;

void setup(void)
{
  Serial.begin(9600);
  pinMode(rPotPin,INPUT);  
  pinMode(gPotPin,INPUT); 
  pinMode(bPotPin,INPUT); 
  pinMode(tPotPin,INPUT); 
  pinMode(joyStickX,INPUT); 
  pinMode(joyStickY,INPUT);
  for(int i = 0; i < 5; i++)
    pinMode(buttonPin[i],INPUT);
    
  radio.begin();
  radio.openWritingPipe(pipe);
}

void loop(void)
{
   packetInstance.rAnalogValue = analogRead(rPotPin);
   packetInstance.gAnalogValue = analogRead(gPotPin);
   packetInstance.bAnalogValue = analogRead(bPotPin);
   packetInstance.tAnalogValue = analogRead(tPotPin);
   packetInstance.xAnalogValue = analogRead(joyStickX);
   packetInstance.yAnalogValue = analogRead(joyStickY);  
   for(int i = 0; i<5;i++)
      packetInstance.buttonValue[i] = digitalRead(buttonPin[i]);

   radio.write(&packetInstance, sizeof(packet));
}
