using UnityEngine;


public class FractControl : MonoBehaviour
{
    // Start is called before the first frame update
    [Header("Material")]
    public Material material;

    [Header("Translate")]
    public float TranslateSpeed = 1.0f;
    public Vector2 offset = new(-1f, -0.5f);

    [Header("Scale")]
    public float ScaleSpeed = 1.0f;
    public float scale = 1.0f;


    private float aspectRatio;
    void Start()
    {
        aspectRatio = Screen.width / (float)Screen.height;
        material.SetFloat("_AspectRatio", aspectRatio);
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
        Vector2 movement_xy = new(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
        if (!movement_xy.Equals(Vector2.zero))
        {
            offset += movement_xy.normalized * scale * TranslateSpeed * Time.deltaTime;
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
            CenterOnMousePosition();
            used = true;
        }
        offset.x = Mathf.Clamp(offset.x, -2.0f, 2.0f);
        offset.y = Mathf.Clamp(offset.y, -2.0f, 2.0f);
        scale = Mathf.Clamp(scale, 2.810247e-05f, 3.0f);
        return used;
    }
    void CenterOnMousePosition()
    {
        Vector3 mousePos = Input.mousePosition;
        Vector2 normalizedMousePos = new Vector2(mousePos.x /Screen.width - 0.5f, mousePos.y/Screen.height - 0.5f);
        normalizedMousePos.x *= aspectRatio;

        // Calculate new offset to center the image on the mouse position
        offset += normalizedMousePos * scale;
    }
}


