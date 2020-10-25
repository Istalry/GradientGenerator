//copyright Istalri Design
//https://www.artstation.com/istalri
//https://twitter.com/Istalri_Design
//Version 1.5

using UnityEngine;
using System.Linq.Expressions;
using System.Net.Http.Headers;
#if UNITY_EDITOR
using UnityEditor;
#endif
using System.IO;


namespace GradientCreator
{
    public static class GradientGenerator
    {
#if UNITY_EDITOR
        /// <summary>
        /// Generate an texture asset from a gradient
        /// </summary>
        /// <param name="gradient">The gradient</param>
        /// <param name="resolution">The resolution of th texture</param>
        /// <param name="path">The path to save the texture</param>
        /// <param name="name">The name of the file to save</param>
        /// <param name="invert">The order in witch read the gradient</param>
        /// <param name="export">The format of the file to export</param>
        /// <returns>Return true if it's a sucess</returns>
        public static bool CreateGradientTexture(Gradient gradient, int resolution, string path, string name, bool invert, bool[] export)
        {
            //Create texture and variables
            Texture2D gradientTexture = new Texture2D(resolution, 1, TextureFormat.RGBAFloat, false, false);
            gradientTexture.filterMode = FilterMode.Bilinear;
            gradientTexture.wrapMode = TextureWrapMode.Clamp;
            Color[] colors = new Color[resolution];

            //loop trough the gradient to get the pixel color
            for (int i = 0; i < resolution; i++)
            {
                float percent;
                if (invert)
                    percent = (resolution - (float)i) / resolution;
                else
                    percent = (float)i / resolution;
                Color newColor = gradient.Evaluate(percent);
                colors[i] = newColor;
            }
            
            return CompressAndExportTexture(path, name, export, gradientTexture, colors);
        }

        /// <summary>
        /// Generate an texture asset from a gradient
        /// </summary>
        /// <param name="R">The curve for the channel Red of the texture</param>
        /// <param name="G">The curve for the channel Green of the texture</param>
        /// <param name="B">The curve for the channel Blue of the texture</param>
        /// <param name="A">The curve for the channel Alpha of the texture</param>
        /// <param name="resolution">The resolution of th texture</param>
        /// <param name="path">The path to save the texture</param>
        /// <param name="name">The name of the file to save</param>
        /// <param name="invert">The order in witch read the gradient</param>
        /// <param name="export">The format of the file to export</param>
        /// <returns>Return true if it's a sucess</returns>
        public static bool CreateGradientTextureFromCurve(AnimationCurve R, AnimationCurve G, AnimationCurve B, AnimationCurve A, int resolution, string path, string name, bool invert, bool[] export)
        {
            //Create texture and variables
            Texture2D gradientTexture = new Texture2D(resolution, 1, TextureFormat.RGBAFloat, false, true);
            gradientTexture.filterMode = FilterMode.Bilinear;
            gradientTexture.wrapMode = TextureWrapMode.Clamp;
            Color[] colors = new Color[resolution];

            //loop trough the curves to get the pixel color
            for (int i = 0; i < resolution; i++)
            {
                float percent;
                if (invert)
                    percent = (resolution - (float)i) / resolution;
                else
                    percent = (float)i / resolution;
                Color newColor = new Color(R.Evaluate(percent), G.Evaluate(percent), B.Evaluate(percent), A.Evaluate(percent));
                colors[i] = newColor;
            }

            return CompressAndExportTexture(path, name, export, gradientTexture, colors);
        }

        /// <summary>
        /// Create an asset from a texture2D
        /// </summary>
        /// <param name="path">The path to know where register the asset</param>
        /// <param name="name">The name of the asset</param>
        /// <param name="export">The format of the asset</param>
        /// <param name="gradientTexture">The texture2D</param>
        /// <param name="colors">The array of pixels colors</param>
        /// <param name="maxvalue">The max intensity of the color</param>
        /// <returns>Return try if it's a success</returns>
        private static bool CompressAndExportTexture(string path, string name, bool[] export, Texture2D gradientTexture, Color[] colors)
        {
            //Loop through all colors to get the max intensity
            float maxvalue = 0;
            for (int j = 0; j < colors.Length; j++)
            {
                float intensity = (colors[j].r + colors[j].g + colors[j].b) / 3.00f;
                if (intensity > maxvalue)
                {
                    maxvalue = intensity;
                }
            }

            //Compress the color to be able to export in png
            Texture2D compressGradientTexture = gradientTexture;
            compressGradientTexture.filterMode = FilterMode.Bilinear;
            compressGradientTexture.wrapMode = TextureWrapMode.Clamp;
            Color[] compressColors = colors;

            for (int k = 0; k < colors.Length; k++)
            {
                compressColors[k] = new Color(colors[k].r / maxvalue, colors[k].g / maxvalue, colors[k].b / maxvalue, colors[k].a);
            }

            //Set colors to the pixels texture
            gradientTexture.SetPixels(colors, 0);
            gradientTexture.Apply();

            compressGradientTexture.SetPixels(compressColors, 0);
            compressGradientTexture.Apply();


            //Export the texture
            if (export[0])
            {
                AssetDatabase.CreateAsset(gradientTexture, path + "/" + name + "_" + maxvalue.ToString("00.00") + ".asset");
                AssetDatabase.SaveAssets();
                Debug.Log(path + "/" + name + ".asset");
            }
            if (export[1])
            {
                File.WriteAllBytes(path + "/" + name + "_" + maxvalue.ToString("00.00") + ".png", compressGradientTexture.EncodeToPNG());
                Debug.Log(path + "/" + name + "_" + maxvalue.ToString("00.00") + ".png");
            }

            //Refresh explorer
            UnityEditor.AssetDatabase.Refresh();

            //Edit png meta to set the image as clamp
            if(export[1])
            {
                string fullpath = path + "/" + name + "_" + maxvalue.ToString("00.00") + ".png" + ".meta";
                string[] meta = File.ReadAllLines(fullpath);
                meta[36] = "    wrapU: 1";
                meta[37] = "    wrapV: 1";
                meta[38] = "    wrapW: 1";
                File.WriteAllLines(fullpath, meta);
                UnityEditor.AssetDatabase.Refresh();
            }


            Resources.UnloadUnusedAssets();
            return true;
        }
#endif
    }
}



