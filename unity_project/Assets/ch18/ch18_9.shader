Shader "ch18/9" {
	Properties {
            _BumpMap ("NormalMap", 2D) = "bump" {}
            _Cube ("Cube", Cube) = "" {}
            _SPColor ("Specular Color", Color) = (1, 1, 1, 1)
            _SPPower ("Specular Power", Range(50, 300)) = 150
            _SPMulti ("Specular Multiply", Range(1, 10)) = 3

            _WaveH ("Wave Height", Range(0, 0.05)) = 0.1
            _WaveL ("Wave Length", Range(5, 20)) = 12
            _WaveT ("Wave Timing", Range(0, 10)) = 1

            _Refract ("Refract Strength", Range(0, 0.2)) = 0.1
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

                GrabPass {}

                CGPROGRAM
                #pragma surface surf WaterSpecular vertex:vert

                sampler2D _BumpMap;
                samplerCUBE _Cube;
                float4 _SPColor;
                float _SPPower;
                float _SPMulti;

                float _WaveH;
                float _WaveL;
                float _WaveT;

                float _Refract;

                sampler2D _GrabTexture;

		struct Input {
                        float2 uv_BumpMap;
                        float3 worldRefl;
                        float3 viewDir;
                        float4 screenPos;
                        INTERNAL_DATA
		};

                void vert(inout appdata_full v) {
                     float movement = 0;
                     movement += sin(abs((v.texcoord.x * 2 - 1) * _WaveL) + _Time.y * _WaveT) * _WaveH;
                     movement += sin(abs((v.texcoord.x * 2 - 1) * _WaveL) + _Time.y * _WaveT) * _WaveH;
                     v.vertex.y += movement / 2;
                }

		void surf (Input IN, inout SurfaceOutput o) {
                     // normal
                     float3 normal1 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap + _Time.x * 0.1));
                     float3 normal2 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap - _Time.x * 0.1));
                     o.Normal = (normal1 + normal2) / 2;


                     float3 refcolor = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));

                     // refraction
                     float3 screenUV = (IN.screenPos.xyz / IN.screenPos.w);
                     float3 refraction = tex2D(_GrabTexture, (screenUV.xy + o.Normal.xy * _Refract));

                     // rim
                     float rim = saturate(dot(o.Normal, IN.viewDir));
                     rim = pow(1 - rim, 1.5);

                     o.Emission = (refcolor * rim + refraction) * 0.5;
                     //o.Alpha = saturate(rim + 0.5);
                     o.Alpha = 1;
                }

                float4 LightingWaterSpecular(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {
                       float3 H = normalize(lightDir + viewDir);
                       float spec = saturate(dot(H, s.Normal));
                       spec = pow(spec, _SPPower);

                       float4 finalColor;
                       finalColor.rgb = spec * _SPColor.rgb * _SPMulti;
                       finalColor.a = s.Alpha;
                       return finalColor;
                }
		ENDCG
	}
}
