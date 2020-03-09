class myCamera{
  private PVector cameraPosition;
  private PVector targetPosition;
  private boolean enableFly, enableMovement;
  private float distFromCameraToTarget;
  private float speed;
  private float xRotation, yRotation;
  private float fov;
  
  myCamera(PVector InitialPosition) {
    cameraPosition = InitialPosition.copy();
    targetPosition = InitialPosition.copy();
    enableFly = true;
    enableMovement = false;
    distFromCameraToTarget = -100;
    speed = 3;
    xRotation = 0;
    yRotation = 0;
    fov = radians(60);
  }
  
  myCamera(PVector InitialPosition, float xRotation, float yRotation){
    this(InitialPosition);
    this.xRotation = xRotation;
    this.yRotation = yRotation;
  }
  
  //GETTER
  
  float getXRotation(){
    return this.xRotation;
  }
  
  float getYRotation(){
    return this.yRotation;
  }
  
  //SETTER
  
  void enableFly(boolean status){
    this.enableFly= status;
  }
  
  void enableMovement(boolean status){
    this.enableMovement= status;
  }
  
  //TRANSFORMATIONS
  
  void beginOnCameraView(){
    pushMatrix();
    translate(cameraPosition.x, cameraPosition.y, cameraPosition.z);
    rotateY(-radians(xRotation));
    rotateX(radians(yRotation));
  }
  
  void endOnCameraView(){
    popMatrix();
  }
  
  //CAMERA POSITION UPDATING
  
  void updateRotation(float dx, float dy){
    if(!enableMovement) return;
    xRotation += dx * .2;
    yRotation += dy * .2;
    
    if(xRotation < 0) xRotation = 360;
    if (xRotation > 360) xRotation = 0;
    
    if(yRotation < 0) yRotation = 360;
    if (yRotation > 360) yRotation = 0;
  }
  
  private void updateTargetPosition(){
    beginOnCameraView();
    translate(0, 0, distFromCameraToTarget);
    
    targetPosition.x = modelX(0, 0, 0);
    targetPosition.y = modelY(0, 0, 0);
    targetPosition.z = modelZ(0, 0, 0);
    endOnCameraView();
  }
  
  void updateCameraPosition(boolean w,boolean s,boolean a,boolean d, boolean space, boolean crtl){    
    if(!enableMovement) return;
    targetPosition.y = cameraPosition.y;
    
    if (enableFly) {
      if(space){
        cameraPosition.y-=speed;
      }
      
      if(crtl){
        cameraPosition.y+=speed;
      }
    }
    
    
    if(w){
      PVector directionVector = PVector.sub(targetPosition, cameraPosition);
      directionVector.mult(-(speed * 1/distFromCameraToTarget));
      cameraPosition.add(directionVector);
    }
    
    if(s){
      PVector directionVector = PVector.sub(targetPosition, cameraPosition);
      directionVector.mult(speed * 1/distFromCameraToTarget);
      cameraPosition.add(directionVector);
    }
    
    if(a){
      beginOnCameraView();
      translate(-speed, 0, 0);
      cameraPosition.x = modelX(0, 0, 0);
      cameraPosition.y = cameraPosition.y;//modelY(0, 0, 0);
      cameraPosition.z = modelZ(0, 0, 0);
      endOnCameraView();
    }
    
    if(d){
      beginOnCameraView();
      translate(speed, 0, 0);
      cameraPosition.x = modelX(0, 0, 0);
      cameraPosition.y = cameraPosition.y;//modelY(0, 0, 0);
      cameraPosition.z = modelZ(0, 0, 0);
      endOnCameraView();
    }
    
  }
  
  //CAMERA DRAWING
  
  void setupCamera(){
    updateTargetPosition();
    
    camera(cameraPosition.x, cameraPosition.y, cameraPosition.z, 
           targetPosition.x, targetPosition.y, targetPosition.z, 
           0, 1, 0);
    
    
    perspective(fov, float(width)/float(height), 
                0.0001, 10000);
                
    //println("x: " + cameraPosition.x + " y: " + cameraPosition.y + " z: " + cameraPosition.z + " rx: " + xRotation + " ry " + yRotation);
                
  }

}
