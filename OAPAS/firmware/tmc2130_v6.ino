/*
 * Open Automatic Polar Alignment v6
 * 
 * Code compatible with UPAS from AVALON
 */

//#define _debug

#include <TMCStepper.h>
#include <AccelStepper.h>
#include <Arduino.h>

#define ARCMINUTE_TO_DEG 1/60
#define DEG_TO_ARCMINUTE 60

#define HOME 0
#define RUN  1
#define WAIT 2

#define GEAR 100 //10  // 210

#define NBMOTORSTEPS     200
#define STALL_VALUE      0 // [-64..63]
#define MICROSTEPS       32 //32

// y-axes
#define y_EN_PIN           7  // Enable
#define y_DIR_PIN          5  // Direction
#define y_STEP_PIN         6  // Step
#define y_CS_PIN           10 // Chip select

// x-axes
#define x_EN_PIN           8  // Enable
#define x_DIR_PIN          4  // Direction
#define x_STEP_PIN         3  // Step
#define x_CS_PIN           2 // Chip select

#define SW_MOSI          11 // Software Master Out Slave In (MOSI)
#define SW_MISO          12 // Software Master In Slave Out (MISO)
#define SW_SCK           13 // Software Slave Clock (SCK)

#define R_SENSE 0.11f // Match to your driver
                      // SilentStepStick series use 0.11
                      // UltiMachine Einsy and Archim2 boards use 0.2
                      // Panucatt BSD2660 uses 0.1
                      // Watterott TMC5160 uses 0.075

// Select your stepper driver type
//TMC2130Stepper driverX(y_CS_PIN, R_SENSE);                           // Hardware SPI

TMC2130Stepper driverX(x_CS_PIN, R_SENSE, SW_MOSI, SW_MISO, SW_SCK); // Software SPI
TMC2130Stepper driverY(y_CS_PIN, R_SENSE, SW_MOSI, SW_MISO, SW_SCK); // Software SPI

#define steps_per_mm  80
AccelStepper stepperX = AccelStepper(stepperX.DRIVER, x_STEP_PIN, x_DIR_PIN);
AccelStepper stepperY = AccelStepper(stepperY.DRIVER, y_STEP_PIN, y_DIR_PIN);

//bool direction;
float x_motor_position = 0;
float y_motor_position = 0;

unsigned char MotorIsMoving = HOME;  // HOME

String lineBuf;


//-------------------------------------------------------------
void setup() 
{
  //-------------------------------------------------------------
  // Open serial port to communicate with the PC
  Serial.begin(115200);
  while(!Serial);
  
  #if (defined(_debug))
    Serial.println("OPEN POLAR ALIGNMENT CONTROLLER V6");
  #endif

  //-------------------------------------------------------------
  // x-axes
  pinMode(x_EN_PIN, OUTPUT);
  pinMode(x_STEP_PIN, OUTPUT);
  pinMode(x_DIR_PIN, OUTPUT);
  pinMode(x_CS_PIN, OUTPUT);

  // y-axes
  pinMode(y_EN_PIN, OUTPUT);
  pinMode(y_STEP_PIN, OUTPUT);
  pinMode(y_DIR_PIN, OUTPUT);
  pinMode(y_CS_PIN, OUTPUT);

  pinMode(MISO, INPUT_PULLUP);
  digitalWrite(x_EN_PIN, LOW);  
  digitalWrite(y_EN_PIN, LOW);
  
  //-------------------------------------------------------------
  SPI.begin();

  //-------------------------------------------------------------
  // TMC2130 setup
  // x-axes
  driverX.begin();
  driverX.toff(4);
  driverX.blank_time(24);
  driverX.rms_current(700); // mA
  driverX.microsteps(MICROSTEPS);
  driverX.en_pwm_mode(true);
  driverX.pwm_autoscale(true);
  driverX.TCOOLTHRS(0xFFFFF); // 20bit max
  driverX.THIGH(0);
  driverX.semin(5);
  driverX.semax(2);
  driverX.sedn(0b01);
  driverX.sgt(STALL_VALUE);

  stepperX.setMaxSpeed(500); // 100mm/s @ 80 steps/mm
  stepperX.setAcceleration(50*steps_per_mm); // 2000mm/s^2
  stepperX.setEnablePin(x_EN_PIN);
  stepperX.setPinsInverted(false, false, true);
  stepperX.enableOutputs(); 

  // y-axes
  driverY.begin();
  driverY.toff(4);
  driverY.blank_time(24);
  driverY.rms_current(700); // mA
  driverY.microsteps(MICROSTEPS);
  driverY.en_pwm_mode(true);
  driverY.pwm_autoscale(true);
  driverY.TCOOLTHRS(0xFFFFF); // 20bit max
  driverY.THIGH(0);
  driverY.semin(5);
  driverY.semax(2);
  driverY.sedn(0b01);
  driverY.sgt(STALL_VALUE);

  stepperY.setMaxSpeed(500); // 100mm/s @ 80 steps/mm
  stepperY.setAcceleration(50*steps_per_mm); // 2000mm/s^2
  stepperY.setEnablePin(y_EN_PIN);
  stepperY.setPinsInverted(false, false, true);
  stepperY.enableOutputs(); 
}

