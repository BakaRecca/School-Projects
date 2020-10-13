public class GameManager
{
    CellManager cellManager;

    int scale;

    boolean useTimers = true;
    float updateTimer;
    float updateTime;

    GameManager ()
    {
    }

    public void Init ()
    {
        scale = 1;
        updateTime = 0f;
        updateTimer = updateTime;

        cellManager = new CellManager ();
        cellManager.Init ();
    }

    public void Update ()
    {
        UpdateTimers ();
    }

    public void Draw ()
    {
        background (255, 0, 255);

        if (cellManager == null)
            return;

        cellManager.Draw ();
    }

    public void FrameAdvance ()
    {
        if (useTimers)
            return;

        cellManager.Update ();
    }

    public void SetScale (int scale)
    {
        this.scale = scale;
    }

    public void ChangeScale (boolean increase)
    {
        int amount = (increase) ? 1 : -1;
        int min = 1;
        int max = 8;

        scale = constrain (scale + amount, min, max);
    }

    private void UpdateTimers ()
    {
        if (!useTimers)
            return;

        updateTimer -= deltaTime;

        if (updateTimer <= 0f)
        {
            updateTimer += updateTime;
            cellManager.Update ();
        }
    }
}