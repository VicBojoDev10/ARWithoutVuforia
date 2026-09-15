using System.Collections;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class CameraManager : MonoBehaviour
{
    public RawImage image;
    private WebCamTexture webCamTexture;

    private void Start()
    {
        StartCoroutine(WebCam());
    }

    private IEnumerator WebCam()
    {
        if(WebCamTexture.devices.Length == 0)
        {
            Debug.Log("No hay camaras en el dispositivo");
            yield break;
        }
        if(webCamTexture == null)
            webCamTexture = new WebCamTexture(WebCamTexture.devices[0].name);

        webCamTexture.Play();
        image.texture = webCamTexture;
    }
}
