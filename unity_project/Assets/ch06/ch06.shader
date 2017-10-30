Shader "ch06/1" {
	Properties {
                _MainTex ("Albedo (RGB)", 2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Standard

                sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
                     fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                     // o.Emission = IN.uv_MainTex.x;
                     // o.Emission = IN.uv_MainTex.y;
                     o.Emission = float3(IN.uv_MainTex.x, IN.uv_MainTex.y, 0);
                     o.Alpha = c.a;
		}
		ENDCG
	}
}
