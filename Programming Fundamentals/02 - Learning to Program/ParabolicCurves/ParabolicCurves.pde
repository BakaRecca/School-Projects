float winWidth = 512f;
float winHeight = 512f;

ParabolicCurve[] parabolicCurves;

void setup ()
{
    size (512, 512);
    background (248, 248, 248);
    strokeWeight (1f);
    stroke (128, 128, 128, 255);

    // Axis Coords acording to normals.
    parabolicCurves = new ParabolicCurve[4];

    parabolicCurves[0] = new ParabolicCurve (1f, 1f, 16);
    parabolicCurves[1] = new ParabolicCurve (-1f, 1f, 16);
    parabolicCurves[2] = new ParabolicCurve (1f, -1f, 16);
    parabolicCurves[3] = new ParabolicCurve (-1f, -1f, 16);
}

void draw ()
{
    for (int i = 0; i < parabolicCurves.length; i++)
        parabolicCurves[i].Draw ();
}

class ParabolicCurve
{
    float hAxis = 1f;
    float vAxis = 1f;
    
    int maxLines = 16;
    float coordSize = 16f;

    ParabolicCurve (float _hAxis, float _vAxis, int _maxLines)
    {
        hAxis = _hAxis;
        vAxis = _vAxis;

        maxLines = _maxLines;
    }

    public void Draw ()
    {
        int currentLine = 0;

        for (int i = 0; i < maxLines; i++)
        {
            float x1 = (hAxis > 0f) ? 0 : maxLines * 2f;
            float y1 = (vAxis > 0f) ? maxLines + i : maxLines - i;
            float x2 = (hAxis > 0f) ? i + 1 : (maxLines * 2f) - (i + 1);
            float y2 = (vAxis > 0f) ? maxLines * 2f : 0f;

            print ("\nhAxis: " + hAxis);

            print ("\ni: " + i);
            print ("\nx1: " + x1 + " - x2: " + x2);
            print ("\ny1: " + y1 + " - y2: " + y2);

            if ((currentLine % 3) == 0)
                stroke (0, 0, 0, 255);
            else
                stroke (128, 128, 128, 255);

            print ("\ncurrentLine: " + currentLine + " - mod: " + (currentLine % 3));

            line (  x1 * coordSize, y1 * coordSize,
                    x2 * coordSize, y2 * coordSize);
                    
            currentLine++;
        }
    }
}
