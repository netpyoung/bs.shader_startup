Shader "ch18/7" {
	Properties {
            _BumpMap ("NormalMap", 2D) = "bump" {}
            _Cube ("Cube", Cube) = "" {}
            _SPColor ("Specular Color", Color) = (1, 1, 1, 1)
            _SPPower ("Specular Power", Range(50, 300)) = 150
            _SPMulti ("Specular Multiply", Range(1, 10)) = 3
	}

	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }

                CGPROGRAM
                #pragma surface surf WaterSpecular alpha:fade

                sampler2D _BumpMap;
                samplerCUBE _Cube;
                float4 _SPColor;
                float _SPPower;
                float _SPMulti;

		struct Input {
                        float2 uv_BumpMap;
                        float3 worldRefl;
                        float3 viewDir;
                        INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
                     // normal
                     float3 normal1 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap + _Time.x * 0.1));
                     float3 normal2 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap - _Time.x * 0.1));
                     o.Normal = (normal1 + normal2) / 2;


                     float3 refcolor = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));

                     // rim
                     float rim = saturate(dot(o.Normal, IN.viewDir));
                     rim = pow(1 - rim, 1.5);

                     o.Emission = refcolor * rim * 2;
                     o.Alpha = saturate(rim + 0.5);

                }

                float4 LightingWaterSpecular(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {
                       float3 H = normalize(lightDir + viewDir);
                       float spec = saturate(dot(H, s.Normal));
                       spec = pow(spec, _SPPower);

                       float4 finalColor;
                       finalColor.rgb = spec * _SPColor.rgb * _SPMulti;
                       finalColor.a = s.Alpha + spec;
                       return finalColor;
                }
		ENDCG
	}
}
