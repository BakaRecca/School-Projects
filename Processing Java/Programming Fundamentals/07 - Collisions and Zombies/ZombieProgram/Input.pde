boolean resetKeyDown = false;

public void keyPressed ()
{
    if (key == 'r' && !resetKeyDown)
    {
        resetKeyDown = true;
        Init ();
    }
}

public void keyReleased ()
{
    if (key == 'r')
        resetKeyDown = false;
}
