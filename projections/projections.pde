myPlanet star, p1, p1Moon, p2,p3,p4,p5;
PImage NKey, HKey, TKey, SpaceCtrlKeys, ASDWKeys, num123Keys, mouseDragged;
boolean [] pressedKey;
boolean stopRotation, paintTraces, paintNames, paintShortCuts;
PFont smallFont, mediumFont, bigFont;
boolean [] movementKeys;
myCamera [] cameras;
int selectedCamera;
myCone cone;

void setup(){
  size(1000,700, P3D);
  stroke(200);
  
  //Planets config
  star = new myPlanet(70,.2,0, "Star");
  p3 = new myPlanet(5,.45 * 1/4, 300, "Planet 1");
  p2 = new myPlanet(10,.40 * 1/4, 250, "Planet 2");
  p5 = new myPlanet(15,.35 * 1/4, 150, "Planet 3");
  p4 = new myPlanet(17,.3 * 1/4, 200, "Planet 4");
  p1 = new myPlanet(20,.25 * 1/4, 400, "Planet 5");
  p1Moon = new myPlanet(2,1, 30, "Moon");
  
  star.addChild(p1);
  star.addChild(p2);
  star.addChild(p3);
  star.addChild(p4);
  star.addChild(p5);
  p1.addChild(p1Moon);
  
  
  //Keys config  
  HKey = loadImage("./resources/input/H.png");
  NKey = loadImage("./resources/input/N.png");
  TKey = loadImage("./resources/input/T.png");
  ASDWKeys = loadImage("./resources/input/AWSD.png");
  SpaceCtrlKeys = loadImage("./resources/input/Space-Ctrl.png");
  num123Keys = loadImage("./resources/input/123.png");
  mouseDragged = loadImage("./resources/input/MouseDragged.png");
  
  pressedKey = new boolean []{false,false,false,false};
  stopRotation = false; paintTraces = true; paintNames = false;
  movementKeys = new boolean[]{false,false,false,false,false,false,false};
  
  
  //Fonts config
  smallFont = createFont("Arial", 10);
  mediumFont = createFont("Arial", 18);
  bigFont = createFont("Arial bold", 50);
  
  
  //Camera config
  myCamera firstPersonCamera = new myCamera(new PVector(0,0,900));
  firstPersonCamera.enableMovement(true);
  myCamera frontCamera = new myCamera(new PVector(632,-334,1200), 322, 16);
  myCamera upCamera = new myCamera(new PVector(-30,-1018,0), 82, 86);
  cameras = new myCamera[] {firstPersonCamera, frontCamera, upCamera};
  selectedCamera = 1;
  
  //Cone for the camera model
  cone = new myCone(30,5,17);
}

void draw (){
  background(80);background(80);
  if(paintShortCuts){
    camera();
    paintShortCuts();
  }else{
    noFill();
    cameras[selectedCamera].setupCamera();
    star.draw();
    if(paintNames) star.drawName();
    if(paintTraces) star.drawTrace();
    drawCameraModel();
    paintShortCutsText();
    
    cameras[selectedCamera].updateCameraPosition(movementKeys[0],movementKeys[1],movementKeys[2],movementKeys[3],movementKeys[4],movementKeys[5]);
    float cameraXAngle = radians(cameras[selectedCamera].getXRotation());
    float cameraYAngle = radians(cameras[selectedCamera].getYRotation());
    star.updateTitleRotation(cameraXAngle,cameraYAngle);
  }
}

void drawCameraModel(){
  cameras[0].beginOnCameraView();
  rotateY(radians(180));
  translate(0,0,-7);
  cone.draw();
  box(30);
  cameras[0].endOnCameraView();
}

void paintShortCutsText(){
  float keySize = 112 / 3;
  float minXSpace = 20;
  float TextSize = 18;
  
  cameras[selectedCamera].beginOnCameraView();
  translate(-4,-2.8,-5);
  scale(0.009);
  textFont(mediumFont);
  textAlign(LEFT);
  textSize(18);
  image(HKey, 30, 30, keySize, keySize);
  text("Short-cuts", 30+keySize+minXSpace, 30+TextSize+TextSize/3);
  cameras[selectedCamera].endOnCameraView();
}

