public CharacterManager characterManager;

void setup ()
{
    size (640, 360);
    frameRate (60);

    // Game Over Text
    textSize (32f);
    textAlign (CENTER);

    Init ();
}

void draw ()
{
    background (0);

    UpdateDeltaTime ();

    characterManager.Update ();
    characterManager.Draw ();
}

public void Init ()
{
    characterManager = new CharacterManager ();
    characterManager.SpawnCharacters (99, 1);
}
