Shader "Cartoon/Cartoon Shader Diffuse"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_AmbientColor("Ambient Color", Color) = (0,0,0,1)
		_ShadowSoftness("Shadow Softness", Range(0,1)) = 0.1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque"
				"RenderPipeline" = "UniversalPipeline"
			}
			Pass
			{


				Stencil
				{
					Ref 4
					Comp always
					Pass replace
					ZFail keep
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
		}
}