using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#pragma warning disable 649

public class PlayerController : Motor
{
    [Header("Properties")]
    [SerializeField] private int currentMoveSpeed;
    [SerializeField] private float jumpPower;
    private float jumpMinHeight = 120f;
    
    // [HideInInspector]
    public Vector2 currentVelocity;

    [Range(4, 32)]
    [SerializeField] private int moveSpeedX;

    private const int FPS = 60;

    protected override void Awake()
    {
        base.Awake();
        
        speed = 120f;
    }

    private void FixedUpdate()
    {
        // MOVE
        CalculateVelocity();
        Move();
    }

    public void Jump(bool pressed)
    {
        if (pressed)
        {
            if (!collisionInfo.below)
                return;

            currentVelocity.y = jumpPower;
            collisionInfo.below = false;
        }
        else
        {
            if (currentVelocity.y > jumpMinHeight)
                currentVelocity.y = jumpMinHeight;
        }
    }

    public void CalculateVelocity()
    {
        CalculateVelocityX();
        CalculateVelocityY();

        velocity = currentVelocity * Time.deltaTime;
    }

    private void CalculateVelocityX()
    {
        currentVelocity.x = direction.x * ((moveSpeedX * 32) / 256f) * FPS;
    }

    private void CalculateVelocityY()
    {
        if (collisionInfo.below || collisionInfo.above)
            currentVelocity.y = 0f;

        currentVelocity.y -= gravity;
    }

    public bool IsInAir()
    {
        return !collisionInfo.below;
    }
}
