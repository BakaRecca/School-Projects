PVector winSize;

PVector origin = new PVector (320f, 180f);
float diameter = 64f;
float radius;

float magnitude;
PVector direction;
PVector velocity = new PVector (0f, 0f);

boolean mousePressedOLD;
boolean drawLine;

void setup()
{
    size(640, 360);
    winSize = new PVector (640f, 360f);

    frameRate (5);

    radius = diameter * 0.5f;
}

void draw()
{
    background (128, 128, 128, 255);

    CheckInput ();

    origin.add (velocity);

    CheckOOB ();

    ellipse (origin.x, origin.y, diameter, diameter);

    if (drawLine)
        line (mouseX, mouseY, origin.x, origin.y);
}

void CheckInput ()
{
    drawLine = false;

    if (mousePressed && !mousePressedOLD)
        OnMousePressed ();
    else if (mousePressed && mousePressedOLD)
        OnMouseHold ();

    mousePressedOLD = mousePressed;
}

void OnMousePressed ()
{
    origin = new PVector (mouseX, mouseY);
}

void OnMouseHold ()
{
    drawLine = true;

    CalcVelocity ();
}

void CalcVelocity ()
{
    PVector deltaPos = new PVector (mouseX - origin.x, mouseY - origin.y);

    magnitude = deltaPos.mag ();
    direction = deltaPos.normalize ();

    velocity.mult (direction, (magnitude * 0.1f), velocity);

    // print ("\ndirection: " + direction);
    // print ("\nmagnitude: " + magnitude);
    // print ("\ndeltaPos: " + deltaPos);
}

void CheckOOB ()
{
    if (origin.x >= (winSize.x - radius) && velocity.x > 0f)    // RIGHT
    {
        origin.x = winSize.x - radius;
        velocity.x *= -1f;
    }
    else if (origin.x <= radius && velocity.x < 0f)             // LEFT
    {
        origin.x = radius;
        velocity.x *= -1f;
    }

    if (origin.y >= (winSize.y - radius) && velocity.y > 0f)    // BOTTOM
    {
        origin.y = winSize.y - radius;
        velocity.y *= -1f;
    }
    else if (origin.y <= radius && velocity.y < 0f)             // TOP
    {
        origin.y = radius;
        velocity.y *= -1f;
    }
}