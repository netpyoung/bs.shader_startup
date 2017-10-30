Shader "ch08/2" {
	Properties {
                _MainTex ("Albedo (RGB)", 2D) = "white" {}
                _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
                _MainTex3 ("Albedo (RGB)", 2D) = "white" {}
                _MainTex4 ("Albedo (RGB)", 2D) = "white" {}
                _BumpMap ("NormalMap", 2D) = "white" {}
                _Metallic("Metallic", Range(0, 1)) = 0
                _Smoothness("Smoothness", Range(0, 1)) = 0
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Standard

                sampler2D _MainTex;
                sampler2D _MainTex2;
                sampler2D _MainTex3;
                sampler2D _MainTex4;
                sampler2D _BumpMap;
                float _Metallic;
                float _Smoothness;

		struct Input {
			float2 uv_MainTex;
			float2 uv_MainTex2;
			float2 uv_MainTex3;
			float2 uv_MainTex4;
			float2 uv_BumpMap;
                        float4 color:COLOR;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
                     fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                     fixed4 d = tex2D(_MainTex2, IN.uv_MainTex);
                     fixed4 e = tex2D(_MainTex3, IN.uv_MainTex);
                     fixed4 f = tex2D(_MainTex4, IN.uv_MainTex);

                     o.Albedo = lerp(c.rgb, d.rgb, IN.color.r);
                     o.Albedo = lerp(o.Albedo, e.rgb, IN.color.g);
                     o.Albedo = lerp(o.Albedo, f.rgb, IN.color.b);
                     o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
                     o.Metallic = _Metallic;
                     //o.Smoothness = _Smoothness;
                     o.Smoothness = (IN.color.r * 0.5) * _Smoothness + 0.3;
                     o.Alpha = c.a;
		}
		ENDCG
	}
}