void paintShortCuts(){
  float keySize = 112 / 3;
  float BigKeyWidth = 416 / 3;
  float minXSpace = 50;
  float textSize = 18;
  float Yoffset = height/6;
  
  textFont(bigFont);
  textAlign(CENTER);
  textSize(50);
  text("Short-Cuts", width/2, Yoffset);
  Yoffset += 80;
  
  pushMatrix();
  translate(-(minXSpace+keySize), 0);
  translate(-170,0);
  
  textFont(mediumFont);
  textAlign(LEFT);
  textSize(18);
  image(NKey, width/2-(minXSpace+keySize), Yoffset-(textSize+textSize/2), keySize, keySize);
  text("Show/Hide planet name", width/2, Yoffset);
  Yoffset += 60;
  
  image(TKey, width/2-(minXSpace+keySize), Yoffset-(textSize+textSize/2), keySize, keySize);
  text("Show/Hide planet traces", width/2, Yoffset);
  Yoffset += 60;
  
  image(num123Keys, width/2-(minXSpace+BigKeyWidth), Yoffset-(textSize+textSize/2), BigKeyWidth, keySize);
  text("Change camera view  [1]: First person view - [2]: Front camera - [3]: Up camera", width/2, Yoffset);
  Yoffset += 80;
  
  image(ASDWKeys, width/2-(minXSpace+BigKeyWidth), Yoffset-(textSize*2+textSize/2), BigKeyWidth, 257/3);
  text("Move camera position fordward,backwards,left or right when on first person camera view", width/2, Yoffset);
  Yoffset += 80;
  
  image(SpaceCtrlKeys, width/2-(minXSpace+BigKeyWidth), Yoffset-(textSize+textSize/2), BigKeyWidth, keySize);
  text("Move camera position up/down when on first person camera  view", width/2, Yoffset);
  Yoffset += 60;
  
  image(mouseDragged, width/2-(minXSpace+65), Yoffset-(textSize+textSize/2), 65, 222/3);
  text("Move camera target when on first person camera  view", width/2, Yoffset+25); 
  
  popMatrix();
    
  textSize(14);
  textAlign(CENTER);
  text("Press any key to get out of the Short-Cuts menu", width/2, height - height/10);
}

void keyReleased(){
  if (!paintShortCuts) {
    //CAMERA MOVEMENT
    if(key == 'w' || key == 'W') movementKeys[0] = false;
    if(key == 's' || key == 'S') movementKeys[1] = false;
    
    if(key == 'a' || key == 'A') movementKeys[2] = false;
    if(key == 'd' || key == 'D') movementKeys[3] = false;
    
    if(keyCode == 32) movementKeys[4] = false;  //SPACE
    if(keyCode == 17) movementKeys[5] = false;  //CRTL
  }
}

void keyPressed(){
  if (!paintShortCuts) {
    if (key == 't' || key == 'T') paintTraces = !paintTraces;
    if (key == 'n' || key == 'N') paintNames = !paintNames;
    if (key == 'h' || key == 'H') paintShortCuts = !paintShortCuts;
    
    //CAMERA MOVEMENT
    if(key == 'w' || key == 'W') movementKeys[0] = true;
    if(key == 's' || key == 'S') movementKeys[1] = true;
    
    if(key == 'a' || key == 'A') movementKeys[2] = true;
    if(key == 'd' || key == 'D') movementKeys[3] = true;
    
    if(keyCode == 32) movementKeys[4] = true;  //SPACE
    if(keyCode == 17) movementKeys[5] = true;  //CRTL
    
    if(keyCode == 16) {
      movementKeys[6]=!movementKeys[6];
      //cameras[selectedCamera].enableFly(movementKeys[6]);  //SHIFT
    }
    
    //SELECTING CAMERA    
    if(keyCode == 49) selectedCamera = 0; // NUM 0
    if(keyCode == 50) selectedCamera = 1; // NUM 1
    if(keyCode == 51) selectedCamera = 2; // NUM 2
    
  }else{
    paintShortCuts = !paintShortCuts;
  }
}

void mouseDragged(){
  float dx = mouseX - pmouseX;
  float dy = mouseY - pmouseY;
  cameras[selectedCamera].updateRotation(dx, dy);
}
