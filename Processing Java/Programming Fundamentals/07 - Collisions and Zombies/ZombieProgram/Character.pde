public class Character
{
    protected PVector position;
    protected PVector direction;
    protected PVector destination;

    protected float speed;
    protected float radius;
    protected float diameter;

    protected color colour;

    public Character ()
    {
        position = new PVector (round (random (radius, width - radius)),
                                round (random (radius, height - radius)));
        
        SetNewRandomDestination ();
    }

    public void Update ()
    {
        Move ();
    }

    public void Draw (boolean drawDestination, boolean drawDirection)
    {
        // Destination
        if (drawDestination)
        {   
            stroke (192, 0, 0, 0);
            strokeWeight (0);
            fill (192, 0, 0, 64);
            ellipse (destination.x, destination.y, radius, radius);
        }

        // Direction
        if (drawDirection)
        {
            stroke (255, 0, 0);
            strokeWeight (4);
            line (  position.x, position.y,
                    position.x + direction.x * (radius + speed * deltaTime),
                    position.y + direction.y * (radius + speed * deltaTime));
        }

        // Character
        stroke (255);
        strokeWeight (2);
        fill (colour);
        ellipse (position.x, position.y, diameter, diameter);
    }

    private void Move ()
    {
        PVector velocity = (direction.copy ()).mult (speed * deltaTime);
        position.add (velocity);

        ScreenWrap ();
    }

    private void ScreenWrap ()
    {
        if (direction.x < 0f && position.x < -radius)
            position.x += width + diameter;
        else if (direction.x > 0f && position.x > width + radius)
            position.x -= width + diameter;

        if (direction.y < 0f && position.y < -radius)
            position.y += height + diameter;
        else if (direction.y > 0f && position.y > height + radius)
            position.y -= height + diameter;
    }

    protected void UpdateDirection ()
    {
        direction = (destination.copy ()).sub (position).normalize ();
    }

    protected void SetNewRandomDestination ()
    {
        destination = new PVector (random (width), random (height));
        UpdateDirection ();
    }

    protected PVector GetRandomDirection ()
    {
        float angle = random (360);
        return new PVector (cos (radians (angle)), sin (radians (angle)));
    }

    protected void CheckDestinationDistance ()
    {
        float distance = position.dist (destination);

        if (distance <= speed * deltaTime)
            SetNewRandomDestination ();
    }
}