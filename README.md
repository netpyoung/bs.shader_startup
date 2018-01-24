유니티 쉐이더 스타트업
http://vielbooks.com/235

example : https://drive.google.com/uc?id=0B10G1-ySdDd1VVZiQzQyRll4RlE&export=download
password : utshader576


Free MatCap Shaders



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

어차피 rim에서 가져다 쓰는거고 해서, rim을 가짜 스펙쿨러로 활용하면 가짜로 조명하나 얻는 기분을 느낄 수 있다.


# ch14
PR(Photo Realistic)
NPR(Non-Photo Realistic)

https://en.wikipedia.org/wiki/Cel_shading

## 외곽선
###  2pass
* 노말값을 키워 한번 더 그려준다.
* 2번 그리니 무겁다.
* Plane으로 끝난 오브젝트에는 외곽선 안생김
* 매쉬끼리 침범하거나 찌꺼기 보일 수 있다.
  - 선을 얇게한다.
  - 버텍스 칼라 마스킹 등을 통해 외곽선이 돌출 되지 않도록.
* Hard Edge에는 선이 끊김
  - 모델링 툴에서 smooth 그룹으로 묶어주거나 해야함

### Fresnel
* rim을 뒤집거나, 외곽라인 검출
* 픽셀과 노말과 시선방향의 차이에 따라 계산됨으로, 평면을 가진 오브젝트에는 이상하게 보임.

### Poss Effect


UnityCG.cginc
appdata_base: position, normal and one texture coordinate.
appdata_tan: position, tangent, normal and one texture coordinate.
appdata_full: position, tangent, normal, four texture coordinates and color.



http://www.valvesoftware.com/publications/2007/NPAR07_IllustrativeRenderingInTeamFortress2.pdf

Warped diffuse


# ch15
cubemap
o.Albedo ? o.Emission?
반사는 밝거나 어두운 주변이미지를 반사하는 것이므로, o.Emission에 넣어야한다.


# ch16

float2 sPos = float2(IN.screenPos.x, IN.screenPos.y) / IN.screenPos.w;
float4 Depth = tex2D(_CameraDepthTexture, sPos);

Deferred rendering. - 카메라 깊이버퍼 사용(포워드 렌더링 역시 깊이버퍼를 만들 수 있지만...)

deferred rendering에서는 반투명을 다루기 힘들다.


그림자 쉐이더와 연관되어 있다.

	FallBack "Legacy Shaders/Transparent/VertexLit"


풀 같은 자연물은 주로 AlphaTest(Cutout)쉐이더를 사용.



Opaque 오브젝트는 먼저 그린다.
Transparent 오브젝트는 나중에 그린다.
멀리 있는 것부터 가까운 것까지 차례대로 - alpha shorting
알파소팅을 써봤자, 앞뒤 판정을 제대로 할 수 없으니, 문제는 일어날 수 밖에 없다.
알파블렌딩을 사용하였을 때는 zwrite를 하지 않는다.
이 문제들을 해결하기 위해 각종 방법이 연구되고 있다.


그림자가 나오게 할려면

	FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"


https://docs.unity3d.com/Manual/SL-SurfaceShaders.html - Optional parameters


# ch17

# ch18

https://docs.unity3d.com/Manual/SL-Pass.html

ColorMask


* 2pass 알파블랜딩
  - (Pass 키워드를 사용하여) Vertex/Fragment Shader는 Multi-Pass로 합칠 수 있다.
  - (Pass 키워드는 없이) Surface Shader와 Surface Shader의 Multi-Pass도 가능하다.

* 타이밍 반짝임
* 타들어가는 기능 - dissolve
* 흔들리는 풀 - vertex
* matcap Mateiral
  - Material Capture
  - ViewDir기반 카메라를 회전하지 않는 상황에서 좋은 효과
* 굴절 - Refraction.
  - https://docs.unity3d.com/Manual/SL-GrabPass.html

```
                GrabPass { }
                sampler2D _GrabTexture;
```

* 물
  - Snell's law : 직각으로 내려다보는 각도에 가까워지면 반사보다는 투명함이 더 많이 보임. 시선과 평행해지면, 투과보다는 반사가 많이 일어남


* 물 흔들리는

* 물 굴절

* triplanar 트라이 플래너




# ch19

LOD
VertexLit = 100
Deval, Refective VertexLit = 150
Diffuse = 200
Diffuse Detail, Reflective Bumped Unlit, Reflective Bumped VertexLit = 250
Bumped, Specular = 300
Bumped Specular = 400
Parallax = 500
Parallax Specular = 600


"Queue"
Background - 1000
Geometry - 2000
AlphaTest - 2500
Transparent - 3000
Overlay - 4000


[NoScaleOffset]
[Normal]
[Enum]
[PowerSlider]
[KeywordEnum]
[Gamma]

interpolateview
halfasview
nofowardadd
noambient
novertexlights
noshadow
nolightmap
