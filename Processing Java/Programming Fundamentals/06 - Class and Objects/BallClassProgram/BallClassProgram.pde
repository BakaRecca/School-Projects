Ball player;
Ball[] balls;

long time;
float deltaTime;

void setup ()
{
    size (1280, 720);
    frameRate (60);

    // Player
    player = new Ball (width * 0.5f, height * 0.5f, color (255), 32f);
    player.SetPlayer (true);

    // Balls
    balls = new Ball[10];
    float ballRadius = 48f;

    for (int i = 0; i < balls.length; i++)
    {
        balls[i] = new Ball (0f, 0f, color (0, 255, 0), ballRadius);
        balls[i].GetRandomPosition (player.m_Radius);
        balls[i].SetRandomVelocity ();
    }

    // Game Over Text
    textSize (32f);
    textAlign (CENTER);
}

void draw ()
{
    background (0);

    UpdateDeltaTime ();

    // Balls CollisionCheck, Update and Draw
    for (int i = 0; i < balls.length; i++)
    {
        if (player.m_IsAlive)
            balls[i].IsColliding (player);

        balls[i].Update (deltaTime);
        balls[i].Draw ();
    }

    // Player
    player.Update (deltaTime);
    player.Draw ();

    // Game Over???
    if (!player.m_IsAlive)
        text ("GAME OVER", width * 0.5f, height * 0.5f);
}

void UpdateDeltaTime ()
{
    long currentTime = millis ();
    deltaTime = (currentTime - time) * 0.001f;

    time = currentTime;
}
