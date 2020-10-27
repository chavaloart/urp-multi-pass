Shader "Cartoon/Cartoon Shader Specular Pass"
{
	Properties
	{
		_Gloss("Gloss", Range(1, 300)) = 7
		_SpecularOpacity("Specular Opacity", Range(0, 1)) = 1
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
	}
		SubShader
		{
			Tags {
				"RenderType" = "Transparent"
				"Queue" = "Transparent"
				"RenderPipeline" = "UniversalPipeline"
			}
			Pass
			{
				Cull Off
				Blend One OneMinusSrcAlpha

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				#include "Lighting.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float4 vertex : SV_POSITION;
					float3 normal : NORMAL;
					float3 worldPos : TEXCOORD0;
				};

				float _Gloss;
				float _SpecularOpacity;
				float4 _SpecularColor;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.worldPos = mul(unity_ObjectToWorld, v.vertex);
					o.normal = UnityObjectToWorldNormal(v.normal);
					o.normal = normalize(o.normal);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					float3 lightDir = _WorldSpaceLightPos0.xyz;

					float3 camPos = _WorldSpaceCameraPos;
					float3 fragToCam = camPos - i.worldPos;
					float3 viewDir = normalize(fragToCam);

					float3 viewReflection = reflect(-viewDir, i.normal);

					float specularFalloff = max(0, dot(viewReflection, lightDir));
					specularFalloff = pow(specularFalloff, _Gloss);
					specularFalloff *= _SpecularOpacity;

					return specularFalloff;
				}
				ENDCG
			}
		}
}