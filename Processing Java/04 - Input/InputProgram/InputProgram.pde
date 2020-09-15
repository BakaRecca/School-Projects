PVector position;
PVector input;
PVector velocity;

float speed = 30f;
float maxSpeed = 10f;

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

    frameRate (30);

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

    CalcVelocity ();

    position.add (velocity);

    CheckBoundaries ();

    ellipse (position.x, position.y, diameter, diameter);

    text ("pos: " + position + "\nvel: " + velocity + "\ninput: " + input + "\ndeltaTime: " + deltaTime, 0f, 16f);
}

void CalcVelocity ()
{
    PVector direction = new PVector ();
    direction.x = (velocity.x < 0f) ? -1f : 1f;
    direction.y = (velocity.y < 0f) ? -1f : 1f;

    if (input.x != 0f)
    {
        velocity.x += input.x * speed * deltaTime;

        if (abs (velocity.x) > maxSpeed)
            velocity.x = direction.x * maxSpeed;
    }
    else
    {
        velocity.x *= 0.7f;

        if (abs (velocity.x) < 0.1f)
            velocity.x = 0f;
    }

    if (applyGravity)
    {
        velocity.y += gravity * deltaTime;
        if (velocity.y >= maxSpeed)
            velocity.y = maxSpeed;
        return;
    }

    if (input.y != 0f)
    {
        velocity.y += input.y * speed * deltaTime;

        if (abs (velocity.y) > maxSpeed)
            velocity.y = direction.y * maxSpeed;
    }
    else
    {
        velocity.y *= 0.7f;

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
        position.y = height - radius;
}

void keyPressed ()
{
    if (keyCode == LEFT || key == 'a')
        input.x = -1f;
    else if (keyCode == RIGHT || key == 'd')
        input.x = 1f;

    if (keyCode == UP || key == 'w')
        input.y = -1f;
    else if (keyCode == DOWN || key == 's')
        input.y = 1f;

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
    if (keyCode == LEFT || key == 'a' || keyCode == RIGHT || key == 'd')
        input.x = 0f;
    
    if (keyCode == UP || key == 'w' || keyCode == DOWN || key == 's')
        input.y = 0f;

    if (key == 'g')
        gravityButtonPressed = false;
}
