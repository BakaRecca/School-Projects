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

    private void Awake ()
    {
        
    }

    enum ControllerType
    {
        Translate,
        AddForce,
        Velocity
    }
}
