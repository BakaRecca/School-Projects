using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor.Experimental.GraphView;
using UnityEngine;
using UnityEngine.WSA;

public class CollisionController : RaycastController
{
    [SerializeField] protected CollisionInfo collisionInfo;

    protected void HorizontalRaycastCheck(ref Vector2 velocity)
    {
        Vector2 direction = Vector2.right * Mathf.Sign(velocity.x);
        float distance = Mathf.Abs(velocity.x) + SkinWidth;

        for (int i = 0; i < horizontalRayCount; i++)
        {
            Vector2 origin = ((int)direction.x == -1) ? raycastOrigins.bottomLeft : raycastOrigins.bottomRight;
            origin += Vector2.up * (horizontalRaySpacing * i);

            RaycastHit2D hit = Physics2D.Raycast(origin, direction, distance, collisionMask);

            float debugExtra = 8f;
            Vector2 debugOrigin = origin;
            Vector2 debugVelocity = direction * (distance + debugExtra);
            Color debugColor = new Color(0f, 1f ,1f, 1f);

            Debug.DrawRay(debugOrigin, debugVelocity, debugColor);

            if (hit)
            {
                if (hit.distance == 0)
                    continue;

                velocity.x = (hit.distance - SkinWidth) * direction.x;
                distance = hit.distance;

                collisionInfo.left = (int)direction.x == -1;
                collisionInfo.right = (int)direction.x == 1;
            }
        }
    }
    
    protected void VerticalRaycastCheck(ref Vector2 velocity)
    {
        Vector2 direction = Vector2.up * Mathf.Sign(velocity.y);
        float distance = Mathf.Abs(velocity.y) + SkinWidth;

        for (int i = 0; i < verticalRayCount; i++)
        {
            Vector2 origin = ((int)direction.y == -1) ? raycastOrigins.bottomLeft : raycastOrigins.topLeft;
            origin += Vector2.right * (verticalRaySpacing * i + velocity.x);

            RaycastHit2D hit = Physics2D.Raycast(origin, direction, distance, collisionMask);

            float debugExtra = 8f;
            Vector2 debugOrigin = origin;
            Vector2 debugVelocity = direction * (distance + debugExtra);
            Color debugColor = new Color(0f, 1f ,1f, 0.25f);

            Debug.DrawRay(debugOrigin, debugVelocity, debugColor);

            if (hit)
            {
                if (hit.distance == 0)
                    continue;

                velocity.y = (hit.distance - SkinWidth) * direction.y;
                distance = hit.distance;
                
                collisionInfo.below = (int)direction.y == -1;
                collisionInfo.above = (int)direction.y == 1;
            }
        }
    }
    
    
    [System.Serializable]
    public struct CollisionInfo
    {
        [SerializeField] public bool above, below, left, right;

        public void Reset()
        {
            above = false;
            below = false;
            left = false;
            right = false;
        }
    }
}
