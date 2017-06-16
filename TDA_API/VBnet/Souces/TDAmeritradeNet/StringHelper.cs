using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public static class StringHelper
    {
        public static IEnumerable<string> BuildSymbolBlocks(IEnumerable<string> symbols, int maxCount, string delim)
        {
            var tmpSymbolsList = new List<string>();
            int i = 0;

            string tmpSymbols = string.Empty;

            if (symbols.Count() < maxCount)
            {
                tmpSymbolsList.Add(string.Join(delim, symbols));
                return tmpSymbolsList;
            }

            foreach (string symbol in symbols)
            {
                if (i < maxCount)
                {
                    tmpSymbols += symbol + delim;
                    i++;
                }

                if (i == maxCount)
                {
                    tmpSymbols = tmpSymbols.Remove(tmpSymbols.Count() - delim.Length, delim.Length);
                    tmpSymbolsList.Add(tmpSymbols);
                    tmpSymbols = string.Empty;
                    i = 0;
                }
            }

            // Clean Symbol Blocks
            if (tmpSymbols.Count() > 1)
            {
                tmpSymbols = tmpSymbols.Remove(tmpSymbols.Count() - delim.Length, delim.Length);
            }

            if (!string.IsNullOrEmpty(tmpSymbols) && tmpSymbols.Length > 0)
            {
                tmpSymbolsList.Add(tmpSymbols);
            }

            return tmpSymbolsList;
        }

        //http://stackoverflow.com/questions/3514740/how-to-split-an-array-into-a-group-of-n-elements-each
        public static T[][] SliceArray<T>(this T[] source, int maxResultElements)
        {
            int numberOfArrays = source.Length / maxResultElements;
            if (maxResultElements * numberOfArrays < source.Length)
            {
                numberOfArrays++;
            }

            T[][] target = new T[numberOfArrays][];
            for (int index = 0; index < numberOfArrays; index++)
            {
                int elementsInThisArray = Math.Min(maxResultElements, source.Length - index * maxResultElements);
                target[index] = new T[elementsInThisArray];
                Array.Copy(source, index * maxResultElements, target[index], 0, elementsInThisArray);
            }
            return target;
        }

        public static List<string> GroupSymbols(this IEnumerable<string> source, int maxResultElements, string seperator)
        {
            var groups = new List<string>();
            var slices = SliceArray(source.ToArray(), maxResultElements);
            foreach (var slice in slices)
            {
                groups.Add(string.Join(seperator, slice));
            }
            return groups;
        }

        /// <summary>
        /// Compresses the string.
        /// </summary>
        /// <param name="text">The text.</param>
        /// <returns></returns>
        public static string CompressString(string text)
        {
            byte[] buffer = Encoding.UTF8.GetBytes(text);
            var memoryStream = new MemoryStream();
            using (var gZipStream = new GZipStream(memoryStream, CompressionMode.Compress, true))
            {
                gZipStream.Write(buffer, 0, buffer.Length);
            }

            memoryStream.Position = 0;

            var compressedData = new byte[memoryStream.Length];
            memoryStream.Read(compressedData, 0, compressedData.Length);

            var gZipBuffer = new byte[compressedData.Length + 4];
            Buffer.BlockCopy(compressedData, 0, gZipBuffer, 4, compressedData.Length);
            Buffer.BlockCopy(BitConverter.GetBytes(buffer.Length), 0, gZipBuffer, 0, 4);
            return Convert.ToBase64String(gZipBuffer);
        }

        /// <summary>
        /// Decompresses the string.
        /// http://dotnet-snippets.com/dns/c-compress-and-decompress-strings-SID612.aspx
        /// </summary>
        /// <param name="compressedText">The compressed text.</param>
        /// <returns></returns>
        public static string DecompressString(string compressedText)
        {
            byte[] gZipBuffer = Convert.FromBase64String(compressedText);
            using (var memoryStream = new MemoryStream())
            {
                int dataLength = BitConverter.ToInt32(gZipBuffer, 0);
                memoryStream.Write(gZipBuffer, 4, gZipBuffer.Length - 4);

                var buffer = new byte[dataLength];

                memoryStream.Position = 0;
                using (var gZipStream = new GZipStream(memoryStream, CompressionMode.Decompress))
                {
                    gZipStream.Read(buffer, 0, buffer.Length);
                }

                return Encoding.UTF8.GetString(buffer);
            }
        }

        public static bool Contains(this string source, string toCheck, StringComparison comp)
        {
            return source.IndexOf(toCheck, comp) >= 0;
        }

        /// <summary>
        /// http://stackoverflow.com/questions/2159026/regex-how-to-get-words-from-a-string-c
        /// </summary>
        /// <param name="source"></param>
        /// <returns></returns>
        public static List<string> ToWordsList(this string source)
        {
            var pattern = new Regex(@"( [^\W_\d]            # starting with a letter
                                                            # followed by a run of either...
                                        ( [^\W_\d] |        #   more letters or
                                        [-'\d](?=[^\W_\d])  #   ', -, or digit followed by a letter
                                        )*
                                        [^\W_\d]            # and finishing with a letter
                                        )",
                                      RegexOptions.IgnorePatternWhitespace);

            return (from Match m in pattern.Matches(source) select m.Groups[1].Value).ToList();
        }
    }
}