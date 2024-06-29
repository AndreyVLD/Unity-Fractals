using Unity.VisualScripting;
using UnityEngine;

public class FractControl : MonoBehaviour
{
    // Start is called before the first frame update
    [Header("Material")]
    public Material material;

    [Header("Translate")]
    public float TranslateSpeed = 1.0f;
    public Vector2 offset = new Vector2(-1f, -0.5f);

    [Header("Scale")]
    public float ScaleSpeed = 1.0f;
    public float scale = 1.0f;

    void Start()
    {
        material.SetFloat("_AspectRatio", Screen.width / (float)Screen.height);
    }

    // Update is called once per frame
    void Update()
    {
        if (useInput())
        {
            material.SetVector("_Offset", new Vector4(offset.x, offset.y));
            material.SetFloat("_Scale", scale);
        }
    }

    bool useInput()
    {
        bool used = false;
        Vector2 movement_xy = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
        if (!movement_xy.Equals(Vector2.zero))
        {
            offset += movement_xy.normalized * TranslateSpeed * scale * Time.deltaTime;
            used = true;
        }

        float scroll = Input.GetAxis("Mouse ScrollWheel");
        if (scroll != 0)
        {
            if (scroll > 0)
                scale /= ScaleSpeed;
            else
                scale *= ScaleSpeed;
            used = true;
        }

        if (Input.GetMouseButtonDown(0))
        {
            offset += new Vector2(Input.mousePosition.x/Screen.width - 0.5f,Input.mousePosition.y/Screen.height - 0.5f) * scale;
            used = true;
        }
        offset.x = Mathf.Clamp(offset.x, -2.0f, 2.0f);
        offset.y = Mathf.Clamp(offset.y, -2.0f, 2.0f);
        scale = Mathf.Clamp(scale, 0f, 50.0f);
        return used;
    }
}
