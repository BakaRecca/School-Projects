using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputController
{
    // private Vector2 directionInput;

    public Vector2 GetDirectionInput()
    {
        return new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
    }
}
