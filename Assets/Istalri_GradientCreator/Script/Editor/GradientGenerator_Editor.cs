//copyright Istalri Design
//https://www.artstation.com/istalri
//https://twitter.com/Istalri_Design
//Version 1.5

using UnityEngine;
using UnityEditor;

namespace GradientCreator.Editor
{
    [CustomPropertyDrawer(typeof(GradientUsageAttribute))]
    public class GradientGenerator_Editor : EditorWindow
    {

        [MenuItem("Window/Gradient Creator")]
        public static void ShowWindow()
        {
            GetWindow<GradientGenerator_Editor>(false, "Gradient Creator", true);
        }

        //Properties
        private Gradient gradient = new Gradient();
        private AnimationCurve curveR = AnimationCurve.Linear(0, 0, 1, 1);
        private AnimationCurve curveG = AnimationCurve.Linear(0, 0, 1, 1);
        private AnimationCurve curveB = AnimationCurve.Linear(0, 0, 1, 1);
        private AnimationCurve curveA = AnimationCurve.Linear(0, 0, 1, 1);
        private int resolution = 256;
        private string path;
        private string fileName = "GradientTexture";
        private bool success = false;
        private bool buttonPress = false;
        private bool isFolderSet = false;
        private bool invertCurve = false;
        private bool[] export = { false, true };
        private state currentState = state.Menu;

        private enum state
        {
            Menu,
            Gradient,
            Curve,
        }

        private void OnGUI()
        {
            GUIStyle error = new GUIStyle(EditorStyles.boldLabel);
            error.fontStyle = FontStyle.Bold;
            error.fontSize = 12;
            error.richText = true;


            switch (currentState)
            {
                case state.Menu:
                    Menu();
                    break;
                case state.Gradient:
                    GradientGeneratorMenu(error);
                    break;
                case state.Curve:
                    GradientFromCurveMenu(error);
                    break;
                default:
                    Menu();
                    break;
            }
        }

        private void Menu()
        {
            GUILayout.Space(15.0f);
            if (GUILayout.Button("Gradient Generator"))
            {
                currentState = state.Gradient;
                invertCurve = true;
            }

            GUILayout.Space(5.0f);
            if (GUILayout.Button("Gradient From Curve"))
            {
                currentState = state.Curve;
                invertCurve = false;
            }
        }

        private void GradientFromCurveMenu(GUIStyle error)
        {
            GUILayout.Label("Gradient From Curve Creator", EditorStyles.boldLabel);
            GUILayout.Space(5.0f);
            if (fileName == "")
            {
                GUILayout.Label("<color=red>File name not set!</color>", error);
            }
            GUILayout.Label("File Name : ");
            fileName = GUILayout.TextField(fileName);
            GUILayout.Space(20.0f);

            curveR = EditorGUILayout.CurveField("Curve Red Channel", curveR, Color.red, new Rect());
            curveG = EditorGUILayout.CurveField("Curve Green Channel", curveG, Color.green, new Rect());
            curveB = EditorGUILayout.CurveField("Curve Blue Channel", curveB, Color.blue, new Rect());
            curveA = EditorGUILayout.CurveField("Curve Alpha Channel", curveA, Color.white, new Rect());
            GUILayout.Space(15.0f);

            invertCurve = EditorGUILayout.Toggle("Invert Curve", invertCurve);
            resolution = EditorGUILayout.IntField("Texture Resolution :", resolution);
            GUILayout.Space(5.0f);
            if (!isFolderSet)
            {
                GUILayout.Label("<color=red>Export Folder not set!</color>", error);
            }
            if (GUILayout.Button("Select Export Folder"))
            {
                string absolutePath = EditorUtility.OpenFolderPanel("Register Path", "", "");
                if (absolutePath.StartsWith(Application.dataPath))
                {
                    path = "Assets" + absolutePath.Substring(Application.dataPath.Length);
                }
                Debug.Log("New Path : " + path);
                isFolderSet = true;
            }
            if (isFolderSet)
            {
                GUILayout.Label(path, EditorStyles.label);
            }

            GUILayout.Space(10.0f);

            export[0] = EditorGUILayout.Toggle("Asset", export[0]);
            export[1] = EditorGUILayout.Toggle("png", export[1]);
            GUILayout.Space(25.0f);
            if (GUILayout.Button("Generate Gradient") && isFolderSet)
            {
                buttonPress = true;
                success = GradientGenerator.CreateGradientTextureFromCurve(curveR, curveG, curveB, curveA, resolution, path, fileName, invertCurve, export);
            }
            if (success)
            {
                GUILayout.Label("<color=green>Generation success! :)</color>", error);
            }
            if (buttonPress && !success)
            {
                GUILayout.Label("Generating...", EditorStyles.boldLabel);
            }

            GUILayout.Space(5.0f);
            if (GUILayout.Button("Back to Menu"))
            {
                currentState = state.Menu;
            }
        }

        private void GradientGeneratorMenu(GUIStyle error)
        {
            GUILayout.Label("Texture 1D Gradient Creator", EditorStyles.boldLabel);
            GUILayout.Space(5.0f);
            if (fileName == "")
            {
                GUILayout.Label("<color=red>File name not set!</color>", error);
            }
            GUILayout.Label("File Name : ");
            fileName = GUILayout.TextField(fileName);
            GUILayout.Space(30.0f);


            GradientUsageAttribute colorUsage = new GradientUsageAttribute(true);
            GUIContent label = new GUIContent("Gradient :");
            gradient = EditorGUI.GradientField(new Rect(3, 70, position.width - 7, 25), label, gradient, colorUsage.hdr);
            GUILayout.Space(9.0f);

            invertCurve = EditorGUILayout.Toggle("Invert Gradient", invertCurve);
            resolution = EditorGUILayout.IntField("Texture Resolution :", resolution);
            GUILayout.Space(5.0f);
            if (!isFolderSet)
            {
                GUILayout.Label("<color=red>Export Folder not set!</color>", error);
            }
            if (GUILayout.Button("Select Export Folder"))
            {
                string absolutePath = EditorUtility.OpenFolderPanel("Register Path", "", "");
                if (absolutePath.StartsWith(Application.dataPath))
                {
                    path = "Assets" + absolutePath.Substring(Application.dataPath.Length);
                }
                Debug.Log("New Path : " + path);
                isFolderSet = true;
            }
            if (isFolderSet)
            {
                GUILayout.Label(path, EditorStyles.label);
            }

            GUILayout.Space(10.0f);

            export[0] = EditorGUILayout.Toggle("Asset", export[0]);
            export[1] = EditorGUILayout.Toggle("png", export[1]);
            GUILayout.Space(25.0f);
            if (GUILayout.Button("Generate Gradient") && isFolderSet)
            {
                buttonPress = true;
                success = GradientGenerator.CreateGradientTexture(gradient, resolution, path, fileName, invertCurve, export);
            }
            if (success)
            {
                GUILayout.Label("<color=green>Generation success! :)</color>", error);
            }
            if (buttonPress && !success)
            {
                GUILayout.Label("Generating...", EditorStyles.boldLabel);
            }

            GUILayout.Space(5.0f);
            if (GUILayout.Button("Back to Menu"))
            {
                currentState = state.Menu;
            }
        }
    }
}