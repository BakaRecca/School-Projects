public class CharacterManager
{
    public Character[] characters;

    public int numOfHumansLeft;

    public CharacterManager ()
    {
        startTime = millis ();
    }

    public void SpawnCharacters (int numOfHumans, int numOfZombies)
    {
        characters = new Character[numOfHumans + numOfZombies];

        for (int i = 0; i < characters.length; i++)
        {
            if (i < numOfZombies)
                characters[i] = new Zombie ();
            else
                characters[i] = new Human ();
        }

        numOfHumansLeft = numOfHumans;
    }

    public void Update ()
    {
        for (Character character : characters)
            character.Update ();
    }

    public void Draw ()
    {
        for (Character character : characters)
            character.Draw (false, false);

        if (numOfHumansLeft <= 0)
        {
            fill (255);
            text ("GAME OVER\nTOTAL TIME: " + finalTime, width * 0.5f, height * 0.5f);
        }
    }

    public void HumanKilled ()
    {
        numOfHumansLeft--;

        if (numOfHumansLeft <= 0)
        {
            for (Character character : characters)
                character.SetNewRandomDestination ();

            finalTime = (millis () - startTime) * 0.001f;
        }
    }
}