Shader "Custom/ChromaKeyGreen_Unlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _KeyColor ("Key Color", Color) = (0,1,0,1)
        _Threshold ("Threshold", Range(0,1)) = 0.35
        _Smooth    ("Smooth",    Range(0,1)) = 0.10
        _Despill   ("Despill",   Range(0,1)) = 0.30
    }
    SubShader
    {
        Tags{ "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
        LOD 100

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _KeyColor;
            float _Threshold, _Smooth, _Despill;

            struct appdata {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv  : TEXCOORD0;
            };

            v2f vert (appdata v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv  = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float colorDistance(float3 a, float3 b){
                float3 aa = pow(a, 2.2);
                float3 bb = pow(b, 2.2);
                return distance(aa, bb);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c = tex2D(_MainTex, i.uv);

                float d = colorDistance(c.rgb, _KeyColor.rgb);

                float alpha_raw = saturate( (d - _Threshold) / max(_Smooth, 1e-4) );

                float spill = 1.0 - alpha_raw;             
                float g_reduced = lerp(c.g, max(c.r, c.b), _Despill * spill);
                c.g = g_reduced;

                c.a *= alpha_raw;
                clip(c.a - 1e-3);

                return c;
            }
            ENDCG
        }
    }
}
