long time;
float deltaTime;

long startTime;
float finalTime;

public void UpdateDeltaTime ()
{
    long currentTime = millis ();
    deltaTime = (currentTime - time) * 0.001f;

    time = currentTime;
}