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

public class WriteMyName extends PApplet {

int pixelWidth = 32;
int pixelHeight = 32;

int pixelSize = 32;

int xOffset = 0;

float xPos = 32f;
float yPos = 32f;

char[] nameLetters = {'E', 'D', 'D', 'I', 'E'};

int[][] letterE = {  {1, 1, 1},
                     {1, 0, 0},
                     {1, 1, 0},
                     {1, 0, 0},
                     {1, 1, 1}};
                     
int[][] letterD = {  {1, 1, 0},
                     {1, 0, 1},
                     {1, 0, 1},
                     {1, 0, 1},
                     {1, 1, 0}};
                     
int[][] letterI = {  {1},
                     {1},
                     {1},
                     {1},
                     {1}};

public void setup()
{
  
}

public void draw()
{
  background(31, 0, 31);
  stroke(248, 248, 248);
  strokeWeight(2.5f);
  //line(199, 166, 388, 295);
  
  xOffset = 0;
  
  for (int i = 0; i < nameLetters.length; i++)
  {
    DrawLetter (nameLetters[i]);
  }
}

public void DrawLetter (char letter)
{
  if (letter == 'E')
  {
    for (int y = 0; y < letterE.length; y++)
    {
      quad (xPos + xOffset, yPos,                                   // Top-Left
            xPos + xOffset + (pixelSize * 1), yPos,                 // Top-Right
            xPos + xOffset + pixelSize, yPos + (pixelSize * 1),     // Bottom-Right
            xPos + xOffset, yPos + pixelSize);                      // Bottom-Left
    }
    //quad (xPos + xOffset, yPos,                                   // Top-Left
       //   xPos + xOffset + (pixelSize * 1), yPos,                 // Top-Right
        //  xPos + xOffset + pixelSize, yPos + (pixelSize * 1),     // Bottom-Right
         // xPos + xOffset, yPos + pixelSize);                      // Bottom-Left
    
    xOffset += 4 * pixelSize;
  }
}
  public void settings() {  size(768, 432); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "WriteMyName" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
