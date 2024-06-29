using UnityEngine;

public class FractControl : MonoBehaviour
{
    // Start is called before the first frame update
    public Material material;
    void Start()
    {
        material.SetFloat("_AspectRatio", Screen.width / (float)Screen.height);
    }

    // Update is called once per frame
    void Update()
    {
    }
}
