#include <LiquidCrystal.h>

LiquidCrystal lcd(7,8,9,10,11,12); // initialize the library with the numbers of the interface pins

const  int  LCD_NB_ROWS  =  2 ;
const  int  LCD_NB_COLUMNS  =  16 ;


byte  DIV_0_OF_5 [ 8 ]  =  {
  B00000 ,
  B00000 ,
  B00000 ,
  B00000 ,
  B00000 ,
  B00000 ,
  B00000 ,
  B00000
};  // 0/5

byte  DIV_1_OF_5 [ 8 ]  =  {
  B10000 ,
  B10000 ,
  B10000 ,
  B10000 ,
  B10000 ,
  B10000 ,
  B10000 ,
  B10000
};  // 1/5

byte  DIV_2_OF_5 [ 8 ]  =  {
  B11000 ,
  B11000 ,
  B11000 ,
  B11000 ,
  B11000 ,
  B11000 ,
  B11000 ,
  B11000
};  // 2/5

byte  DIV_3_OF_5 [ 8 ]  =  {
  B11100 ,
  B11100 ,
  B11100 ,
  B11100 ,
  B11100 ,
  B11100 ,
  B11100 ,
  B11100
};  // 3/5

byte  DIV_4_OF_5 [ 8 ]  =  {
  B11110 ,
  B11110 ,
  B11110 ,
  B11110 ,
  B11110 ,
  B11110 ,
  B11110 ,
  B11110
};  // 4/5

byte  DIV_5_OF_5 [ 8 ]  =  {
  B11111 ,
  B11111 ,
  B11111 ,
  B11111 ,
  B11111 ,
  B11111 ,
  B11111 ,
  B11111
};  // 5/5


void  setup_progressbar ()  {

  // * Saves custom characters to the LCD screen memory * /
  lcd . createChar ( 0 ,  DIV_0_OF_5 );
  lcd . createChar ( 1 ,  DIV_1_OF_5 );
  lcd . createChar ( 2 ,  DIV_2_OF_5 );
  lcd . createChar ( 3 ,  DIV_3_OF_5 );
  lcd . createChar ( 4 ,  DIV_4_OF_5 );
  lcd . createChar ( 5 ,  DIV_5_OF_5 );
}




extern volatile unsigned long timer0_overflow_count;  // Record the most recent timer ticks
volatile boolean ticks_valid;                         // Indicates a valid reading
volatile unsigned long ticks_per_rev;                 // Number of ticks counted in the current revolution
unsigned long msSinceRPMReading;                      // Number of mSec since the last rpm_sense (used to spot zero RPM)
float lastRPM, peakRPM;                               // Most recent RPM reading, and highest RPM recorded since last reset

const float __TICKS_TO_RPMS = 15e6;                   // Convert clock ticks to RPM by dividng ticks into this number
                                                     // The number will change if there are more magnets in an rpm 
                                                     //   (e.g. 2 magnets = 29296.875)
const unsigned int __WAIT_BEFORE_ZERO_RPM = 2000;     // Number of mS to wait for an rpm_sense before assunming RPM = 0.

unsigned long msSinceSend;                            // mSec when the last data was sent to the serial port
const unsigned int __WAIT_BETWEEN_SENDS = 1000;       // Number of mS to wait before sending a batch of data.

int maxRPM=3000;                                      //MAX RPM of your system

void setup()
{

 Serial.begin(9600);                                 // Initialise serial comms.
 msSinceSend = millis();                             // Data sent counter

 attachInterrupt(0, rpm_sense, RISING);              // RPM sense will cause an interrupt on pin2
 msSinceRPMReading = 0;                              // If more than 2000 (i.e. 2 seconds),
                                                     // then RPMs can be assumed to be zero (< 15rpm
                                                     // at most, with a single magnet, no small IC
                                                     // can run that slowly).
 lastRPM = 0;                                        // Current RPM to zero
 peakRPM = 0;                                        // Max recorded RPM to zero

lcd . begin ( LCD_NB_COLUMNS ,  LCD_NB_ROWS );
setup_progressbar ();
// Print a message to the LCD.
lcd.setCursor(0, 0); 
lcd.print("Lathe Tachometer");
lcd.setCursor(0, 1); 
lcd.print("v2.2");
delay(500);
lcd.clear();

}

