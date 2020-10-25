//copyright Istalri Design
//https://www.artstation.com/istalri
//https://twitter.com/Istalri_Design
//Version 1.0


#include "UnityCG.cginc"


float4 gradientMapper (sampler2D lut, float grayscale, float ratio)
{
	float tempGrayscale = clamp(grayscale, 0.0, 1.0);
	float2 uv = clamp(float2(tempGrayscale, tempGrayscale) + float2(0.02, 0.02), 0.0, 1.0);
	float4 color = tex2D(lut, uv);
	color *= ratio;
	return color;
}

float4 gradientCurveReader(sampler2D lutCurve, float position, float lutWidth = 256, float curveRatio = 1)
{
	float ratio = (1.0 / lutWidth);
	float pos = ratio + position * ((1.0 - ratio) - ratio);
	float2 uv = float2(pos,pos);

	float4 col = tex2D(lutCurve, uv);
	return col * curveRatio;
}