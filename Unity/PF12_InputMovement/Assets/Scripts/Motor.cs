using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody2D))]
public class Motor : CollisionController
{
    private Rigidbody2D rbody;

    protected Vector2 direction;
    [SerializeField] protected Vector2 velocity;
    
    [Range(30, 300)]
    [SerializeField] protected float speed;

    protected override void Awake()
    {
        base.Awake();
        
        rbody = GetComponent<Rigidbody2D>();
    }

    protected void Move()
    {
        CalculateVelocity();
        UpdateRaycastOrigins();
        collisionInfo.Reset();

        if (velocity.x != 0f)
            HorizontalRaycastCheck(ref velocity);
        
        if (velocity.y != 0f)
            VerticalRaycastCheck(ref velocity);
        
        // this.velocity = velocity;
        transform.Translate(new Vector3(velocity.x, velocity.y, 0f));
    }

    private void CalculateVelocity()
    {
        velocity = direction * (speed * Time.fixedDeltaTime);
    }
}
