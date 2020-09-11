PVector origin;
float radius = 32f;

PVector velocity = new PVector (0f, 0f);

void setup ()
{
    size(640, 360);
    frameRate (30);

    stroke (255);
    strokeWeight (2);
    fill (0);

    origin = new PVector (width * 0.5f, height * 0.5f);
}

void draw ()
{
    background (0, 0, 0);

    origin.add (velocity);

    CheckOOB ();

    ellipse (origin.x, origin.y, radius + radius, radius + radius);

    if (mousePressed)
        line (mouseX, mouseY, origin.x, origin.y);
}

void mousePressed ()
{
    origin = new PVector (mouseX, mouseY);
    velocity = new PVector ();
}

void mouseReleased ()
{
    CalcVelocity ();
}

void CalcVelocity ()
{
    PVector deltaPos = new PVector (mouseX - origin.x, mouseY - origin.y);

    float magnitude = deltaPos.mag ();
    PVector direction = deltaPos.normalize ();

    velocity.mult (direction, (magnitude * 0.1f), velocity);

    // print ("\ndirection: " + direction);
    // print ("\nmagnitude: " + magnitude);
    // print ("\ndeltaPos: " + deltaPos);
}

void CheckOOB ()
{
    if (origin.x >= (width - radius) && velocity.x > 0f)    // RIGHT
    {
        origin.x = width - radius;
        velocity.x *= -1f;
    }
    else if (origin.x <= radius && velocity.x < 0f)         // LEFT
    {
        origin.x = radius;
        velocity.x *= -1f;
    }

    if (origin.y >= (height - radius) && velocity.y > 0f)   // BOTTOM
    {
        origin.y = height - radius;
        velocity.y *= -1f;
    }
    else if (origin.y <= radius && velocity.y < 0f)         // TOP
    {
        origin.y = radius;
        velocity.y *= -1f;
    }
}