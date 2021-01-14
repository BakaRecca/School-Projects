public class Human extends Character
{
    public Human ()
    {
        super ();

        UpdateDirection ();

        speed = round (random (90, 120));
        radius = round (random (6, 8));
        diameter = radius + radius;

        int yellow = round (random (192, 255));
        colour = color (yellow, yellow, 0);
    }

    public void Update ()
    {
        super.Update ();

        CheckDestinationDistance ();
    }
}