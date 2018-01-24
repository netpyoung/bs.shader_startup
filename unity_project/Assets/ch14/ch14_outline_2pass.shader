Shader "ch14/outline_2pass" {
	Properties {
                _MainTex ("Albedo (RGB)", 2D) = "white" {}
                _BumpMap ("NormalMap", 2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

                // 1st
                cull front
		CGPROGRAM
		#pragma surface surf NoLight vertex:vert noshadow noambient

                sampler2D _MainTex;

                void vert(inout appdata_full v) {
                     v.vertex.xyz = v.vertex.xyz + v.normal.xyz * 0.01;
                }

		struct Input {
			float4 color: COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) {
		}

                float4 LightingNoLight(SurfaceOutput o, float3 lightDir, float atten) {
                       return float4(0, 0, 0, 1);
                }

		ENDCG

                // 2nd
                cull back
                CGPROGRAM
		#pragma surface surf Toon

                sampler2D _MainTex;
                sampler2D _BumpMap;

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

                float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten) {
                       float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
                       // ndotl = ndotl * 5;
                       // ndotl = ceil(ndotl) / 5;

                       if (ndotl > 0.7) {
                          ndotl = 1;
                       }
                       else {
                         ndotl = 0.3;
                       }

                       float4 final;
                       final.rgb = s.Albedo * ndotl * _LightColor0.rgb;
                       final.a = s.Alpha;

                       return final;
                }
		ENDCG
	}
}
