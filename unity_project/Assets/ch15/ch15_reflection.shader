Shader "ch15/reflection" {
	Properties {
                _MainTex ("Albedo (RGB)", 2D) = "white" {}
                _BumpMap ("NormalMap", 2D) = "white" {}
                _MaskMap ("MaskMap", 2D) = "white" {}
                _Cube ("CubeMap", Cube) = "" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

                CGPROGRAM
		#pragma surface surf Lambert noambient

                sampler2D _MainTex;
                sampler2D _BumpMap;
                sampler2D _MaskMap;
                samplerCUBE _Cube;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float2 uv_MaskMap;
                        float3 worldRefl;
                        INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
                     fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                     float n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
                     float4 re = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
                     fixed4 m = tex2D(_MaskMap, IN.uv_MaskMap);

                     o.Emission = re.rgb * m.r;
                     o.Albedo = c.rgb * (1 - m.r);
                     o.Alpha = c.a;
		}
		ENDCG
	}
}
