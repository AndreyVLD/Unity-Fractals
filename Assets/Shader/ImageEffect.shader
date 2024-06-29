Shader "Custom/ImageEffect"
{
    Properties
    {
        _Offset("Offset", Vector) = (-1,-0.5,0,0)
        _Scale("Scale", float) = 2
        _MaxIter("Max Iterations", int) = 255
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
            int _MaxIter;

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

            float4 getColorRed(uint iter)
			{
				if (iter == _MaxIter)
					return float4(0,0,0,1);
				float t = iter / (float)_MaxIter;
				return float4(t, t*t, t*t*t, 1);
			}

            float3 getColorRainbow(uint iter)
            {
                if (iter == _MaxIter || iter <= 0)
					return float4(0,0,0,1);
                float i = iter % 16;
                switch(i)
                {
                    case 0: return float3(66, 30, 15);
                    case 1: return float3(25, 7, 26);
                    case 2: return float3(9, 1, 47);
                    case 3: return float3(4, 4, 73);
                    case 4: return float3(0, 7, 100);
                    case 5: return float3(12, 44, 138);
                    case 6: return float3(24, 82, 177);
                    case 7: return float3(57, 125, 209);
                    case 8: return float3(134, 181, 229);
                    case 9: return float3(211, 236, 248);
                    case 10: return float3(241, 233, 191);
                    case 11: return float3(248, 201, 95);
                    case 12: return float3(255, 170, 0);
                    case 13: return float3(204, 128, 0);
                    case 14: return float3(153, 87, 0);
                    case 15: return float3(106, 52, 3);
                }
                
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
           
               uint iter = mandelbrot(input.uv,_MaxIter);
               return float4(getColorRainbow(iter).xyz/255,1);
            }
            ENDCG
        }
    }
}
