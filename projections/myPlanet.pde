class myPlanet{
  private float radius;
  private float angle;
  private float angleIncrement;
  private boolean stopRotation;
  private float distFromParent;
  private ArrayList<myPlanet> childs;
  private float cameraXAngle, cameraYAngle;
  private PVector center;
  private String name;
  
  myPlanet(float radius, float angleIncrement, float distFromParent, String name){
    this.radius = radius;
    this.angle = random(360);
    this.angleIncrement = angleIncrement;
    this.stopRotation = false;
    this.distFromParent = distFromParent;
    this.childs = new ArrayList<myPlanet>();
    this.cameraXAngle=0;
    this.cameraYAngle=0;
    this.center = new PVector(0,0,0);
    this.name=name;
  }
  
  void addChild(myPlanet planet){
    childs.add(planet);
  }
  
  float getRadius(){
    return this.radius;
  }
  
  float getAngle(){
    return this.angle;
  }
  
  void updateAngle(){
    if (this.stopRotation)return;
    angle+=angleIncrement;
    if(angle>=360) angle=0;
  }
  
  void stopRotation(boolean status){
    this.stopRotation = status;
  }
  
  void updateTitleRotation(float cameraXAngle, float cameraYAngle){
    this.cameraXAngle = cameraXAngle;
    this.cameraYAngle = cameraYAngle;
    for(myPlanet child: childs){
      child.updateTitleRotation(cameraXAngle,cameraYAngle);
    }
  }
  
  void drawName(){
    textFont(bigFont);
    textAlign(CENTER);
    textSize(18);
    fill(250);
    
    pushMatrix();
    translate(center.x, center.y, center.z);
    //camera Angle
    rotateY(-cameraXAngle);
    rotateX(cameraYAngle);
    text(name,0, -(this.getRadius()+10) );
    popMatrix();
    
    for(myPlanet child: childs){
      child.drawName();
    }
    
    
    noFill();
  }
  
  void drawTrace(){
    for(myPlanet child: childs){
      pushMatrix();
      rotateY(radians(child.getAngle()));
      
      pushMatrix();
      translate(this.getRadius() + child.distFromParent, 0);
      child.drawTrace();
      popMatrix();
      
      rotateX(radians(95));
      circle(0,0,(this.getRadius()+child.distFromParent+child.getRadius()/2)*2);
      
      popMatrix();
    }
  }
  
  void drawChilds(){
    for(myPlanet child: childs){
      pushMatrix();
      rotateY(radians(child.getAngle()));  
      translate(this.getRadius() + child.distFromParent, 0);
      child.draw();
      popMatrix();
    }
  }
  
  void drawPlanet(){
    pushMatrix();
    
    center.x = modelX(0, 0, 0);
    center.y = modelY(0, 0, 0);
    center.z = modelZ(0, 0, 0);
    
    rotateY(radians(this.getAngle()));
    sphere(this.getRadius());
    popMatrix();
  }
  
  void draw(){    
    drawPlanet();
    drawChilds();
    updateAngle();
  }

}
