int pixelWidth = 32;
int pixelHeight = 32;

int pixelSize = 32;

float xOffset = 112f;
float yOffset = 136f;

float yScroll = 0f;
float yScrollSpeed = 8f;
int scrollTimer = 0;
float scrollDirectionY = 1f;
float maxScrollY = 64f;


float xPos = 32f;
float yPos = 32f;

int[] pixelLights = {1, 1, 0, 0, 1, 1};
int pixelLightsIndex = 0;

char[] nameLetters = {'E', 'D', 'D', 'I', 'E'};

int[][] letterE = { {1, 1, 1},
                    {1, 0, 0},
                    {1, 1, 0},
                    {1, 0, 0},
                    {1, 1, 1}};
                     
int[][] letterD = { {1, 1, 0},
                    {1, 0, 1},
                    {1, 0, 1},
                    {1, 0, 1},
                    {1, 1, 0}};
                     
int[][] letterI = { {1},
                    {1},
                    {1},
                    {1},
                    {1}};

void setup ()
{
    size(768, 432);

    scrollTimer = millis ();

    background(15, 0, 15);
    stroke(0, 0, 31);
    strokeWeight(2);

    DrawName ();
}

void draw ()
{
    xOffset = 112f;
    yOffset = 136f + yScroll;

    boolean updateDraw = false;

    if ((millis () - scrollTimer) >= 100)
    {   
        if (yScroll >= maxScrollY && scrollDirectionY > 0f)
            scrollDirectionY = -1f;
        else if (yScroll <= -maxScrollY)
            scrollDirectionY = 1f;

        yScroll += scrollDirectionY * yScrollSpeed;
        scrollTimer = millis ();

        pixelLightsIndex++;
        pixelLightsIndex = pixelLightsIndex % pixelLights.length;

        updateDraw = true;
    }

    if (updateDraw)
    {
        background(15, 0, 15);
        DrawName ();
    }
}

void DrawName ()
{
    for (int i = 0; i < nameLetters.length; i++)
    {
        switch (nameLetters[i])
        {
            case 'E':
                DrawLetter (letterE);
                break;

            case 'D':
                DrawLetter (letterD);
                break;

            case 'I':
                DrawLetter (letterI);
                break;
        }
    }
}

void DrawLetter (int[][] letter)
{
    for (int y = 0; y < letter.length; y++)
    {
        for (int x = 0; x < letter[y].length; x++)
        {
            if (letter[y][x] == 0)
                continue;

            if (pixelLights[((pixelLightsIndex + x) % pixelLights.length)] == 0)
                continue;

            float _x = xOffset + x * pixelSize;
            float _y = yOffset + y * pixelSize;

            DrawQuad (_x, _y);
        }
    }

    xOffset += (letter[0].length + 1) * pixelSize;
}

void DrawQuad (float xPos, float yPos)
{
    quad(   xPos, yPos,                         // Top-Left
            xPos + pixelSize, yPos,             // Top-Right
            xPos + pixelSize, yPos + pixelSize, // Bottom-Right
            xPos, yPos + pixelSize);            // Bottom-Left
}
