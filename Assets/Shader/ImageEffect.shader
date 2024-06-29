Shader "Custom/ImageEffect"
{
    Properties
    {
        _Offset("Offset", Vector) = (-1,-0.5,0,0)
        _Scale("Scale", float) = 2
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float2 _Offset;
            float _Scale;
            float _AspectRatio;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct FragmentInput
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float mandelbrot(float2 c, uint maxIter)
			{
				float2 z = float2(0,0);
				for (uint i = 0; i < maxIter; i++)
				{
					z = float2(z.x*z.x - z.y*z.y, 2*z.x*z.y) + c;
					if (dot(z,z) > 4)
						return i;
				}
				return maxIter;
			}

            FragmentInput vert (MeshData v)
            {
                FragmentInput o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                float2 centeredUV = v.uv - 0.5;
                centeredUV.x *= _AspectRatio; 

                o.uv = centeredUV * _Scale + _Offset.xy;
                return o;
            }


            float4 frag (FragmentInput input) : SV_Target
            {
           
               return mandelbrot(input.uv,255)/255;
            }
            ENDCG
        }
    }
}
