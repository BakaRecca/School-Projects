public class CellManager
{
    Cell[][] grid;
    Cell[][] gridBuffer;

    CellManager ()
    {
    }

    public void Init ()
    {
        float scale = gameManager.scale;
        int cellSize = 8;

        int mapWidth = floor (width / cellSize);
        int mapHeight = floor (height / cellSize);
        int totalCells = mapHeight * mapWidth;

        IntList aliveList = new IntList ();
        float alivePercent = 0.2f;
        int aliveCount = floor((float)(totalCells) * alivePercent);
        
        for (int i = 0; i < totalCells; i++)
        {
            aliveList.append((i < aliveCount ? 1 : 0));
        }

        aliveList.shuffle ();

        grid = new Cell[mapHeight][mapWidth];
        gridBuffer = new Cell[mapHeight][mapWidth];

        for (int y = 0; y < mapHeight; y++)
        {
            for (int x = 0; x < mapWidth; x++)
            {
                boolean isAlive = (aliveList.get (y * mapHeight + x) == 1) ? true : false;
                Cell cell = new Cell (x, y, cellSize, isAlive);
                grid[y][x] = cell;
            }
        }
    }

    public void Update ()
    {
        if (grid == null)
            return;

        int cellsAlive = 0;

        arrayCopy (grid, gridBuffer);
            
        for (int y = 0; y < grid.length; y++)
        {
            for (int x = 0; x < grid[y].length; x++)
            {
                gridBuffer[y][x].SetAlive (IsAliveAt (y, x));
            }
        }

        arrayCopy (gridBuffer, grid);
    }

    public void Draw ()
    {
        if (grid == null)
            return;

        for (int y = 0; y < grid.length; y++)
        {
            for (int x = 0; x < grid[y].length; x++)
            {
                grid[y][x].Draw ();
            }
        }
    }

    private boolean IsAliveAt (int y, int x)
    {
        int neighbourCount = 0;

        for (int h = -1; h < 2; h++)
        {
            for (int w = -1; w < 2; w++)
            {
                if (h == 0 && w == 0)
                    continue;

                if (HasNeighbour (y + h, x + w))
                {
                    neighbourCount++;
                    if (neighbourCount > 3)
                        return false;
                }
            }
        }

        if (neighbourCount < 2)
            return false;

        if (!grid[y][x].IsAlive () && neighbourCount != 3)
            return false;

        return true;
    }

    private boolean HasNeighbour (int y, int x)
    {
        if (y < 0 || x < 0 || y >= grid.length || x >= grid[0].length)
            return false;

        return grid[y][x].IsAlive ();
    }
}