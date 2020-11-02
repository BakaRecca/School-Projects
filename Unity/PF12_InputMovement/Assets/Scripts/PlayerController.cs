using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : Motor
{
    // private Motor _motor;
    private InputController inputController;

    protected override void Awake()
    {
        base.Awake();

        inputController = new InputController();
        speed = 120f;
    }

    private void Update()
    {
        // INPUT
        direction = inputController.GetDirectionInput().normalized;
    }

    private void FixedUpdate()
    {
        // MOVE
        // direction = inputController.GetDirectionInput().normalized;
        
        Move();
    }
}
