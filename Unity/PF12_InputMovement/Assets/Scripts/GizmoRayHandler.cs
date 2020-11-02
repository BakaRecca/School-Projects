using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GizmoRayHandler
{
    private List<GizmoRay> rays;

    public GizmoRayHandler()
    {
        rays = new List<GizmoRay>();
    }

    public void ClearGizmoRays()
    {
        rays = new List<GizmoRay>();
    }

    public void AddGizmoRay(Vector2 origin, Vector2 direction, float distance)
    {
        rays.Add(new GizmoRay(origin, direction, distance));
    }
    
    public void AddGizmoRay(GizmoRay ray)
    {
        rays.Add(ray);
    }

    public void DrawGizmos()
    {
        foreach (GizmoRay ray in rays)
        {
            ray.Draw();
        }
    }
}

public struct GizmoRay
{
    private Vector2 origin;
    private Vector2 direction;
    private float distance;
    private Color color;
    
    public GizmoRay(Vector2 origin, Vector2 direction, float distance)
    {
        this.origin = origin;
        this.direction = direction;
        this.distance = distance;
        this.color = Color.magenta;
    }

    public GizmoRay(Vector2 origin, Vector2 direction, float distance, Color color)
    {
        this.origin = origin;
        this.direction = direction;
        this.distance = distance;
        this.color = color;
    }

    public void Draw()
    {
        Gizmos.color = this.color;
        Gizmos.DrawRay(origin, direction * distance);
    }
}
