

Thank you for downloading!!!


Attribution-ShareAlike 4.0 International
Version 1.0
Creator : Jean-Bernard Géron (a.k.a Istalri Design)
https://www.artstation.com/istalri
https://twitter.com/Istalri_Design

You're free to use these file as much as you want :)

Create a Gradient:
1) Open the Gradient Creator window:
	-  Windows > Gradient Creator

2) Chooser a folder and set your gradient as you like.

3) Press Export Button





Use your gradient:

1) Make sure to generate a gradient before ( ͡° ͜ʖ ͡°)

2) Create a shader:
	If it is a custom shader:
		Import the cginc file with the function to use the gradient. 
			#include "Assets\Istalri_GradientCreator\ShaderFunction\GradientMapper.cginc"
		Next, in the fragment shader use the gradientMapper function.
			float4 color = gradientMapper((Sampler2D)gradient, (float)grayscaleValue);

		See the Gradient_Import_Sample in the ShaderSample folder.

	If you use amplify:
		You only need to use the node GradientMapper and fill all the properties.
		You will need to fill the HDR ratio. It's the 4 number at the end of your gradient texture name.
		Since I don't know how to use hdr texture in shader. I compress the hdr to fit the texture. And that's why I need you to remultiply the values.
		See the Amplify_Gradient in the ShaderSample folder.
