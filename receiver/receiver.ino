//RECEIVER
#include <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"

RF24 radio(9,10);
const uint64_t pipe = 0xE8E8F0F0E1LL;

struct packet 
{
   int rAnalogValue,gAnalogValue,bAnalogValue,tAnalogValue,
       xAnalogValue,yAnalogValue,
       buttonValue[5];
};

packet packetInstance;

void debug()
{
   Serial.print(packetInstance.rAnalogValue);
   Serial.print(", ");
   Serial.print(packetInstance.gAnalogValue);
   Serial.print(", ");
   Serial.print(packetInstance.bAnalogValue);
   Serial.print(", ");
   Serial.print(packetInstance.tAnalogValue);
   Serial.print(", ");
   Serial.print(packetInstance.xAnalogValue);
   Serial.print(", ");
   Serial.print(packetInstance.yAnalogValue);
   Serial.print(", ");
   for(int i = 0; i<5; i++)
   {
      Serial.print(packetInstance.buttonValue[i]);
      Serial.print(", ");
   }
   Serial.println();
}

String convertToString()
{
   String convertedPacket;
   convertedPacket += String(packetInstance.rAnalogValue);
   convertedPacket += ",";
   convertedPacket += String(packetInstance.gAnalogValue);
   convertedPacket += ",";
   convertedPacket += String(packetInstance.bAnalogValue);
   convertedPacket += ",";
   convertedPacket += String(packetInstance.tAnalogValue);
   convertedPacket += ",";
   convertedPacket += String(packetInstance.xAnalogValue);
   convertedPacket += ",";
   convertedPacket += String(packetInstance.yAnalogValue);
   convertedPacket += ",";
   for(int i = 0; i<5; i++)
   {
      convertedPacket += String(packetInstance.buttonValue[i]);
      convertedPacket += ",";
   }
   return convertedPacket;
}

void setup(void)
{
 Serial.begin(9600);
 radio.begin();
 radio.openReadingPipe(1,pipe);
 radio.startListening();
}

void loop(void){
  if (radio.available())
  {
    //Read data from transmitter(Controller).
    radio.read(&packetInstance, sizeof(packet));      
    //Convert struct to string for sending.
    String convertedString = convertToString();
    //Debug string.
    Serial.println(convertedString);
    //Send data to processing application.
  }
}
