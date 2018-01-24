Shader "ch14/warp" {
	Properties {
                _MainTex ("Albedo (RGB)", 2D) = "white" {}
                _BumpMap ("NormalMap", 2D) = "white" {}
                _RampTex ("RampTex", 2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

                cull back
                CGPROGRAM
		#pragma surface surf Warp noambient

                sampler2D _MainTex;
                sampler2D _BumpMap;
                sampler2D _RampTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};

		void surf (Input IN, inout SurfaceOutput o) {
                     fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                     float n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
                     o.Normal = n;
                     o.Albedo = c.rgb;
                     o.Alpha = c.a;
		}

                // float4 LightingWarp(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {
                //        float3 H = normalize(lightDir + viewDir);
                //        float spec = saturate(dot(s.Normal, H));

                //        float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

                //        float4 ramp = tex2D(_RampTex, float2(ndotl, 0.1));

                //        float4 final;
                //        final.rgb = (s.Albedo.rgb * ramp.rgb) + (ramp.rgb * 0.1);
                //        final.a = s.Alpha;
                //        return final;
                // }

                float4 LightingWarp(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {
                       float rim = abs(dot(s.Normal, viewDir));
                       float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
                       float4 ramp = tex2D(_RampTex, float2(ndotl, rim));

                       float4 final;
                       final.rgb = (s.Albedo.rgb * ramp.rgb) + (ramp.rgb * 0.1);
                       final.a = s.Alpha;
                       return final;
                }
		ENDCG
	}
}
