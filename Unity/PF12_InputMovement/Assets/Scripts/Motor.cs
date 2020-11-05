using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody2D))]
public class Motor : CollisionController
{
    private Rigidbody2D rbody;

    // [SerializeField] 
    protected Vector2 direction;
    [SerializeField] protected Vector2 velocity;
    public Vector2 Velocity
    {
        get
        {
            return velocity;
        }
    }
    
    [Header("Properties")]
    [Range(30, 240)]
    [SerializeField] protected float speed;

    [Range(10, 20)]
    [SerializeField] protected float gravity;

    protected override void Awake()
    {
        base.Awake();
        
        rbody = GetComponent<Rigidbody2D>();
    }

    // protected void Move()
    public void Move()
    {
        if (velocity == Vector2.zero)
            return;
        
        UpdateRaycastOrigins();
        collisionInfo.Reset();

        if (velocity.x != 0f)
            HorizontalRaycastCheck(ref velocity);
        
        if (velocity.y != 0f)
            VerticalRaycastCheck(ref velocity);
        
        transform.Translate(new Vector3(velocity.x, velocity.y, 0f) * Time.deltaTime);
    }

    public void SetDirection(Vector2 direction)
    {
        this.direction = direction;
    }
}
