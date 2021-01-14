import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CosSinCircle extends PApplet {

int numOfPoints = 64;
float radius = 32f;
final float maxRadius = 128f;
float lineRadius = 32f;
final float maxLineRadius = 64f;
PVector cosStartPos;
PVector sinStartPos;
PVector circleStartPos;
int frame = 0;

public void settings()
{
    size(640, 360);
}

public void setup()
{
    frameRate(60);

    cosStartPos = new PVector(maxLineRadius + 8f, 0f);
    sinStartPos = new PVector(0f, maxLineRadius + 8f);
    circleStartPos = new PVector(width * 0.5f, height * 0.5f);
}
    
public void draw()
{
    frame++;
    if (frame >= 360)
        frame = 0;

    radius = maxRadius * cos(radians(frame));
    lineRadius = maxLineRadius * cos(radians(frame));

    background(0);
    DrawCosLine(100);
    DrawSinLine(100);
    DrawCircle(numOfPoints);
}

public void DrawCosLine(int points)
{
    float radius = lineRadius;
    float deltaLength = (float)height / points;
    int pCount = 0;
    int cCount = 0;

    strokeWeight (4f);

    for (int i = 0; i < points; i++)
    {
        float dX = frame + pCount;
        PVector cPoint = new PVector(cos(radians(dX)) * lineRadius, deltaLength * i);
        PVector dPoint = cosStartPos.copy().add(cPoint);

        int c = (int)abs((sin(radians(frame + cCount)) * 255));
        stroke (0, 0, c);
        point(dPoint.x, dPoint.y);

        pCount += deltaLength;
        cCount += 10;
    }
}

public void DrawSinLine(int points)
{
    float radius = lineRadius;
    float deltaLength = (float)width / points;
    int pCount = 0;
    int cCount = 0;

    strokeWeight (4f);

    for (int i = 0; i < points; i++)
    {
        float dY = frame + pCount;
        PVector sPoint = new PVector(deltaLength * i, sin(radians(dY)) * radius);
        PVector dPoint = sinStartPos.copy().add(sPoint);

        int c = (int)abs((sin(radians(frame + cCount)) * 255));
        stroke (c, 0, 0);
        point(dPoint.x, dPoint.y);

        pCount += deltaLength;
        cCount += 10;
    }
}

public void DrawCircle(int points)
{
    float deltaAngle = 360f / points;
    int cCount = 0;

    strokeWeight (4f);

    for (int i = 0; i < points; i++)
    {
        PVector cPoint = GetCirclePoint(deltaAngle * i + frame);
        cPoint.mult(radius);
        PVector dPoint = circleStartPos.copy().add(cPoint);

        int r = (int)(cos(radians(deltaAngle * i + frame + cCount)) * 192);
        int g = (int)(sin(radians(deltaAngle * i + frame + cCount)) * 192);
        int b = (int)(sin(radians(deltaAngle * i + frame + cCount)) * 64);
        stroke (r+63, g+63, b+191);
        point(dPoint.x, dPoint.y);

        // Print2DPoint(dPoint, i);
        cCount += 10;
    }
}

public PVector GetCirclePoint(float angle)
{
    return new PVector(cos(radians(angle)), sin(radians(angle)));
}

public void Print2DPoint(PVector point, int index)
{
    println("point[" + index + "]: [ x: " + point.x + ", y: " + point.y + " ]");
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "CosSinCircle" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
