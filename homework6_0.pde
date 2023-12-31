import java.util.Iterator;

SnowSystem snow;
float speed = 0.4;

void setup() {
  size(1200,800);
  snow = new SnowSystem(speed);
}

void draw() {
  background(#B4E0EA);
  stroke(240);
  snow.updateSpeed(speed);
  snow.run();
}

void mousePressed() {
  speed += 0.1;
  snow.updateSpeed(speed);
}

class SnowSystem {
  float speed;
  ArrayList<Snowflake> snowflakes;

  SnowSystem(float speed_) {
    speed = speed_;
    snowflakes = new ArrayList<Snowflake>();
  }

  void emit() {
    if (speed >= 1) {
      for (int i = 0; i < speed; i++) {
        generate();
      }
    } else if (speed > 0) {
      if (random(1) < speed) {
        generate();
      }
    }
  }

  void generate() {
    PVector position = new PVector(random(0, width), 0);
    PVector velocity = new PVector(0, random(5, 10));
    float rotation = random(0, 360);
    float aVel = random(-2, 5);
    float radius = random(10, 80);
    float ratio = 0.618;
    Snowflake s = new Snowflake(position, velocity, rotation, aVel, radius, ratio);
    snowflakes.add(s);
  }

  void update() {
    Iterator<Snowflake> ite = snowflakes.iterator();
    while (ite.hasNext()) {
      Snowflake s = ite.next();
      s.update();
      s.show();
      if (s.position.y > (height + s.radius)) {
        ite.remove();
      }
    }
  }

  void run() {
    emit();
    update();
  }
  
  void updateSpeed(float newSpeed) {
    speed = newSpeed;
  }
}

class Snowflake {
  PVector position, velocity;
  float rotation, aVelocity, radius, ratio;
  Branch[] branches = new Branch[6];

  Snowflake(PVector pos, PVector vel, float rot, float aVel, float r, float rat) {
    position = pos;
    velocity = vel;
    rotation = rot;
    aVelocity = aVel;
    radius = r;
    ratio = rat;

    for (int i = 0; i < 6; i++) {
      branches[i] = new Branch(radius, ratio, i * 60);
    }
  }

  void update() {
    position.add(velocity);
    rotation += aVelocity;
  }

  void show() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(radians(rotation));
    for (Branch b : branches) {
      b.generate();
    }
    popMatrix();
  }
}

class Branch {
  float radius, ratio, rotation;

  Branch(float radius_, float ratio_, float rot) {
    radius = radius_;
    ratio = ratio_;
    rotation = rot;
  }

  void generate() {
    pushMatrix();
    rotate(radians(rotation));
    float len = getStartLength(radius, ratio);
    branch(len);
    popMatrix();
  }

  void branch(float len) {
    strokeWeight(len * 0.1);
    strokeCap(ROUND);
    line(0, 0, 0, -len);
    translate(0, -len);

    if (len > 2) {
      pushMatrix();
      branch(len * ratio);
      popMatrix();

      pushMatrix();
      rotate(radians(-60));
      branch(getStartLength(len, ratio));
      popMatrix();
      rotate(radians(60));
      branch(getStartLength(len, ratio));
      pushMatrix();
      popMatrix();
    }
  }

  float getStartLength(float length, float ratio) {
    float len = (1 - ratio) * length;
    return len;
  }
}
