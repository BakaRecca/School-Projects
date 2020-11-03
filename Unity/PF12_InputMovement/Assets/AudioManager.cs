using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager instance = null;

    private AudioSource sfxSource;

    private void Awake()
    {
        if (instance == null)
            instance = this;
        else if (instance != this)
            Destroy(gameObject);
        
        DontDestroyOnLoad(gameObject);

        GetAllComponents();
    }

    private void GetAllComponents()
    {
        sfxSource = transform.Find("AudioSources").Find("SFX").GetComponent<AudioSource>();
    }

    public void PlaySFX(AudioClip clip)
    {
        sfxSource.clip = clip;
        sfxSource.pitch = UnityEngine.Random.Range(0.95f, 1.05f);
        sfxSource.Play();
    }
}
