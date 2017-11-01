유니티 쉐이더 스타트업
http://vielbooks.com/235

example : https://drive.google.com/uc?id=0B10G1-ySdDd1VVZiQzQyRll4RlE&export=download
password : utshader576


## ch04
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

```
#pragma surface surf Standard fullforwardshadows noambient
```


## ch05
texture 2개 lerp

## ch06
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



# ch07

vertex color



# ch08

metallic chart
https://docs.unity3d.com/Manual/StandardShaderMaterialCharts.html


Shader Calibration Scene
https://www.assetstore.unity3d.com/en/#!/content/25422


_BumpMap 변수 이름은, 다른 내장 쉐이더에서 쓰고 있기에, 호환성을 위해 맞춰주자


DXT5nm - NormalMap 품질을 저하를 막기 위해 만든 AG파일 포멧.
R과G의 퀄리티를 최대한 보전, A, G에 넣어 저장.
NormalMap의 X,Y로 계산되며, Z는 삼각함수를 이용하여 수학적으로 추출.
fixed3 n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));


Occlusion : 구석진 부분 추가 음영처리.
환경광(Ambient Color)가 닿지 않는 부분을 Ambient Occlusion이라 부름.

Occlusion 기능을 넣기 위해, 텍스쳐를 한장 더 사용하는것은 용량 낭비가 있으므로, 다른 곳에 찡겨넣는 것도 생각해보자(메인텍스쳐 알파라던가).

# ch09

``` shader
struct SurfaceOutputStandard {
    fixed3 Albedo;
    fixed3 Normal;
    fixed3 Emission;
    half Metallic;
    half Smoothness;
    half Occlusion;
    half Alpha;
}
```

``` shader
struct SurfaceOutput {
    fixed3 Albedo;
    fixed3 Normal;
    fixed3 Emission;
    half Specular; // specular range.
    half Gloss; // specular power.
    half Alpha;
}
```

BlinnPhong 쉐이더에는 _SpecColor 변수가 필요하다.


# ch10
![img](https://upload.wikimedia.org/wikipedia/commons/7/71/Sine_cosine_one_period.svg)


# ch11
float4 LightingTest(SurfaceOutput s, float3 lightDir, float atten)

lightDir - (뒤집힌)조명벡터
atten : attenuation - 감쇠

# ch12

BRDF(Bidirectional Reflectance Distribute Function)

같은 광원일지라도 각도가 작으면  스펙큘러가 훨씬 밝게 보이는 현상.
Fresnel
- 빛이 서로 다른 굴절률을 갖는 매질의 경계면을 통과할 때의 반사

http://www.gamedevforever.com/35
http://hwan0123.tistory.com/entry/프레넬-방정식

```
float3 viewDir; 뷰의 방향
float4 color:Color; 보간된 버텍스 칼라
float4 screenPos; 스크린 공간상의 위치
float3 worldPos; 월드 공간상의 위치
float3 worldRefl; o.Normal이 없는경우, 월드 반사 벡터(diffuse쉐이더 참조)
float3 worldNormal; o.Normal이 없는경우, 월드 노멀벡터
float3 worldRefl; INTERNAL_DATA o.Normal이 있는 경우, 월드 반사벡터 포함.
픽셀당 노멀맵에 기초하여, 반사 벡터를 얻으려면 WorldReflectionVector(IN, o.Normal).(Reflect-Bumped쉐이더 참조)
float3 worldNormal; INTERNAL_DATA o.Normal이 있는 경우, 월드 노말벡터 포함.
픽셀당 노멀맵에 기초하여, 노말 벡터를 얻으려면 WorldNormalVector(IN, o.Normal).
```


# ch13
_SpecColor는 이미 유니티에서 쓰고 있다.

# ch14
# ch15
# ch16
# ch17
# ch18
# ch19
