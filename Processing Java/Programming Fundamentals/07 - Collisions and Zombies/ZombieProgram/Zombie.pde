public class Zombie extends Character
{
    color infectedColor;

    float aliveTime = 3f;
    float aliveTimer = 0f;

    float chaseSpeed;
    float idleSpeed;

    PVector target;
    boolean targetIsActive;

    public Zombie ()
    {
        super ();

        chaseSpeed = round (random (30, 60));
        idleSpeed = chaseSpeed * 0.5f;
        radius = round (random (4, 6));
        diameter = radius + radius;

        colour = color (0, round (random (192, 255)), round (random (128)));

        target = new PVector ();
        targetIsActive = false;

        SetNewRandomDestination ();
    }

    public Zombie (PVector position, float radius, float speed)
    {
        this.position = position;
        this.radius = radius;
        chaseSpeed = speed;
        idleSpeed = chaseSpeed * 0.5f;

        aliveTimer = 3f;

        target = new PVector (width * 0.5f, height * 0.5f);
        targetIsActive = false;

        SetNewRandomDestination ();

        diameter = radius + radius;

        colour = color (0, round (random (192, 255)), round (random (128)));
    }

    public void Update ()
    {
        if (aliveTimer > 0f)
        {
            aliveTimer -= deltaTime;
            return;
        }

        if (characterManager.numOfHumansLeft > 0)
            targetIsActive = FoundNewTarget ();
        else
            targetIsActive = false;

        speed = (targetIsActive) ? chaseSpeed : idleSpeed;

        super.Update ();
        
        CheckDestinationDistance ();

        UpdateDirection ();

        CollisionCheck ();
    }

    public void Draw (boolean drawDestination, boolean drawDirection)
    {
        if (aliveTimer > 0f)
        {
            fill (GetInfectedColor ());
            ellipse(position.x, position.y, diameter, diameter);
        }
        else
            super.Draw (drawDestination, drawDirection);
    }

    protected void UpdateDirection ()
    {
        if (!targetIsActive)
            super.UpdateDirection ();
        else
            direction = (target.copy ()).sub (position).normalize ();
    }

    private color GetInfectedColor ()
    {
        float r = (aliveTimer / aliveTime) * 255;
        float g = (1f - (aliveTimer / aliveTime)) * green (colour);
        float b = (1f - (aliveTimer / aliveTime)) * blue (colour);

        return color ((int)r, (int)g, (int)b);
    }

    private boolean FoundNewTarget ()
    {
        boolean foundTarget = false;
        float maxDistance = 64f;
        float closestDistance = maxDistance;


        Character[] characters = characterManager.characters;

        for (int i = 0; i < characters.length; i++)
        {
            if (characters[i] instanceof Zombie)
                continue;

            PVector humanPosition = characters[i].position;
            float distance = position.dist (humanPosition);

            if (distance < closestDistance)
            {
                target = humanPosition;
                closestDistance = distance;

                foundTarget = true;
            }
        }

        return foundTarget;
    }

    private void CollisionCheck ()
    {
        Character[] characters = characterManager.characters;

        for (int i = 0; i < characters.length; i++)
        {
            if (characters[i] instanceof Zombie)
                continue;

            if (CollidedWithHuman (characters[i]))
            {
                Zombie zombie = new Zombie (characters[i].position, radius, characters[i].speed * 0.5f);
                characters[i] = zombie;

                characterManager.HumanKilled ();
                SetNewRandomDestination ();
            }
        }
    }

    private boolean CollidedWithHuman (Character human)
    {
        float maxDistance = radius + human.radius;

        if (abs (position.x - human.position.x) > maxDistance || abs (position.y - human.position.y) > maxDistance)
            return false;

        if (PVector.dist (position, human.position) > maxDistance)
            return false;

        return true;
    }
}