유니티 쉐이더 스타트업
http://vielbooks.com/235

example : https://drive.google.com/uc?id=0B10G1-ySdDd1VVZiQzQyRll4RlE&export=download
password : utshader576



Albedo : 물체 고유 색깔.
Diffuse : 빛에 의한 색상. normal영향을 받는.
Specular : 빛에 의해 하이라이트.
Emission : 자체발광색, 빛의 간섭 없이 순수한 색상 연산 볼 때.


noambient : ambient color를 끈다.
Window/Lighting/Settings
[Scene]
Environment
 - Environment Reflections
   - Source : `Custom`

#pragma surface surf Standard fullforwardshadows noambient

# 05
texture 2개 lerp

# 06
texture uv, 시간에 따른 변화

float4 _Time; (x, y, z, w) = (t/20, t, t * 2, t * 3)
float4 _SinTime; (x, y, z, w) = (t/8, t/4, t/2, t)
float4 _CosTime; (x, y, z, w) = (t/8, t/4, t/2, t)
float4 unity_DeltaTime; (x, y, z, w) = (dt, 1/dt, smoothDt, 1/smoothDt)


		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }

Queue 태그
Transparent - 이 렌더 큐는 _Geometry_와 AlphaTest 후에 뒤부터 순서대로(back-to-front) 렌더링됩니다. 알파 블렌딩하는 것 (즉, 깊이 버퍼에 기록하지 않는 쉐이더)은 모두 여기에 있어야 합니다(유리, 파티클 효과).


		#pragma surface surf Standard alpha:fade

alpha or alpha:auto - Will pick fade-transparency (same as alpha:fade) for simple lighting functions, and premultiplied transparency (same as alpha:premul) for physically based lighting functions.
alpha:fade - Enable traditional fade-transparency.
alpha:premul - Enable premultiplied alpha transparency.

Scene 창의 산그림 Animated Material 활성화

# 07
vertex color

# 08
metallic chart
https://docs.unity3d.com/Manual/StandardShaderMaterialCharts.html


Shader Calibration Scene
https://www.assetstore.unity3d.com/en/#!/content/25422


_BumpMap 변수 이름은, 다른 내장 쉐이더에서 쓰고 있기에, 호환성을 위해 맞춰주자


DXT5nm - NormalMap 품질을 저하를 막기 위해 만든 AG파일 포멧.
R과G의 퀄리티를 최대한 보전, A, G에 넣어 저장.
NormalMap의 X,Y로 계산되며, Z는 삼각함수를 이용하여 수학적으로 추출.
fixed3 n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