//-------------------------------------------------------------
char retrieve_data(String line, float* ptr_angle,short int* ptr_speed) 
{
  char error = 0;
  signed char index_of_F, index_of_end;

  index_of_F = line.indexOf("F");
  *ptr_angle = line.substring(0,index_of_F).toFloat();
  index_of_end = line.indexOf(0x0D);
  *ptr_speed = line.substring(index_of_F+1,index_of_end).toFloat();

  if ((index_of_F<0)||(index_of_end<0))
  {
    error = 1;
  }

  return error;
}

//-------------------------------------------------------------
void processCommand(String cmd) 
{
  char isRelative, isAbsolute;
  char x_axe, y_axe;

  float angle;
  short int speed;

  float next_motor_position;
  float nb_step_motor_todo;

  isRelative = cmd.indexOf("G91") >= 0;
  isAbsolute = cmd.indexOf("G53") >= 0;
  x_axe = cmd.indexOf('X') >= 0;
  y_axe = cmd.indexOf('Y') >= 0;

  // Absolute mouvement
  if(isAbsolute)
  { 
    retrieve_data(cmd.substring(4),&angle,&speed);
    next_motor_position = NBMOTORSTEPS*MICROSTEPS*angle*ARCMINUTE_TO_DEG/360;
    MotorIsMoving = RUN;

    if(x_axe)
    {  
      x_motor_position = next_motor_position;
      stepperX.setMaxSpeed(speed);
      stepperX.moveTo((long int)round(next_motor_position));

    }
    else // y_axe
    {        
      y_motor_position = next_motor_position;
      stepperY.setMaxSpeed(speed);
      stepperY.moveTo((long int)round(next_motor_position));
    }
  }
  // Relative mouvement
  else if(isRelative)
  {
    retrieve_data(cmd.substring(7),&angle,&speed);
    nb_step_motor_todo = NBMOTORSTEPS*MICROSTEPS*angle*ARCMINUTE_TO_DEG/360; 
    MotorIsMoving = RUN;

    if(x_axe)
    {  
      x_motor_position += nb_step_motor_todo;
      stepperX.setMaxSpeed(speed);
      stepperX.move((long int)round(nb_step_motor_todo));
    }
    else // y_axe
    {        
      y_motor_position += nb_step_motor_todo;
      stepperY.setMaxSpeed(speed);
      stepperY.move((long int)round(nb_step_motor_todo));
    } 
  }
  // Command unknown
  else 
  { 
    #if (defined(_debug))
      Serial.print("Command unknown :");
      Serial.println(cmd);
    #endif
  }  

  Serial.println("ok");  // Send to computer

}

//-------------------------------------------------------------
void sendStatus() 
{
  float x_position, y_position;

  Serial.print("<");
  if(MotorIsMoving == HOME) // Home
  {
    x_position = x_motor_position*360*DEG_TO_ARCMINUTE/(NBMOTORSTEPS*MICROSTEPS);
    y_position = y_motor_position*360*DEG_TO_ARCMINUTE/(NBMOTORSTEPS*MICROSTEPS);
    Serial.print("Home");
  }  
  else if(MotorIsMoving == RUN)  // Run
  {
    x_position = stepperX.currentPosition()*360*DEG_TO_ARCMINUTE/(NBMOTORSTEPS*MICROSTEPS);
    y_position = stepperY.currentPosition()*360*DEG_TO_ARCMINUTE/(NBMOTORSTEPS*MICROSTEPS);
    Serial.print("Run");
  }
  else // Waiting
  {
    x_position = x_motor_position*360*DEG_TO_ARCMINUTE/(NBMOTORSTEPS*MICROSTEPS);    
    y_position = y_motor_position*360*DEG_TO_ARCMINUTE/(NBMOTORSTEPS*MICROSTEPS);
    Serial.print("Idle");
  }

  Serial.print("|MPos:");
  Serial.print(x_position,2);
  Serial.print(",");
  Serial.print(y_position,2);
  Serial.println(",0.00|>");

  Serial.println("ok");

  #if (defined(_debug))
    Serial.print("currentPosition=");
    Serial.println(stepperY.currentPosition());
    Serial.println(y_position);
  #endif
}

//-------------------------------------------------------------
void ScanSerialLine() 
{
  if(Serial.available())
  {
    lineBuf = Serial.readStringUntil('\n');

    if(lineBuf.charAt(0) == '?')
    {
      sendStatus();
    }
    else if(lineBuf.startsWith("$J="))
    {
      processCommand(lineBuf.substring(3));
    }
  } // End if(Serial.available())
}

//-------------------------------------------------------------
void loop() 
{
  ScanSerialLine();

  if((stepperX.distanceToGo() == 0)&&(stepperY.distanceToGo() == 0))
  {
    MotorIsMoving = WAIT;
  }

  stepperX.run();
  stepperY.run(); 
}