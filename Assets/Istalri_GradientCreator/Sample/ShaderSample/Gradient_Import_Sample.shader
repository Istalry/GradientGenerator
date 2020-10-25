//copyright Istalri Design
//https://www.artstation.com/istalri
//https://twitter.com/Istalri_Design
//Version 1.0


Shader "GradientCreator/UnlitSample"
{
	Properties
	{
		_MainTex("Noise", 2D) = "white" {}
		[HDR]_Lut("LUT", 2D) = "black" {}
		_LutCurve("LUT Curve", 2D) = "black" {}
		_HDRratio("HDR Ratio", float) = 1
		_Speed("Movement", Vector) = (0,1,0,0)
	}
		SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100
		Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0


			#include "Assets/Istalri_GradientCreator/ShaderFunction/GradientMapper.cginc"
			#include "UnityCG.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _Lut, _LutCurve;
			float4 _MainTex_ST;
			float4 _Speed;
			float _HDRratio;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}


			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv + (_Time * _Speed.xy));
				float pos = frac(_Time * 0.25);
				float curve = gradientCurveReader(_LutCurve, pos, 256, 1).r;
				float4 color = gradientMapper(_Lut, smoothstep(curve, 1.0, col.r), _HDRratio);
				color.a -= 0.1;
				return color;
			}
			ENDCG
		}
	}
}
