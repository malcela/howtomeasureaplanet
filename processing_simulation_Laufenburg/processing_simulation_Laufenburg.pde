/*

Simulation for a drawing machine
"How to measure a Planet"
Marcela Antipan Olate
8.12.2021
*/


import java.util.Calendar; // this is used to save the PNG file with a current time name

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing box2d;

ArrayList<PVector> points;

DrawingMachine machine;

JSONObject temperatureLaufenburgFile;
JSONObject humidityLaufenburgFile;
JSONObject altitudLaufenburgFile;

float[] listTemperatureLaufenburg;
float[] listHumidityLaufenburg;
float[] listAltitudLaufenburg;



float[] pressionLaufenburg;

int timer;
int timeToChangeToNext;

int currentTempIndex;

void setup() {
  size(800, 800);
  smooth();

  timeToChangeToNext = 0;
  timer = 0;

  currentTempIndex = 0;

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld(new Vec2(0.0f, 0.0f));


  machine = new DrawingMachine();


  points = new ArrayList<PVector>();

  temperatureLaufenburgFile = loadJSONObject("temperature_laufenburg.json");
  humidityLaufenburgFile = loadJSONObject("humidity_laufenburg.json");
  altitudLaufenburgFile = loadJSONObject("altitud_laufenburg.json");


  JSONArray temperatureLaufenburg = temperatureLaufenburgFile.getJSONArray("temperature");
  JSONArray pression = temperatureLaufenburgFile.getJSONArray("pression");
  JSONArray humidityLaufenburg = humidityLaufenburgFile.getJSONArray("humidity");
  JSONArray altitudLaufenburg = altitudLaufenburgFile.getJSONArray("altitud");

  int size = temperatureLaufenburg.size();
  listTemperatureLaufenburg = new float[size];
  // Use a for() loop to quickly iterate
  // through all values in an array.
  for (int i=0; i < temperatureLaufenburg.size(); i++) {
    listTemperatureLaufenburg[i] = temperatureLaufenburg.getFloat(i);// = cos(TWO_PI/degrees * i);
    //println(listTemperaturasLaufenburg[i]);
  }


  int size2 = humidityLaufenburg.size();
  listHumidityLaufenburg = new float[size2];
  // Use a for() loop to quickly iterate
  // through all values in an array.
  for (int i=0; i < humidityLaufenburg.size(); i++) {
    listHumidityLaufenburg[i] = humidityLaufenburg.getFloat(i);// = cos(TWO_PI/degrees * i);
    //println(listTemperaturasWallerfeld[i]);
  }

  int size3 = altitudLaufenburg.size();
  listAltitudLaufenburg = new float[size3];
  // Use a for() loop to quickly iterate
  // through all values in an array.
  for (int i=0; i < altitudLaufenburg.size(); i++) {
    listAltitudLaufenburg[i] = altitudLaufenburg.getFloat(i);// = cos(TWO_PI/degrees * i);
    // println(listTemperatureVitrinepark[i]);
  }


  int size4 = pression.size();
  pressionLaufenburg = new float[size4];
  // Use a for() loop to quickly iterate
  // through all values in an array.
  for (int i=0; i < pression.size(); i++) {
    pressionLaufenburg[i] = pression.getFloat(i);// = cos(TWO_PI/degrees * i);
    println(pressionLaufenburg[i]);
  }


  // multiplicador de forca dos bracos. mas grande mas grande dibujos.
  machine.setForceMultiplier(500);
}

void draw() {
  background(255);


  // We must always step through time!
  box2d.step();

  machine.update();
  machine.display();

  //array que salva los puntos de dibujo.
  points.add(new PVector (machine.pen.pos.x, machine.pen.pos.y));

  for (int i = 0; i < points.size(); i++) {
    point(points.get(i).x, points.get(i).y);
  }


  // adding the data into this forces over time.
  int passedTime = millis() - timer;
  if (passedTime > timeToChangeToNext) {
    timeToChangeToNext = 1500; // change every 5s, next temp in line
    timer = millis();

    currentTempIndex++;

    //la fuerza de cada uno de los 3 brazos. 3 datos distintos
    float t1 = listTemperatureLaufenburg[currentTempIndex % listTemperatureLaufenburg.length]; // temperatura laufenburg
    float t2 = listHumidityLaufenburg[currentTempIndex % listHumidityLaufenburg.length]; // temperatura wallerfeld
    float t3 = listAltitudLaufenburg[currentTempIndex % listAltitudLaufenburg.length]; // temperatura vitrinepark

    float pressionActual = pressionLaufenburg[currentTempIndex % pressionLaufenburg.length];

    // normalize
    float f1 = map(t1, min(listTemperatureLaufenburg), max(listTemperatureLaufenburg), 0, 1);
    float f2 = map(t2, min(listHumidityLaufenburg), max(listHumidityLaufenburg), 0, 1);
    float f3 = map(t3, min(listAltitudLaufenburg), max(listAltitudLaufenburg), 0, 1);

    float p1 = map(pressionActual, min(pressionLaufenburg), max(pressionLaufenburg), 0, 1);
    println("change");


    println(pressionActual);
    println(p1);
    //println(f2);
    //println(f3);

    // forces: first is top left, second is top right, third is bottom.
    machine.updateForces(f1, f3, f2);
  }
  
   // saveFrame("output2/simulationBremen-####.png");

}


void keyReleased() {
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
}


// timestamp: these lines of code save the PNG file with the time and hour
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
