// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amplify_Gradient"
{
	Properties
	{
		[HDR][NoScaleOffset]_Lut("Lut", 2D) = "white" {}
		[NoScaleOffset]_GrayscaleTexture("GrayscaleTexture", 2D) = "white" {}
		_TilingOffset("TilingOffset", Vector) = (1,1,0,0)
		_Texture2("Texture 2", 2D) = "white" {}
		_Ratio("Ratio", Float) = 2
		_Vector0("Vector 0", Vector) = (0.65,-0.43,-0.15,-0.06)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
			#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
			#else//ASE Sampling Macros
			#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
			#endif//ASE Sampling Macros
			


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			UNITY_DECLARE_TEX2D_NOSAMPLER(_Lut);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture2);
			SamplerState sampler_Texture2;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_GrayscaleTexture);
			uniform float4 _Vector0;
			uniform float4 _TilingOffset;
			SamplerState sampler_GrayscaleTexture;
			SamplerState sampler_Lut;
			uniform float _Ratio;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float temp_output_31_0_g32 = ( 1.0 / 256.0 );
				float temp_output_35_0_g32 = (temp_output_31_0_g32 + (( ( sin( _Time.y ) + 1.0 ) * 0.5 ) - 0.0) * (( 1.0 - temp_output_31_0_g32 ) - temp_output_31_0_g32) / (1.0 - 0.0));
				float2 appendResult45_g32 = (float2(temp_output_35_0_g32 , temp_output_35_0_g32));
				float4 break120 = _Vector0;
				float2 appendResult15 = (float2(break120.x , break120.y));
				float2 appendResult9 = (float2(_TilingOffset.x , _TilingOffset.y));
				float2 appendResult10 = (float2(_TilingOffset.z , _TilingOffset.w));
				float2 texCoord7 = i.ase_texcoord1.xy * appendResult9 + appendResult10;
				float2 panner11 = ( 1.0 * _Time.y * appendResult15 + texCoord7);
				float2 appendResult14 = (float2(break120.z , break120.w));
				float2 panner13 = ( 1.0 * _Time.y * appendResult14 + ( texCoord7 * float2( 0.5,0.5 ) ));
				float smoothstepResult19 = smoothstep( 0.25 , 0.0 , ( SAMPLE_TEXTURE2D( _GrayscaleTexture, sampler_GrayscaleTexture, panner11 ).r * SAMPLE_TEXTURE2D( _GrayscaleTexture, sampler_GrayscaleTexture, panner13 ).r * 2.0 ));
				float smoothstepResult135 = smoothstep( ( SAMPLE_TEXTURE2D( _Texture2, sampler_Texture2, appendResult45_g32 ) * 1.0 ).r , 1.0 , smoothstepResult19);
				float clampResult76_g15 = clamp( smoothstepResult135 , 0.0 , 1.0 );
				float2 appendResult55_g15 = (float2(clampResult76_g15 , clampResult76_g15));
				float2 clampResult90_g15 = clamp( ( appendResult55_g15 + 0.02 ) , float2( 0,0 ) , float2( 1,1 ) );
				
				
				finalColor = ( SAMPLE_TEXTURE2D( _Lut, sampler_Lut, clampResult90_g15 ) * _Ratio );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18400
1410;81;1504;977;2078.242;528.2253;2.481024;True;False
Node;AmplifyShaderEditor.Vector4Node;8;-2853.164,329.5813;Inherit;False;Property;_TilingOffset;TilingOffset;7;0;Create;True;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;16;-2919.749,550.1636;Inherit;False;Property;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;False;0.65,-0.43,-0.15,-0.06;0.65,-0.43,-0.15,-0.06;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;10;-2645.164,409.5813;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-2645.164,297.5813;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;120;-2500.365,542.39;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-2405.164,329.5813;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;139;-1727.738,1274.542;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-2213.164,473.5814;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-2069.164,521.5814;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-2213.164,585.5814;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;140;-1526.213,1292.345;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;11;-1892.526,301.6348;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;-1362.213,1308.345;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-1783.514,578.1146;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1988,-19.24781;Inherit;True;Property;_GrayscaleTexture;GrayscaleTexture;6;1;[NoScaleOffset];Create;True;0;0;False;0;False;dad38cc6b6f620b43981dd3ed405fe7f;dad38cc6b6f620b43981dd3ed405fe7f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;133;-1073.232,752.6764;Inherit;True;Property;_Texture2;Texture 2;8;0;Create;True;0;0;False;0;False;fce2324b8af75e040bb778f950c733f5;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;18;-1349.164,601.5814;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-1493.164,409.5813;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1509.164,169.5813;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-1208.213,1299.345;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1141.164,313.5813;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;138;-616.5056,850.0994;Inherit;False;GradientCurveReader;3;;32;0df0ab10bb85f1f4bb0ae65f426c89a7;0;4;1;SAMPLER2D;;False;10;FLOAT;0;False;36;FLOAT;0;False;39;FLOAT;0;False;1;COLOR;12
Node;AmplifyShaderEditor.SmoothstepOpNode;19;-850.1639,321.5813;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;136;-269.4507,852.1957;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;54;-227.8753,-27.28725;Inherit;False;Property;_Ratio;Ratio;9;0;Create;True;0;0;False;0;False;2;1.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-232.9468,87.10442;Inherit;True;Property;_Lut;Lut;5;2;[HDR];[NoScaleOffset];Create;True;0;0;False;0;False;b14855f698849bd4d86e8e32b9a2ed50;b14855f698849bd4d86e8e32b9a2ed50;False;white;LockedToTexture2D;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SmoothstepOpNode;135;83.1125,360.6913;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;109;487.174,229.6042;Inherit;True;GradientMapper;0;;15;1bed4a3ba1db0fa48a40b65b7847c808;0;3;43;FLOAT;0;False;18;SAMPLER2D;;False;19;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;87;1080.687,-34.69285;Float;False;True;-1;2;ASEMaterialInspector;100;1;Amplify_Gradient;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;True;0
WireConnection;10;0;8;3
WireConnection;10;1;8;4
WireConnection;9;0;8;1
WireConnection;9;1;8;2
WireConnection;120;0;16;0
WireConnection;7;0;9;0
WireConnection;7;1;10;0
WireConnection;15;0;120;0
WireConnection;15;1;120;1
WireConnection;20;0;7;0
WireConnection;14;0;120;2
WireConnection;14;1;120;3
WireConnection;140;0;139;0
WireConnection;11;0;7;0
WireConnection;11;2;15;0
WireConnection;141;0;140;0
WireConnection;13;0;20;0
WireConnection;13;2;14;0
WireConnection;6;0;4;0
WireConnection;6;1;13;0
WireConnection;5;0;4;0
WireConnection;5;1;11;0
WireConnection;142;0;141;0
WireConnection;17;0;5;1
WireConnection;17;1;6;1
WireConnection;17;2;18;0
WireConnection;138;1;133;0
WireConnection;138;10;142;0
WireConnection;19;0;17;0
WireConnection;136;0;138;12
WireConnection;135;0;19;0
WireConnection;135;1;136;0
WireConnection;109;43;54;0
WireConnection;109;18;3;0
WireConnection;109;19;135;0
WireConnection;87;0;109;0
ASEEND*/
//CHKSM=08C6C7A1CDE73F6D58D3B5BE67716142682C6D51