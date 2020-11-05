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
        // CalculateVelocity();
        // Move();
    }

    public bool Jump(bool pressed)
    {
        if (pressed)
        {
            if (!collisionInfo.below)
                return false;

            velocity.y = jumpPower;
            collisionInfo.below = false;
            return true;
        }
        else
        {
            if (velocity.y > jumpMinHeight)
                velocity.y = jumpMinHeight;
        }

        return false;
    }

    public void CalculateVelocity()
    {
        CalculateVelocityX();
        CalculateVelocityY();
    }

    private void CalculateVelocityX()
    {
        velocity.x = direction.x * ((moveSpeedX * 32) / 256f) * FPS;
    }

    private void CalculateVelocityY()
    {
        if (collisionInfo.below || collisionInfo.above)
            velocity.y = 0f;

        velocity.y -= gravity / Time.deltaTime;
    }

    public bool IsInAir()
    {
        return !collisionInfo.below;
    }
}
