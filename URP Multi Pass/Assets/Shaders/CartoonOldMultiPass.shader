Shader "Cartoon/Cartoon Old Multi Pass"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_AmbientColor("Ambient Color", Color) = (0,0,0,1)
		_ShadowSoftness("Shadow Softness", Range(0,1)) = 0.1

		_Gloss("Gloss", Range(1, 300)) = 7
		_SpecularOpacity("Specular Opacity", Range(0, 1)) = 1
		_SpecularColor("Specular Color", Color) = (1,1,1,1)

		_OutlineExtrusion("Outline Extrusion", float) = 0.02
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
	}
		SubShader
		{		
			Pass
			{
				Tags { "RenderType" = "Opaque"
					"RenderPipeline" = "UniversalPipeline"
				}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				#include "Lighting.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
					float3 normal : NORMAL;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _AmbientColor;
				float _ShadowSoftness;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					o.normal = UnityObjectToWorldNormal(v.normal);
					o.normal = normalize(o.normal);
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					float3 lightDir = _WorldSpaceLightPos0.xyz;

					float ramp = clamp(dot(lightDir, i.normal), 0, 1.0);
					float3 lighting = smoothstep(0, _ShadowSoftness, ramp) + _AmbientColor;

					// sample the texture
					fixed4 col = tex2D(_MainTex, i.uv);

					fixed4 final = col * fixed4(lighting, 1.0);

					// apply fog
					UNITY_APPLY_FOG(i.fogCoord, final);
					return final;
				}
				ENDCG
			}

		Pass {
			Tags {
				"RenderType" = "Opaque"
				"RenderPipeline" = "UniversalPipeline"
			}
			Cull Front

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"


			float4 _OutlineColor;
			float _OutlineExtrusion;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 color : COLOR;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				float4 newPos = input.vertex;

				// normal extrusion technique
				float3 normal = normalize(input.normal);
				newPos += float4(normal, 0.0) * _OutlineExtrusion;

				// convert to world space
				output.pos = UnityObjectToClipPos(newPos);

				output.color = _OutlineColor;
				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				return input.color;
			}


			ENDCG
		}
			Pass
			{
				Tags {
					"RenderType" = "Transparent"
					"Queue" = "Transparent"
					"RenderPipeline" = "UniversalPipeline"
				}

				Cull Off
				Blend One OneMinusSrcAlpha

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

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