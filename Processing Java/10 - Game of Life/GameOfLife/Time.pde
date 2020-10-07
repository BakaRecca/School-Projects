long time;
float deltaTime;

public void UpdateDeltaTime ()
{
    long currentTime = millis ();
    deltaTime = (currentTime - time) * 0.001f;

    time = currentTime;
}