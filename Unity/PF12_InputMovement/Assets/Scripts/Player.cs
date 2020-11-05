using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#pragma warning disable 649

public class Player : MonoBehaviour
{
    private InputController inputController;
    private PlayerController controller;
    private Animator animator;
    private SpriteRenderer spriteRenderer;

    [Header("Audio")]
    [SerializeField] private AudioClip[] audioClips;

    [Header("Properties")]
    [SerializeField] private bool inAir;

    [SerializeField] private int jumpCounter;
    private const int jumpBufferMax = 8;

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
        if (jumpCounter > 0)
        {
            jumpCounter--;
            
            Debug.Log($"jumpCounter: {jumpCounter}");
            
            if (controller.Jump(true))
            {
                AudioManager.instance.PlaySFX(audioClips[(int) SFXClip.Jump]);
                Debug.Log($"JUMPED! - jumpCounter: {jumpCounter}");
                jumpCounter = 0;
            }
        }
        else if (jumpCounter < 0)
            controller.Jump(false);

        controller.CalculateVelocity();
        controller.Move();
    }

    private void CheckInput()
    {
        // INPUT
        controller.SetDirection(inputController.GetDirectionInput());
        // controller.Jump(Input.GetButton("Jump"));
        if (Input.GetButtonDown("Jump"))
        {
            jumpCounter = jumpBufferMax;
            
            // if (controller.Jump(true))
            //     AudioManager.instance.PlaySFX(audioClips[(int) SFXClip.Jump]);
        }
        else if (!Input.GetButton("Jump"))
            jumpCounter = -1;
        //     controller.Jump(false);
    }

    private void UpdateAnimations()
    {
        animator.SetFloat("SpeedX", Math.Abs(controller.Velocity.x));
        animator.SetBool("In Air", controller.IsInAir());

        if (inAir && !controller.IsInAir())
        {
            animator.SetTrigger("Landed");
            inAir = false;
        }

        inAir = controller.IsInAir();

        if (controller.Velocity.x != 0f)
            spriteRenderer.flipX = controller.Velocity.x < 0f;
    }
    
    private enum SFXClip : int
    {
        Jump
    }
}
