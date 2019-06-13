import processing.serial.*;
import ddf.minim.*;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.Writer;

Minim minim;
AudioPlayer player;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port
String OldVal = "";
String NewVal = "";
int changeNum = 0;
int checkNum = 0;
String butten = "cB";
float centenx;
float centeny;
float bx;
float by;
String path =  "save";
int saveNum;
String saveList[];
int page;
mybox[] list = new mybox[6];

void setup() 
{
  list[0] = new mybox(53,34,40,17,0,17,0,"b",13,25,100);
  list[4] = new mybox(53,34,40,27,0,17,0,"c",100,100,100);
  list[1] = new mybox(53,34,40,27,0,17,0,"cB",225,46,40);
  list[2] = new mybox(53,57,53,0,27,17,0,"d",255,255,255);
  list[3] = new mybox(53,40,34,0,27,0,27,"e",225,225,225);
  list[5] = new mybox(102,40,34,0,0,0,51,"a",160,150,180);


  size(1080, 720, P3D);
    //rect(500,500,400,500);

  File file = new File(path);
  String[] filelist = file.list();
  saveNum = filelist.length+1;
  try{
    for (int i = 0; i < filelist.length; i++) {
      File readfile = new File(path + "\\" + filelist[i]);
      saveList[i] = readfile.getName();
    }
  }catch(Exception e){}

  centenx = width/2;
  centeny = height/2;
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 57600);
  
  minim = new Minim(this);
  player = minim.loadFile("gun.mp3");
}

void draw()
{
  background(255);
  //noFill();
  //noStroke(); 
  translate(centenx, centeny);
  rotateY(map(mouseX, 0, width, -PI, PI));
  rotateX(map(mouseY, 0, height, -PI/2, PI/2));
  rectMode(CENTER); 
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
    //if(butten.equals(val)){
    //  player.play();
    //  player.rewind();
    //}else{
      //if(val == OldVal){
      //  changeNum = 0;
      //}else{
      //  changeNum++;
      //}
      //if(changeNum >= checkNum || OldVal == ""){
        //changeNum = 0;
        OldVal = val;
      //}
    //}
  }
  try{
    String[] info = split(trim(OldVal), ",");
    for(int i=0; i<info.length; i++){
      for(int j=0; j<list.length; j++){
       if(info[i].equals(butten)){
          player.play();
          player.rewind();
        }
        if(info[i].equals(list[j].name)){
          list[j].initbox();   
        }
        
      }
    }
  }catch(Exception e){}
}

void mouseDragged() {
  if(mouseButton == LEFT){
    //centenx = mouseX; 
    //centeny = mouseY; 
  }
}
  
void mousePressed() {
  if(mouseButton == RIGHT) {
    String dirname = "save/"+saveNum+".txt";
    File file = new File(dirname);
    if(file.exists()){
      file.delete(); 
    }
    try {
      file.createNewFile();
      saveNum++;
      Writer writer = new FileWriter(file);
      writer.write(OldVal);
      writer.close();
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
  int X,Y,Z,U,L,SU,SF,R,G,B;
  String name;
  mybox(int x,int y,int z,int up, int left,int selfup,int selfleft,String n,int r,int g,int b){
    X = x;
    Y = y;
    Z = z;
    U = up;
    L = left;
    SU = selfup;
    SF = selfleft;
    name = n;
    R=r;
    G=g;
    B=b;
  }
  void initbox(){
    translate(SF, -SU);
    box(X,Y,Z);
    fill(R,G,B);
    translate(L, -U);
  }
}
