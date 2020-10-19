using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor.Experimental.GraphView;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private SpriteRenderer spriteRenderer;
    private Rigidbody2D rBody;
    private BoxCollider2D boxCol;

    [SerializeField] private LayerMask collisionMask;
    [SerializeField] private ControllerType controllerType;

    [SerializeField] private float speed = 90f;
    [SerializeField] private float jumpPower = 300f;
    [SerializeField] private float gravity = 15f;

    private Vector2 input;
    [SerializeField] private Vector2 velocity;
    [SerializeField] private Vector2 maxVelocity;
    [SerializeField] private Vector2 rVel;
    [SerializeField] private ForceMode2D forceMode2D;
    
    private const float skinWidth = 0.1f;
    private const int tileSize = 8;

    private void Awake ()
    {
        spriteRenderer = GetComponentInChildren<SpriteRenderer>();
        rBody = GetComponent<Rigidbody2D>();
        boxCol = GetComponent<BoxCollider2D>();
        
        maxVelocity = new Vector2(jumpPower, jumpPower);
    }

    private void Update()
    {
        GetInput();
        UpdateAnimations();
    }
    
    private void FixedUpdate()
    {
        ApplyGavity();
        CalcVelocity();
        ClampVelocity();
        CheckCollision();
        Move();
        rVel = rBody.velocity;
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
            transform.Translate(new Vector3(velocity.x, velocity.y, 0f) * Time.fixedDeltaTime);
        else if (controllerType == ControllerType.AddForce)
            rBody.AddForce(velocity, forceMode2D);
        else
            rBody.velocity = velocity;
    }

    private void CalcVelocity()
    {
        velocity = new Vector2(input.x * speed, velocity.y);
    }

    private void ClampVelocity()
    {
        velocity = new Vector2( Mathf.Clamp(velocity.x, -maxVelocity.x, maxVelocity.x),
                                Mathf.Clamp(velocity.y, -maxVelocity.y, maxVelocity.y));

        rBody.velocity = velocity;
    }

    private void ApplyGavity()
    {
        velocity.y -= gravity;
    }

    private void Jump()
    {
        if (IsGrounded())
        {
            velocity.y = jumpPower;
        }
    }

    private bool IsGrounded()
    {
        if (velocity.y >= 0f)
            return false;
        
        Debug.LogWarning($"JUMP!");

        Vector2[] origins = GetOrigins(false);
        Vector2 direction = Vector2.down;
        float distance = (Mathf.Abs(velocity.y) + skinWidth) * Time.fixedDeltaTime;
        
        Debug.Log($"origins.Length: {origins.Length}");

        boxCol.enabled = false;
        
        for (int i = 0; i < origins.Length; i++)
        {
            Debug.Log($"origins[{i}]: {origins[i]} - direction: {direction} - distance: {distance}");
            
            RaycastHit2D hit = Physics2D.Raycast(origins[i], direction, distance, collisionMask);

            if (hit)
            {
                boxCol.enabled = true;
                return true;
            }
        }

        return false;
    }

    private void UpdateAnimations()
    {
        if (input.x != 0f)
        {
            spriteRenderer.flipX = (input.x < 0f) ? true : false;
        }
    }

    private void CheckCollision()
    {
        // if (controllerType != ControllerType.Translate)
        //     return;

        // boxCol.enabled = false;
        
        FoundRaycastCollision(false);
        FoundRaycastCollision(true);
        
        // boxCol.enabled = true;
    }

    private bool FoundRaycastCollision(bool horizontal)
    {
        if (horizontal && velocity.x == 0f ||
            !horizontal && velocity.y == 0f)
            return false;

        bool foundCollision = false;

        Vector2[] origins = GetOrigins(horizontal);
        Vector2 direction = (horizontal) ? Vector2.right * Mathf.Sign(velocity.x) : Vector2.up * Mathf.Sign(velocity.y);
        float distance = (Mathf.Abs((horizontal) ? velocity.x : velocity.y) + skinWidth) * Time.fixedDeltaTime;

        boxCol.enabled = false;
        
        for (int i = 0; i < origins.Length; i++)
        {
            RaycastHit2D hit = Physics2D.Raycast(origins[i], direction, distance, collisionMask);

            if (hit)
            {
                if (hit.distance == 0f)
                    continue;
                
                if (horizontal)
                    velocity.x = ((hit.distance - skinWidth) * direction.x) / Time.fixedDeltaTime;
                else
                {
                    if (direction.y < 0f)
                        gameObject.transform.position = new Vector3(transform.position.x, hit.point.y, 0f);
                    else
                        gameObject.transform.position = new Vector3(transform.position.x, hit.point.y - boxCol.size.y, 0f);

                    velocity.y = 0f;
                }
                
                distance = hit.distance;
                foundCollision = true;
            }
        }
        
        boxCol.enabled = true;

        return foundCollision;
    }

    private Vector2[] GetOrigins(bool horizontal)
    {
        Vector2[] points = new Vector2[(horizontal) ?   Mathf.CeilToInt(boxCol.size.y / tileSize) + 1 :
                                                        Mathf.CeilToInt(boxCol.size.x / tileSize) + 1];

        Bounds bounds = boxCol.bounds;
        bounds.Expand(-skinWidth);

        float pointOffset = (horizontal) ? bounds.size.y / (points.Length - 1) : bounds.size.x / (points.Length - 1);

        Vector2 origin = (Vector2) transform.position + boxCol.offset;
        
        // if (!horizontal)
        //     Debug.Log($"1. origin: {origin} - bounds.size: {bounds.size} - pointOffset: {pointOffset}");

        if (horizontal)
        {
            origin += new Vector2(Mathf.Sign(velocity.x) * bounds.extents.x, -bounds.extents.y);

            for (int i = 0; i < points.Length; i++)
            {
                points[i] = origin + Vector2.up * (pointOffset * i);
                Debug.DrawRay (origin + Vector2.up * (pointOffset * i), Vector2.right * (Mathf.Sign (velocity.x) * Mathf.Abs(velocity.x * Time.fixedDeltaTime)));
            }
        }
        else
        {
            origin += new Vector2(-bounds.extents.x, (Mathf.Sign(velocity.y) < 0f) ?  -bounds.extents.y : bounds.extents.y);
            // Debug.Log($"2. origin: {origin}");

            for (int i = 0; i < points.Length; i++)
            {
                points[i] = origin + Vector2.right * (pointOffset * i);
                // Debug.Log($"3. points[{i}]: {points[i]}");
                Debug.DrawRay (origin + Vector2.right * (pointOffset * i), Vector2.up * (Mathf.Sign (velocity.y) * Mathf.Abs(velocity.y * Time.fixedDeltaTime)));
            }
        }

        return points;
    }

    private enum ControllerType
    {
        Translate,
        AddForce,
        Velocity
    }
}
