using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml;
using System.Xml.Linq;

namespace TDAmeritradeNet
{
    public class XmlToDictionary
    {
        /// <summary>
        /// This uses each node's local name as key value. If you want to append parent's node, use StreamToDictionary2
        /// </summary>
        /// <param name="stream"></param>
        /// <returns></returns>
        public static Dictionary<string, string> StreamToDictionary(Stream stream)
        {
            if (stream == null || !stream.CanRead) return new Dictionary<string, string>();

            var sr = new StreamReader(stream);
            string data = sr.ReadToEnd(); // get string data

            XDocument doc = XDocument.Parse(data);
            var dataDictionary = new Dictionary<string, string>();

            foreach (XElement element in doc.Descendants().Where(p => p.HasElements == false))
            {
                int keyInt = 0;
                string keyName = element.Name.LocalName;

                while (dataDictionary.ContainsKey(keyName))
                {
                    keyName = element.Name.LocalName + "_" + keyInt++;
                }

                dataDictionary.Add(keyName, element.Value);
            }

            return dataDictionary;
        }

        /// <summary>
        /// This appends parent node's local name to the key value
        /// </summary>
        /// <param name="stream"></param>
        /// <returns></returns>
        public static Dictionary<string, string> StreamToDictionary2(Stream stream)
        {
            if (stream == null || !stream.CanRead) return new Dictionary<string, string>();

            var sr = new StreamReader(stream);
            string data = sr.ReadToEnd(); // get string data

            XDocument doc = XDocument.Parse(data);
            var dataDictionary = new Dictionary<string, string>();

            foreach (XElement element in doc.Descendants().Where(p => p.HasElements == false))
            {
                int keyInt = 0;
                string keyName = element.Parent.Name.LocalName + "-" + element.Name.LocalName;

                while (dataDictionary.ContainsKey(keyName))
                {
                    //keyName = element.Name.LocalName + "_" + keyInt++;
                    keyName = keyName + "_" + keyInt++;
                }

                dataDictionary.Add(keyName, element.Value);
            }

            return dataDictionary;
        }

        public static IEnumerable<XmlNode> StreamNodes(string path, string[] tagNames)
        {
            var doc = new XmlDocument();
            using (XmlReader xr = XmlReader.Create(path))
            {
                xr.MoveToContent();
                while (true)
                {
                    if (xr.NodeType == XmlNodeType.Element &&
                        tagNames.Contains(xr.Name))
                    {
                        XmlNode node = doc.ReadNode(xr);
                        yield return node;
                    }
                    else
                    {
                        if (!xr.Read())
                        {
                            break;
                        }
                    }
                }
                xr.Close();
            }
        }
    }
}