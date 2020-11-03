using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    private InputController inputController;
    private PlayerController controller;
    private Animator animator;
    private SpriteRenderer spriteRenderer;

    [SerializeField] private AudioClip[] audioClips;

    private bool inAir;

    private void Awake()
    {
        animator = GetComponent<Animator>();
        spriteRenderer = transform.Find("GFX").Find("Sprite").GetComponent<SpriteRenderer>();
        controller = GetComponent<PlayerController>();
        
        inputController = new InputController();
    }

    private void Update()
    {
        CheckInput();
        UpdateAnimations();
    }
    
    private void FixedUpdate()
    {
        // controller.CalculateVelocity();
        // controller.Move();
        
    }

    private void CheckInput()
    {
        // INPUT
        controller.SetDirection(inputController.GetDirectionInput());
        // controller.Jump(Input.GetButton("Jump"));
        if (Input.GetButtonDown("Jump"))
            controller.Jump(true);
        else if (!Input.GetButton("Jump"))
            controller.Jump(false);
    }

    private void UpdateAnimations()
    {
        animator.SetFloat("SpeedX", Math.Abs(controller.currentVelocity.x));
        animator.SetBool("In Air", controller.IsInAir());

        if (inAir && !controller.IsInAir())
        {
            animator.SetTrigger("Landed");
            inAir = false;
        }

        inAir = controller.IsInAir();

        if (controller.currentVelocity.x != 0f)
            spriteRenderer.flipX = controller.currentVelocity.x < 0f;
    }

    public enum SFXClip : int
    {
        Jump
    }
}
