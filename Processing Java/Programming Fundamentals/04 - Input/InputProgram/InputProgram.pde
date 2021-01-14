boolean left, right, up, down;

PVector position;
PVector input;
PVector velocity;

float speed = 60f;
float maxSpeed = 240f;
float friction = 0.8f;

float radius;
float diameter = 64f;

float deltaTime;

float gravity = 5f;
boolean applyGravity = true;
boolean gravityButtonPressed;

long time;

void setup ()
{
    size (640, 360);

    frameRate (100);

    stroke (255);
    strokeWeight (2);
    textSize (16);

    position = new PVector (320f, 180f);
    input = new PVector (0f, 0f);
    velocity = new PVector (0f, 0f);

    time = millis ();

    radius = diameter * 0.5f;
}

void draw ()
{
    background (0);

    long currentTime = millis ();
    deltaTime = (currentTime - time) * 0.001f;

    time = currentTime;

    GetInput ();
    CalcVelocity ();

    PVector move = new PVector (velocity.x, velocity.y);
    position.add (move.mult (deltaTime));

    CheckBoundaries ();

    ellipse (position.x, position.y, diameter, diameter);

    text ("pos: " + position + "\nvel: " + velocity + "\ninput: " + input + "\ndeltaTime: " + deltaTime, 0f, 16f);
}

void CalcVelocity ()
{
    PVector direction = new PVector ();
    direction.x = (velocity.x < 0f) ? -1f : 1f;
    direction.y = (velocity.y < 0f) ? -1f : 1f;

    input.normalize ();

    if (input.x != 0f)
    {
        velocity.x += input.x * speed;

        if (abs (velocity.x) > maxSpeed)
            velocity.x = direction.x * maxSpeed;
    }
    else
    {
        velocity.x *= friction;

        if (abs (velocity.x) < 0.1f)
            velocity.x = 0f;
    }

    if (applyGravity)
    {
        velocity.y += gravity;
        if (velocity.y >= maxSpeed)
            velocity.y = maxSpeed;
        return;
    }

    if (input.y != 0f)
    {
        velocity.y += input.y * speed;

        if (abs (velocity.y) > maxSpeed)
            velocity.y = direction.y * maxSpeed;
    }
    else
    {
        velocity.y *= friction;

        if (abs (velocity.y) < 0.1f)
            velocity.y = 0f;
    }
}

void CheckBoundaries ()
{
    if (position.x - radius > width)
        position.x = -radius;
    else if (position.x + radius < 0)
        position.x = width + radius;

    if (position.y - radius < 0f)
        position.y = radius;
    else if (position.y + radius > height)
    {
        position.y = height - radius;

        if (applyGravity)
            velocity.y *= -friction;
    }
}

void GetInput ()
{
    input = new PVector (0f, 0f);

    input.x += (left) ? -1f : 0f;
    input.x += (right) ? 1f : 0f;

    input.y += (up) ? -1f : 0f;
    input.y += (down) ? 1f : 0f;
}

void keyPressed ()
{
    if (keyCode == LEFT || key == 'a')
        left = true;

    if (keyCode == RIGHT || key == 'd')
        right = true;

    if (keyCode == UP || key == 'w')
        up = true;

    if (keyCode == DOWN || key == 's')
        down = true;

    if (key == 'g' && !gravityButtonPressed)
    {
        applyGravity = !applyGravity;
        gravityButtonPressed = true;
        
        if (applyGravity)
            velocity.y = 0f;
    }
}

void keyReleased ()
{
    if (keyCode == LEFT || key == 'a')
        left = false;

    if (keyCode == RIGHT || key == 'd')
        right = false;

    if (keyCode == UP || key == 'w')
        up = false;

    if (keyCode == DOWN || key == 's')
        down = false;

    if (key == 'g')
        gravityButtonPressed = false;
}
