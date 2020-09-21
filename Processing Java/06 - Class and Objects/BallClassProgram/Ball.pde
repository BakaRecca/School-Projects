class Ball
{
    PVector m_Position;
    PVector m_Velocity;

    float m_Speed = 10f;
    float m_MaxSpeed = 50f;
    float m_Drag = 0.7f;

    float m_Radius;

    color m_Color;

    boolean m_IsPlayer = false;
    boolean m_IsAlive = true;

    Ball (PVector position, color colour, float radius)
    {
        m_Position = position;
        m_Velocity = new PVector ();
        m_Color = colour;
        m_Radius = radius;
    }

    Ball (float x, float y, color colour, float radius)
    {
        m_Position = new PVector (x, y);
        m_Velocity = new PVector ();
        m_Color = colour;
        m_Radius = radius;
    }

    void Update (float deltaTime)
    {
        if (!m_IsAlive)
            return;

        if (m_IsPlayer)
            CalcVelocity ();

        PVector move = m_Velocity.copy ();
        move.mult (m_Speed * deltaTime);

        m_Position.add (move);

        CheckBoundaries ();
    }

    void Draw ()
    {
        if (m_IsAlive)
            fill (m_Color);
        else
            fill (color (255, 0, 0));

        ellipse (m_Position.x, m_Position.y, m_Radius * 2, m_Radius * 2);
    }

    public void SetPlayer (boolean isPlayer)
    {
        m_IsPlayer = isPlayer;
    }

    void CalcVelocity ()
    {
        input.UpdateDirection ();
        PVector direction = input.GetDirectionNormalized ();

        if (direction.x == 0f && direction.y == 0f)
        {
            m_Velocity.mult (m_Drag);
            return;
        }
        
        direction.mult (m_Speed);

        m_Velocity.add (direction);
        m_Velocity.limit (m_MaxSpeed);
    }

    void CheckBoundaries ()
    {
        if (!m_IsPlayer)
        {
            if (m_Position.x < m_Radius || m_Position.x > width - m_Radius)
                m_Velocity.x *= -1f;

            if (m_Position.y < m_Radius || m_Position.y > height - m_Radius)
                m_Velocity.y *= -1f;
        }

        m_Position.x = constrain (m_Position.x, m_Radius, width - m_Radius);
        m_Position.y = constrain (m_Position.y, m_Radius, height - m_Radius);
    }

    public void GetRandomPosition (float playerRadius)
    {
        // Don't spawn near center where Player is.
        float x = random (m_Radius, width * 0.5f - (playerRadius * 4f));
        float y = random (m_Radius, height * 0.5f - (playerRadius * 4f));

        // Left||Right, Top||Bottom side of screen.
        int xSign = round (random (1));
        int ySign = round (random (1));

        if (xSign == 0)
            m_Position.x = x;
        else
            m_Position.x = width - x;

        if (ySign == 0)
            m_Position.y = y;
        else
            m_Position.y = height - y;
    }

    public void SetRandomVelocity ()
    {
        m_Velocity = new PVector ();
        m_Velocity.x = random (35) - 10;
        m_Velocity.y = random (35) - 10;
    }

    public boolean IsColliding (Ball ball)
    {
        float maxDistance = m_Radius + ball.m_Radius;

        if (abs (m_Position.x - ball.m_Position.x) > maxDistance || abs (m_Position.y - ball.m_Position.y) > maxDistance)
            return false;
        else if (dist (m_Position.x, m_Position.y, ball.m_Position.x, ball.m_Position.y) > maxDistance)
            return false;

        m_IsAlive = false;
        ball.m_IsAlive = false;

        return true;
    }

    public boolean IsAlive ()
    {
        return m_IsAlive;
    }
}
