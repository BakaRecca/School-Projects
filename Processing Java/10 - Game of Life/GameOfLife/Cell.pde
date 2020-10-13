public class Cell
{
    private boolean isAlive;

    private String name;

    private int x;
    private int y;
    private int size;

    private int counter;
    private final int maxCounter = 16;

    Cell ()
    {
        this.isAlive = false;

        this.x = 0;
        this.y = 0;
        this.size = 8;

        this.counter = 0;
        this.name = "EmptyCell[" + y + "][" + x + "]";
    }

    Cell (int x, int y, int size, boolean isAlive)
    {
        this.isAlive = isAlive;

        this.x = x;
        this.y = y;
        this.size = size;

        this.counter = (isAlive) ? 0 : maxCounter;

        this.name = "Cell[" + y + "][" + x + "]";
    }

    public void Draw ()
    {
        float scale = gameManager.scale;

        strokeWeight (scale);
        stroke (127, 127, 127);

        int amount = floor (256 / maxCounter);

        int r = (!isAlive) ? (256 - amount * counter) - 1 : 0;
        int g = (isAlive) ? 255 : 0;
        int b = (isAlive) ? amount * counter - 1 : 0;

        fill (r, g, b);
        // color c = (isAlive) ? color (255) : color (0);
        // fill (c);

        rectMode (CORNER);
        rect (x * size * scale, y * size * scale, size * scale, size * scale);
    }

    public boolean IsAlive ()
    {
        return isAlive;
    }

    public void SetAlive (boolean isAlive, boolean copy)
    {
        counter = (this.isAlive == isAlive) ? constrain (++counter, 0, maxCounter) : 0;

        this.isAlive = isAlive;
    }

    public void SetName (String name)
    {
        this.name = name;
    }

    public int X ()
    {
        return this.x;
    }

    public int Y ()
    {
        return this.y;
    }

    public int Counter ()
    {
        return this.counter;
    }

    public void Print ()
    {
        Print (true, true, true);
    }

    public void Print (boolean isAlive, boolean position, boolean size)
    {
        println ();
        println (name);
        
        if (isAlive)
            println ("isAlive: " + this.isAlive);

        if (position)
            println ("position: " + new PVector (x, y).mult (this.size));

        if (size)
            println ("Size: " + this.size);
    }

    public void Copy (Cell cell)
    {
        this.x = cell.X ();
        this.y = cell.Y ();

        this.isAlive = cell.IsAlive ();
        this.counter = cell.Counter ();
    }
}