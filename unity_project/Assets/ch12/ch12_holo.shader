Shader "ch12/holo" {
	Properties {
                _BupMap ("BumpMap", 2D) = "white" {}
                _RimColor ("RimColor", Color) = (1, 1, 1, 1)
                _RimPower ("RimPower", Range(1, 10)) = 3
	}

	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }

		CGPROGRAM
		#pragma surface surf NoLight noambient alpha:fade

                sampler2D _BumpMap;
                float4 _RimColor;
                float _RimPower;

		struct Input {
			float2 uv_BumpMap;
                        float3 viewDir;
                        float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutput o) {
                     fixed3 n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
                     float rim = saturate(dot(o.Normal, IN.viewDir));
                     rim = pow(1 - rim, _RimPower) * _RimColor.rgb;
                     rim = rim + pow(frac(IN.worldPos.g * 3 - _Time.y), 30) * 0.1;
                     o.Emission = float3(0, 1, 0);
                     o.Normal = n;
                     o.Alpha = rim;
		}

                float4 LightingNoLight(SurfaceOutput s, float3 lightDir, float atten) {
                       return float4(0, 0, 0, s.Alpha);
                }
		ENDCG
	}
}
