Shader "ch12/rim" {
	Properties {
                _MainTex ("Albedo (RGB)", 2D) = "white" {}
                _BumpMap ("NormalMap", 2D) = "bump" {}
                _RimColor ("RimColor", Color) = (1, 1, 1, 1)
                _RimPower ("RimPower", Range(1, 10)) = 3
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert

                sampler2D _MainTex;
                sampler2D _BumpMap;
                float4 _RimColor;
                float _RimPower;

		struct Input {
			float2 uv_MainTex;
                        float2 uv_BumpMap;
                        float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
                     fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                     float rim = saturate(dot(o.Normal, IN.viewDir));
                     o.Emission = pow(1 - rim, _RimPower) * _RimColor.rgb;
                     o.Albedo = c.rgb;
                     o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
                     o.Alpha = c.a;
		}
		ENDCG
	}
}
