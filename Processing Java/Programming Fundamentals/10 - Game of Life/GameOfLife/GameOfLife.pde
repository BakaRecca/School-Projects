GameManager gameManager;

void settings ()
{
    size (1280, 720);
}

void setup ()
{
    frameRate (8);
    InitGame ();
}

void draw ()
{
    UpdateDeltaTime ();

    if (gameManager == null)
        return;

    gameManager.Update ();
    gameManager.Draw ();
}

public void InitGame ()
{
    gameManager = new GameManager ();
    gameManager.Init ();
}