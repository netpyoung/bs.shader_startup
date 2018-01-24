Shader "ch18/1" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }

                zwrite on
                ColorMask 0

		CGPROGRAM
		#pragma surface surf NoLight noambient noforwardadd nolightmap novertexlights noshadow

                struct Input {
                       float4 color:COLOR;
                };

                void surf(Input IN, inout SurfaceOutput o) {
                }

                float4 LightingNoLight(SurfaceOutput s, float3 lightDir, float atten) {
                       return float4(0, 0, 0, 0);
                }
                ENDCG


                zwrite off
                CGPROGRAM
                #pragma surface surf Lambert alpha:fade

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = 0.5;
		}
		ENDCG
	}
}
