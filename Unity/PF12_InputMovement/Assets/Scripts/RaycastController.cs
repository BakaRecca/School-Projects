using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor.Experimental.GraphView;
using UnityEngine;
using UnityEngine.WSA;

[RequireComponent(typeof(BoxCollider2D))]
public class RaycastController : MonoBehaviour
{
    protected BoxCollider2D boxCollider;
    
    [Header("Collision")]
    [SerializeField] protected LayerMask collisionMask;

    protected const float SkinWidth = 0.01f;
    protected float horizontalRaySpacing;
    protected float verticalRaySpacing;
    protected int horizontalRayCount;
    protected int verticalRayCount;
    
    protected RaycastOrigins raycastOrigins;

    private const int TileSize = 8;

    protected virtual void Awake()
    {
        boxCollider = GetComponent<BoxCollider2D>();

        horizontalRayCount = Mathf.CeilToInt(boxCollider.size.y / TileSize) + 1;
        verticalRayCount = Mathf.CeilToInt(boxCollider.size.x / TileSize) + 1;

        CalculateRaySpacing();
    }

    protected void UpdateRaycastOrigins()
    {
        Bounds bounds = boxCollider.bounds;
        bounds.Expand(SkinWidth * -2f);
        
        raycastOrigins.bottomLeft = new Vector2(bounds.min.x, bounds.min.y);
        raycastOrigins.bottomRight = new Vector2(bounds.max.x, bounds.min.y);
        raycastOrigins.topLeft = new Vector2(bounds.min.x, bounds.max.y);
        raycastOrigins.topRight = new Vector2(bounds.max.x, bounds.max.y);
    }

    protected void CalculateRaySpacing()
    {
        Bounds bounds = boxCollider.bounds;
        bounds.Expand(SkinWidth * -2f);

        horizontalRayCount = Mathf.Clamp(horizontalRayCount, 2, int.MaxValue);
        verticalRayCount = Mathf.Clamp(verticalRayCount, 2, int.MaxValue);

        horizontalRaySpacing = bounds.size.y / (horizontalRayCount - 1);
        verticalRaySpacing = bounds.size.x / (verticalRayCount - 1);
    }

    protected struct RaycastOrigins
    {
        public Vector2 topLeft, topRight, bottomLeft, bottomRight;
    }
}
