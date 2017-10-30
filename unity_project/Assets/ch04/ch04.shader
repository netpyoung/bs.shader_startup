Shader "ch04/1" {
	Properties {
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows noambient

		struct Input {
			float4 color : COLOR;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			o.Albedo = float3(1, 0, 0);
			//o.Emission = float3(1, 0, 0);
			o.Alpha = 1;
		}
		ENDCG
	}
}
