Shader "ch13/1" {
	Properties {
                _MainTex ("Albedo (RGB)", 2D) = "white" {}
                _BumpMap("NormalMap", 2D) = "bump" {}
                _SpecCol ("Specular Color", Color) = (1, 1, 1, 1)
                _SpecPower ("Specular Power", Range(10, 200)) = 100
                _GlossTex ("Gloss Tex", 2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Test

                sampler2D _MainTex;
                sampler2D _BumpMap;
                sampler2D _GlossTex;
                float4 _SpecCol;
                float _SpecPower;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float2 uv_GlossTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
                     fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                     fixed3 n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
                     fixed4 g = tex2D(_GlossTex, IN.uv_GlossTex);

                     o.Albedo = c.rgb;
                     o.Normal = n;
                     o.Gloss = g.a;
                     o.Alpha = c.a;
		}

                float4 LightingTest(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {

                       // lambert
                       float ndotl = saturate(dot(s.Normal, lightDir));
                       float3 Diffuse = ndotl * s.Albedo * _LightColor0.rgb * atten;

                       // specular
                       float3 H = normalize(lightDir + viewDir);
                       float spec = saturate(dot(H, s.Normal));
                       spec = pow(spec, _SpecPower);
                       float3 SpecColor = spec * _SpecCol.rgb * s.Gloss;

                       // rim
                       float rim = abs(dot(viewDir, s.Normal));
                       float inv_rim = 1 - rim;
                       float3 RimColor = pow(inv_rim, 6) * float3(0.5, 0.5, 0.5);

                       // fake spec using rim
                       float3 FakeSpecColor = pow(rim, 50) * float3(1, 0, 0) * s.Gloss;

                       // final
                       float4 final;
                       // final.rgb = Diffuse.rgb + SpecColor.rgb + RimColor.rgb;
                       final.rgb = Diffuse.rgb + SpecColor.rgb + RimColor.rgb + FakeSpecColor.rgb;

                       final.a = s.Alpha;
                       return final;
                }
		ENDCG
	}
}
