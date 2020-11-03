using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.Experimental.GraphView;
using UnityEngine;

#pragma warning disable 649

public class PlayerControllerMulti : MonoBehaviour
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
    private Vector2 maxVelocity;
    [SerializeField] private ForceMode2D forceMode2D;
    
    private const float skinWidth = 0.01f;
    private const int tileSize = 8;

    private GizmoRayHandler gizmoDebugHandler;

    private void Awake ()
    {
        spriteRenderer = GetComponentInChildren<SpriteRenderer>();
        rBody = GetComponent<Rigidbody2D>();
        boxCol = GetComponent<BoxCollider2D>();
        
        maxVelocity = new Vector2(jumpPower, jumpPower);
        
        gizmoDebugHandler = new GizmoRayHandler();
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
    }

    private void OnDrawGizmos()
    {
        if (!Application.isPlaying)
            return;
        
        if (gizmoDebugHandler == null)
        {
            // Debug.LogError($"gizmoDebugHandler = null!!! = return OnDrawGizmos()");
            return;
        }
        
        gizmoDebugHandler.DrawGizmos();
    }

    private void GetInput()
    {
        input = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));

        if (Input.GetButtonDown("Jump"))
            Jump();
    }
    
    private void Jump()
    {
        if (IsGrounded())
            velocity.y = jumpPower;
    }

    private bool IsGrounded()
    {
        if (velocity.y > 0f)
            return false;
        
        Vector2[] origins = GetOrigins(Vector2.down);
        Vector2 direction = Vector2.down;
        float distance = (velocity.y != 0f) ? (velocity.y * Time.fixedDeltaTime) + skinWidth : skinWidth * 2f;

        boxCol.enabled = false;
        
        for (int i = 0; i < origins.Length; i++)
        {
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
    
    private void ApplyGavity()
    {
        velocity.y -= gravity;
    }

    private void CalcVelocity()
    {
        velocity = new Vector2(input.x * speed, velocity.y);
    }

    private void ClampVelocity()
    {
        velocity = new Vector2( Mathf.Clamp(velocity.x, -maxVelocity.x, maxVelocity.x),
            Mathf.Clamp(velocity.y, -maxVelocity.y, maxVelocity.y));

        if (controllerType == ControllerType.AddForce)
            rBody.velocity = velocity;
    }
    
    private void CheckCollision()
    {
        gizmoDebugHandler.ClearGizmoRays();
        
        if (velocity.y != 0f)
            FoundRaycastCollision(Vector2.up * Mathf.Sign(velocity.y));
        if (velocity.x != 0f)
            FoundRaycastCollision(Vector2.right * Mathf.Sign(velocity.x));
    }
    
    private bool FoundRaycastCollision(Vector2 direction)
    {
        if (direction == Vector2.zero)
            return false;

        bool foundCollision = false;

        Vector3 newPosition = transform.position;
        Vector2[] origins = GetOrigins(direction);
        float distance = (Mathf.Abs((direction.x != 0f) ? velocity.x : velocity.y) * Time.fixedDeltaTime) + skinWidth;

        boxCol.enabled = false;
        
        for (int i = 0; i < origins.Length; i++)
        {
            RaycastHit2D hit = Physics2D.Raycast(origins[i], direction, distance, collisionMask);
            
            GizmoRay gizmoRay = new GizmoRay(origins[i], direction, distance, (direction.x != 0f) ? Color.red : Color.blue);
            gizmoDebugHandler.AddGizmoRay(gizmoRay);

            if (hit)
            {
                if (hit.distance == 0f)
                    continue;
                
                if (direction.x != 0f)
                    velocity.x = ((hit.distance - skinWidth) * direction.x) / Time.fixedDeltaTime;
                else
                {
                    if (direction.y < 0f)
                        newPosition.y = hit.point.y;
                    else
                        newPosition.y = hit.point.y - boxCol.size.y;

                    // velocity.y = (hit.distance - skinWidth) / Time.fixedDeltaTime;
                    velocity.y = 0f;
                }
                
                distance = hit.distance;
                foundCollision = true;
            }
        }
        
        boxCol.enabled = true;

        transform.position = newPosition;

        return foundCollision;
    }
    
    private Vector2[] GetOrigins(Vector2 direction)
    {
        Vector2[] points = new Vector2[(direction.x != 0f) ?    Mathf.CeilToInt(boxCol.size.y / tileSize) + 1 :
                                                                Mathf.CeilToInt(boxCol.size.x / tileSize) + 1];

        Bounds bounds = boxCol.bounds;
        bounds.Expand(-skinWidth * 2f);

        float pointOffset = (direction.x != 0f) ? bounds.size.y / (points.Length - 1) : bounds.size.x / (points.Length - 1);

        Vector2 origin = (Vector2) transform.position + boxCol.offset;

        if (direction.x != 0f)
        {
            origin += new Vector2(Mathf.Sign(direction.x) * bounds.extents.x, -bounds.extents.y);

            for (int i = 0; i < points.Length; i++)
            {
                points[i] = origin + Vector2.up * (pointOffset * i);
                
                float dst = skinWidth;
                Color rayColor = Color.white; 
                GizmoRay gizmoRay = new GizmoRay(points[i], Vector2.up, dst, rayColor);
                gizmoDebugHandler.AddGizmoRay(gizmoRay);
                gizmoRay = new GizmoRay(points[i], Vector2.right, dst, rayColor);
                gizmoDebugHandler.AddGizmoRay(gizmoRay);
                gizmoRay = new GizmoRay(points[i], Vector2.down, dst, rayColor);
                gizmoDebugHandler.AddGizmoRay(gizmoRay);
                gizmoRay = new GizmoRay(points[i], Vector2.left, dst, rayColor);
            }
        }
        else
        {
            origin += new Vector2(-bounds.extents.x, (Mathf.Sign(direction.y) < 0f) ?  -bounds.extents.y : bounds.extents.y);

            for (int i = 0; i < points.Length; i++)
            {
                points[i] = origin + Vector2.right * (pointOffset * i);

                float dst = skinWidth;
                Color rayColor = Color.white; 
                GizmoRay gizmoRay = new GizmoRay(points[i], Vector2.up, dst, rayColor);
                gizmoDebugHandler.AddGizmoRay(gizmoRay);
                gizmoRay = new GizmoRay(points[i], Vector2.right, dst, rayColor);
                gizmoDebugHandler.AddGizmoRay(gizmoRay);
                gizmoRay = new GizmoRay(points[i], Vector2.down, dst, rayColor);
                gizmoDebugHandler.AddGizmoRay(gizmoRay);
                gizmoRay = new GizmoRay(points[i], Vector2.left, dst, rayColor);
                gizmoDebugHandler.AddGizmoRay(gizmoRay);
            }
        }

        return points;
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

    // private Vector2 GetSignedVector(Vector2 vector)
    // {
    //     return new Vector2( (vector.x != 0f) ? Mathf.Sign(vector.x) : 0f,
    //                         (vector.y != 0f) ? Mathf.Sign(vector.y) : 0f);
    // }

    private enum ControllerType
    {
        Translate,
        AddForce,
        Velocity
    }
}
