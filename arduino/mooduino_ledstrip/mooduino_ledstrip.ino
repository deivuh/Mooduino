
#include "FastLED.h"

#define NUM_LEDS 6
#define DATA_PIN 7

CRGB leds[NUM_LEDS];

int hue, saturation, value; //red, green and blue values

void setup() {
  delay(2000);
  
  Serial.begin(9600);     // opens serial port, sets data rate to 9600 bps
  hue = 255;
  saturation = 255;
  value = 255; 
  
   FastLED.addLeds<WS2811, DATA_PIN, GRB>(leds, NUM_LEDS);
}

void loop() {
  
     for(uint16_t i=0; i<NUM_LEDS; i++) {

         leds[i] = CHSV(171, 255, 255);

    } 
    
        
            
  
     FastLED.show(); 
       
  
  if (Serial.available()>=4) {
    
    //Code to identify RGB values reception
   if(Serial.read() == 0xff){
   red = Serial.read();
   green= Serial.read();
   blue = Serial.read();
   
   // Print what was received
    Serial.print("I received: ");
    Serial.print(red, DEC);
    Serial.print(green, DEC);
    Serial.print(blue, DEC); 
 
   for(uint16_t i=0; i<NUM_LEDS; i++) {

         leds[i] = CHSV(hue, saturation, value);
  
    } 
  
     FastLED.show(); 
       
   }
  
  }

}
 
