boolean resetKeyDown = false;

boolean oneKeyDown = false;
boolean twoKeyDown = false;
boolean threeKeyDown = false;
boolean fourKeyDown = false;

boolean plusKeyDown = false;
boolean minusKeyDown = false;

boolean sKeyDown = false;
boolean nKeyDown = false;

void keyPressed ()
{
    if (key == 'r' && !resetKeyDown)
    {
        InitGame ();
        resetKeyDown = true;
    }

    if (key == '1' && !oneKeyDown)
    {
        gameManager.SetScale (1);
        oneKeyDown = true;
    }
    else if (key == '2' && !twoKeyDown)
    {
        gameManager.SetScale (2);
        twoKeyDown = true;
    }
    else if (key == '3' && !threeKeyDown)
    {
        gameManager.SetScale (3);
        threeKeyDown = true;
    }
    else if (key == '4' && !fourKeyDown)
    {
        gameManager.SetScale (4);
        fourKeyDown = true;
    }

    if (key == '+' && !plusKeyDown)
    {
        gameManager.ChangeScale (true);
        plusKeyDown = true;
    }
    else if (key == '-' && !minusKeyDown)
    {
        gameManager.ChangeScale (false);
        minusKeyDown = true;
    }

    if (key == 's' && !sKeyDown)
    {
        saveFrame("screenshot.png");
        sKeyDown = true;
    }

    if (key == 'n' && !nKeyDown)
    {
        gameManager.FrameAdvance ();
        nKeyDown = true;
    }
}

void keyReleased ()
{
    if (key == 'r' && resetKeyDown)
        resetKeyDown = false;

    if (key == '1' && oneKeyDown)
        oneKeyDown = false;

    if (key == '2' && twoKeyDown)
        twoKeyDown = false;

    if (key == '3' && threeKeyDown)
        threeKeyDown = false;

    if (key == '4' && fourKeyDown)
        fourKeyDown = false;

    if (key == '+' && plusKeyDown)
        plusKeyDown = false;
    
    if (key == '-' && minusKeyDown)
        minusKeyDown = false;

    if (key == 's' && sKeyDown)
        sKeyDown = false;

    if (key == 'n' && nKeyDown)
        nKeyDown = false;
}