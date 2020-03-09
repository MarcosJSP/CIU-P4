class myCone {
  private float innerRadius, outerRadius;
  private float h;
  private int meridians;
  private float gradeIncrement;
  private PShape cone;
  
  myCone(float h, float innerRadius) {
    this.h = h;
    this.innerRadius = innerRadius;
    this.outerRadius = 0;
    meridians = 24;
    gradeIncrement = 360/meridians;
    generateCone();
  }

  myCone(float h, float innerRadius, float outerRadius) {
    this(h, innerRadius);
    this.outerRadius = outerRadius;
    generateCone();
  }
  
  void generateCone() {
    cone = createShape();
    cone.beginShape(QUAD_STRIP);
    cone.fill(80);
    for (float grade = 0; grade <= 360 + gradeIncrement; grade+=gradeIncrement) {
      float innerX = innerRadius * cos(radians(grade));
      float innerY = innerRadius * sin(radians(grade));
      PVector innerPoint = new PVector(innerX, innerY);

      float outerX = outerRadius * cos(radians(grade));
      float outerY = outerRadius * sin(radians(grade));
      PVector outerPoint = new PVector(outerX, outerY);

      cone.vertex(innerPoint.x, innerPoint.y);
      cone.vertex(outerPoint.x, outerPoint.y, h);
    }
    cone.endShape();
  }

  void draw() {
    shape(cone);
  }
}
