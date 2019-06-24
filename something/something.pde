import processing.serial.*; // imports library for reading the data from the serial port
Serial myPort; //initializes the serial port object
 
String val = ""; // (angle,distance) pairs received directly from serial port
String angle = ""; //angle received from serial port; type: string 
String distance = ""; //distance received from serial port; type: string
int indx ;
int int_angle; //angle cast into an integer
int int_distance; //distance cast into an integer
float pixsDistance; //distance of the object based on the processing coordinate plane
int n; //number of concentric circles displayed 


void setup(){
  //window setup
  size(1300,700);
  n = 5;
  
  //text settings
  textSize(15);
  
  //Serial communication
 myPort = new Serial(this, "COM7",115200); 
 myPort.clear();
}

void draw(){
   background(0);
   smooth();
   //draws concentric circles
   for (int i = 0; i <= n; i++){
    noFill();
    concentric(width,height,i);
  }
  //writes distances 
   for (int i = n; i > 0; i--){
    write_distance(width,i);
  }
  //animates radar line
    animateLine(int_angle);
    
  //listens to the serial port
    serialEvent(myPort);
    
  //draws object
  obstacle(int_distance,int_angle); 

}

//function to read data from the serial port
void serialEvent (Serial myPort) {
  
  val = myPort.readStringUntil('.');
  if (val != null){
  val = val.substring(0,val.length()-1); //<>//
  indx = val.indexOf(",");
  angle = val.substring(0, indx);
  distance= val.substring(indx+1, val.length());
  int_angle = int(angle);
  int_distance = int(distance);
  }
}

//writes the distances on the interface
void write_distance(int width,int i){
  int y_interval = height/n;
  int text_dist = y_interval * (n-i)+20;
  fill(0,255,0);
  text(40*(i)+"cm",(width-30)/2,text_dist);
}

//draws the concentric circles
void concentric(int width,int height,int i){
  float y_interval = width/n;
  float radius = y_interval * i;
  stroke(0,255,0);
  noFill();
  ellipse(width/2,height,radius,radius);
};

//draws the radar line
void animateLine(int input){
  float teta = map(input,15,180,radians(360),radians(180));
  pushMatrix();
  translate(width/2,height);
  line(0,0,width*cos(teta),((width)*sin(teta)));
  popMatrix();
}

//draws a colored sphere when there is an object detected
void obstacle(int dist,int angle){
  pushMatrix();
  translate(width/2,height-height*0.074);
  pixsDistance = dist*((height-height*0.1666)*0.025);
  float x = pixsDistance*cos(radians(angle));
  float y = -pixsDistance*sin(radians(angle));
   if (dist < 40 && dist > 0){
     smooth();
     ellipse(x,y,100,100);
   }
   popMatrix();
}
