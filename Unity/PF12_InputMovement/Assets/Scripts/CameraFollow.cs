using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    [SerializeField] private Transform target;
    [SerializeField] private Vector2 offset;
    private void LateUpdate()
    {
        if (!target)
            return;
        
        transform.position = target.position + new Vector3(offset.x, offset.y, -10f);
    }
}
