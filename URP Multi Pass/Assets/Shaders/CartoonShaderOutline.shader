Shader "Cartoon/Cartoon Shader Outline"
{
	Properties
	{
		_OutlineExtrusion("Outline Extrusion", float) = 0.05
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
		[HideInInspector]_Cull("__cull", Float) = 1.0
	}
		SubShader
	{
		Tags { 
			"RenderType" = "Opaque"
			"RenderPipeline" = "UniversalPipeline"
		}

		Pass {

			Cull[_Cull]

			Stencil
			{
				Ref 4
				Comp notequal
				Fail keep
				Pass replace
			}


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
	}
}