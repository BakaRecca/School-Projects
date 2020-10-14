using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private Rigidbody2D rBody;
    private BoxCollider2D boxCol;
    
    [SerializeField]
    private ControllerType controllerType;

    [SerializeField]
    private float speed = 60f;

    private Vector2 input;
    private Vector2 velocity;

    private void Awake ()
    {
        rBody = GetComponent<Rigidbody2D>();
        boxCol = GetComponent<BoxCollider2D>();
    }

    private void Update()
    {
        GetInput();
    }
    
    private void FixedUpdate()
    {
        Move();
    }

    private void GetInput()
    {
        input = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));

        if (Input.GetButtonDown("Jump"))
            Jump();
    }

    private void Move()
    {
        if (controllerType == ControllerType.Translate)
    }

    private void Jump()
    {
        if (IsGrounded())
        {
            
        }
    }

    private bool IsGrounded()
    {
        bool grounded = false;
        
        boxCol.enabled = false;

        if (Physics2D.OverlapCircle(transform.position, 2f))
            grounded = true;

        boxCol.enabled = true;

        return grounded;
    }

    private enum ControllerType
    {
        Translate,
        AddForce,
        Velocity
    }
}