void rpm_sense()
{
 static unsigned long pre_count;               // Last timer0_overflow_count value
 unsigned long ticks_now;                      //

 ticks_now = timer0_overflow_count;            // Read the timer

 byte t = TCNT0;
 if ((TIFR0 & _BV(TOV0)) && (t<255)) 
   ticks_now++;
 ticks_now = (ticks_now << 8) + t;

 if (pre_count == 0) {                         // First time around the loop?
   pre_count = ticks_now;                      // Yes - set the precount, don't use this number.
 } else {
   ticks_per_rev = ticks_now - pre_count;      // No - calculate the number of ticks...
   pre_count = ticks_now;                      // ...reset the counter...
   ticks_valid = true;                         // ...and flag the change up.
 }
}

void loop()
{
 unsigned long thisMillis = millis();          // Read the time once

 // Calculate RPM
 if (ticks_valid) {                            // Only come here if we have a valid RPM reading
   unsigned long thisTicks;
   
   noInterrupts();
   thisTicks = ticks_per_rev;
   ticks_valid = false;
   interrupts();
   
   lastRPM = __TICKS_TO_RPMS / thisTicks;      // Convert ticks to RPMs
   ticks_valid = false;                        // Reset the flag.
   msSinceRPMReading = thisMillis;             // Set the time we read the RPM.
   if (lastRPM > peakRPM)
     peakRPM = lastRPM;                        // New peak RPM
 } else {
   // No tick this loop - is it more than X seconds since the last one?
   if (thisMillis - msSinceRPMReading > __WAIT_BEFORE_ZERO_RPM) {
     lastRPM = 0;                              // At least 2s since last RPM-sense, so assume zero RPMs
     msSinceRPMReading = thisMillis;           // Reset counter
   }
 }
  
 // Is it time to send the data?
 if (thisMillis < msSinceSend)                  // If thisMillis has recycled, reset it
   msSinceSend = millis();
   
 if (thisMillis - msSinceSend > __WAIT_BETWEEN_SENDS) {
   // Yes: Build the serial output...
   
   // For now, send everything plaintext. Maybe compression would be a good thing, later down the line...
   Serial.print("Tachometer v2.2|");                  // Send ID - ditch this for something smaller
   Serial.print(lastRPM);                       // Current RPMs
   Serial.print("|");                           // Field Separator
   Serial.print(peakRPM);                       // Peak RPMs
   Serial.print("|");                           // Field Separator

   // Debugging
   // Serial.print("|");                           // Field Separator
   // Serial.print(ticks_per_rev);                 // clock ticks in the last rpm

   Serial.println();                            // EOL.

   msSinceSend = millis();                      // Reset the timer 
   
   if (Serial.available()) {
     char cmd = Serial.read();
     if (char('R') == cmd) {
       peakRPM=0;
     }
     Serial.flush();
   }
   
 }
  delay(1000);
  int rpm = lastRPM;
  lcd.clear();
  displayRPM(lastRPM);
  displayBar(rpm);
}

void displayRPM(int rpm) 
{
  lcd.clear();
                                                      // set the cursor to column 0, line 1
  lcd.setCursor(0, 0); 
                                                     // print the number of seconds since reset:
  lcd.print(lastRPM);
  lcd.setCursor(8,0);
  lcd.print("RPM");
}

void displayBar(int rpm)
{

  byte  nb_columns  =  map ( rpm ,  0 ,  maxRPM ,  0 ,  LCD_NB_COLUMNS  *  5 );     //Map the range (0 ~ 100) to the range (0 ~ LCD_NB_COLUMNS * 5)
  lcd.setCursor(0,1);

  for  ( byte  i  =  0 ;  i  <  LCD_NB_COLUMNS ;  ++ i )  {                         //Draw each character for each line

                                                                                    //Depending on the number of columns remaining to be displayed
    if  ( nb_columns  ==  0 )  {                                                    // empty Case
      lcd.write (( byte )  0 );

    }  else  if  ( nb_columns  >=  5 )  {                                           // Full Case
      lcd.write ( 5 );
      nb_columns  -=  5 ;

    }  else  {  // last non-empty box
      lcd.write ( nb_columns );
      nb_columns  =  0 ;
    }
  }
  
} 



