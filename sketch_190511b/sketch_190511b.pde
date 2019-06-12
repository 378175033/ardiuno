import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port
String OldVal = "";
String NewVal = "";
int changeNum = 0;
int checkNum = 2;
String butten = "3\r\n";
float centenx;
float centeny;
float bx;
float by;
mybox[] list = new mybox[3];

void setup() 
{
  list[0] = new mybox(53,34,40,17,0,17,0,"test1");
  list[1] = new mybox(53,40,34,0,20,0,20,"test2");
  list[2] = new mybox(53,53,53,0,53,27,0,"test3");
  size(1080, 720, P3D);
  centenx = width/2;
  centeny = height/2;
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 4800);
  
  minim = new Minim(this);
  player = minim.loadFile("gun.mp3");
}

void draw()
{
  background(255);
  noFill();
  translate(centenx, centeny);
  rotateY(map(mouseX, 0, width, -PI, PI));
  rotateX(map(mouseY, 0, height, -PI/2, PI/2));
  rectMode(CENTER); 
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
    if(butten.equals(val)){
      player.play();
      player.rewind();
    }else{
      if(changeNum >= checkNum || OldVal == ""){
        changeNum = 0;
        OldVal = val;
      }
      if(val == OldVal){
        changeNum = 0;
      }else if(val == NewVal){
        changeNum++;
      }else{
        changeNum = 0;
      }
        NewVal = val;
    }
  }
  try{
    String[] info = split(trim(OldVal), ",");
    for(int i=0; i<info.length; i++){
      for(int j=0; j<list.length; j++){
        if(info[i].equals(list[j].name)){
          list[j].initbox();
        }
      }
    }
  }catch(Exception e){}
}

void mouseDragged() {
  if(mouseButton == LEFT){
    centenx = mouseX; 
    centeny = mouseY; 
  }
}
  
void mousePressed() {
  if(mouseButton == RIGHT) {
    String dirname = "/save.txt";
    File f1 = new File(dirname);
    if(f1.exists()){
      f1.delete(); 
    }
    try {
      f1.createNewFile();
    }catch(IOException e) {
      e.printStackTrace();
    }
  }

}

/**
* U:the next box up offset on axis x
* L:the next box left offset on axis y
* SU:the self box up offset on axis x
* SL:the self box left offset on axis y
*/
class mybox{
  int X,Y,Z,U,L,SU,SF;
  String name;
  mybox(int x,int y,int z,int up, int left,int selfup,int selfleft,String n){
    X = x;
    Y = y;
    Z = z;
    U = up;
    L = left;
    SU = selfup;
    SF = selfleft;
    name = n;
  }
  void initbox(){
    translate(SF, -SU); //<>//
    box(X,Y,Z);
    translate(L, -U);
  }
}
