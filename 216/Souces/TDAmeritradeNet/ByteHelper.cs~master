using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Web;

namespace TDAmeritradeNet
{
    public static class ByteHelper
    {
        /// <summary>
        /// this method requires "allow unsafe code" checked in project's Build options. for more discussion, visit http://stackoverflow.com/questions/283456/byte-array-pattern-search
        /// </summary>
        /// <param name="Haystack"></param>
        /// <param name="Needle"></param>
        /// <returns></returns>
        public static unsafe long IndexOf(this byte[] Haystack, byte[] Needle)
        {
            fixed (byte* H = Haystack)
            fixed (byte* N = Needle)
            {
                long i = 0;
                for (byte* hNext = H, hEnd = H + Haystack.LongLength; hNext < hEnd; i++, hNext++)
                {
                    bool Found = true;
                    for (byte* hInc = hNext, nInc = N, nEnd = N + Needle.LongLength;
                         Found && nInc < nEnd;
                         Found = *nInc == *hInc, nInc++, hInc++) ;
                    if (Found) return i;
                }
                return -1;
            }
        }

        /// <summary>
        /// this method requires "allow unsafe code" checked in project's Build options. for more discussion, visit http://stackoverflow.com/questions/283456/byte-array-pattern-search
        /// </summary>
        /// <param name="Haystack"></param>
        /// <param name="Needle"></param>
        /// <returns></returns>
        public static unsafe List<int> IndexesOf(this byte[] Haystack, byte[] Needle)
        {
            var Indexes = new List<int>();
            fixed (byte* H = Haystack)
            fixed (byte* N = Needle)
            {
                int i = 0;
                for (byte* hNext = H, hEnd = H + Haystack.LongLength; hNext < hEnd; i++, hNext++)
                {
                    bool Found = true;
                    for (byte* hInc = hNext, nInc = N, nEnd = N + Needle.LongLength;
                         Found && nInc < nEnd;
                         Found = *nInc == *hInc, nInc++, hInc++) ;
                    if (Found) Indexes.Add(i);
                }
                return Indexes;
            }
        }

        public static byte[] ConvertHexStringToByteArray(string hexString)
        {
            if (hexString.Length%2 != 0)
            {
                throw new ArgumentException(String.Format(CultureInfo.InvariantCulture,
                                                          "The binary key cannot have an odd number of digits: {0}",
                                                          hexString));
            }

            var HexAsBytes = new byte[hexString.Length/2];
            for (int index = 0; index < HexAsBytes.Length; index++)
            {
                string byteValue = hexString.Substring(index*2, 2);
                HexAsBytes[index] = byte.Parse(byteValue, NumberStyles.HexNumber, CultureInfo.InvariantCulture);
            }

            return HexAsBytes;

            //Dictionary<string, byte> hexindex = new Dictionary<string, byte>();
            //for (byte i = 0; i < 255; i++)
            //    hexindex.Add(i.ToString("X2"), i);

            //List<byte> hexres = new List<byte>();
            //for (int i = 0; i < hexString.Length; i += 2)
            //    hexres.Add(hexindex[hexString.Substring(i, 2)]);

            //return hexres.ToArray();
        }

        public static string ConvertToString(this byte[] b)
        {
            if (b != null)
            {
                return HttpUtility.UrlDecode(System.Text.Encoding.UTF8.GetString(b));
            }
            return string.Empty;
        }

        public static string ConvertToString(this byte[] b, ref int offset, int size)
        {
            if (size <= 0) return string.Empty;

            if (b.Length <= offset || offset < 0)
            {
                offset = -1;
                return string.Empty;
            }

            var b1 = new byte[size];
            Buffer.BlockCopy(b, offset, b1, 0, size);
            offset = offset + size;
            string s = System.Text.Encoding.UTF8.GetString(b1);
            return HttpUtility.UrlDecode(s);
        }

        public static string ConvertToByte(this byte[] b, ref int offset)
        {
            if (b.Length <= offset || offset < 0)
            {
                offset = -1;
                return string.Empty;
            }

            const int blockSize = 1;
            var b1 = new byte[blockSize];
            Buffer.BlockCopy(b, offset, b1, 0, blockSize);
            offset = offset + blockSize;
            string s = System.Text.Encoding.UTF8.GetString(b1);
            return HttpUtility.UrlDecode(s);
        }

        public static string ConvertToChar(this byte[] b, ref int offset)
        {
            if (b.Length <= offset || offset < 0)
            {
                offset = -1;
                return string.Empty;
            }

            const int blockSize = 2;
            var b1 = new byte[blockSize];
            Buffer.BlockCopy(b, offset, b1, 0, blockSize);
            offset = offset + blockSize;
            string s = System.Text.Encoding.UTF8.GetString(b1);
            return HttpUtility.UrlDecode(s.Trim('\0'));
        }

        public static bool ConvertToBoolean(this byte[] b, ref int offset)
        {
            try
            {
                if (b.Length <= offset || offset < 0)
                {
                    offset = -1;
                    return false;
                }

                const int blockSize = 1;
                var b1 = new byte[4];
                Buffer.BlockCopy(b, offset, b1, 0, blockSize);
                offset = offset + blockSize;
                return BitConverter.ToBoolean(b1, 0);
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("Failed to Convert Boolean - bytes:{0},  offset{1}", BitConverter.ToString(b), offset));
            }
        }
        
        public static float ConvertToFloat(this byte[] b, ref int offset)
        {
            try
            {
                if (b.Length <= offset || offset < 0)
                {
                    offset = -1;
                    return 0;
                }

                const int blockSize = 4;
                var b1 = new byte[blockSize];
                Buffer.BlockCopy(b, offset, b1, 0, blockSize);
                offset = offset + blockSize;
                Array.Reverse(b1);
                return BitConverter.ToSingle(b1, 0);
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("Failed to Convert Float - bytes:{0},  offset{1}", BitConverter.ToString(b), offset));
            }
        }

        public static int ConvertToShort(this byte[] b, ref int offset)
        {
            try
            {
                if (b.Length <= offset || offset < 0)
                {
                    offset = -1;
                    return 0;
                }

                const int blockSize = 2;
                var b1 = new byte[blockSize];
                Buffer.BlockCopy(b, offset, b1, 0, blockSize);
                offset = offset + blockSize;
                Array.Reverse(b1);
                return BitConverter.ToInt16(b1, 0);
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("Failed to Convert Short - bytes:{0},  offset{1}", BitConverter.ToString(b), offset));
            }
        }

        public static int ConvertToInt32(this byte[] b)
        {
            try
            {
                const int blockSize = 4;
                var b1 = new byte[blockSize];
                Buffer.BlockCopy(b, 0, b1, 0, b.Length);
                Array.Reverse(b1);
                return BitConverter.ToInt32(b1, 0);
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("Failed to Convert Int32 - bytes:{0}", BitConverter.ToString(b)));
            }
        }

        public static int ConvertToInt32(this byte[] b, ref int offset)
        {
            try
            {
                if (b.Length <= offset || offset < 0)
                {
                    offset = -1;
                    return 0;
                }

                const int blockSize = 4;
                var b1 = new byte[blockSize];
                Buffer.BlockCopy(b, offset, b1, 0, blockSize);
                offset = offset + blockSize;
                Array.Reverse(b1);
                return BitConverter.ToInt32(b1, 0);
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("Failed to Convert Int32 - bytes:{0},  offset{1}", BitConverter.ToString(b), offset));
            }
        }

        public static int ConvertToColumnNumber(this byte[] b, ref int offset)
        {
            try
            {
                if (b.Length <= offset || offset < 0)
                {
                    offset = -1;
                    return 0;
                }

                const int blockSize = 1;
                var b1 = new byte[4];
                Buffer.BlockCopy(b, offset, b1, 0, blockSize);
                offset = offset + blockSize;
                return BitConverter.ToInt32(b1, 0);
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("Failed to Convert ColumnNumber - bytes:{0},  offset{1}", BitConverter.ToString(b), offset));
            }
        }

        public static int ConvertToErrorCode(this byte[] b, ref int offset)
        {
            try
            {
                if (b.Length <= offset || offset < 0)
                {
                    offset = -1;
                    return 0;
                }

                const int blockSize = 1;
                var b1 = new byte[4];
                Buffer.BlockCopy(b, offset, b1, 0, blockSize);
                offset = offset + blockSize;
                return BitConverter.ToInt32(b1, 0);
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("Failed to Convert ErrorCode - bytes:{0},  offset{1}", BitConverter.ToString(b), offset));
            }
        }

        public static long ConvertToLong(this byte[] b, ref int offset)
        {
            try
            {
                if (b.Length <= offset || offset < 0)
                {
                    offset = -1;
                    return 0;
                }

                const int blockSize = 8;
                var b1 = new byte[blockSize];
                Buffer.BlockCopy(b, offset, b1, 0, blockSize);
                offset = offset + blockSize;
                Array.Reverse(b1);
                return BitConverter.ToInt64(b1, 0);
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("Failed to Convert Long - bytes:{0},  offset{1}", BitConverter.ToString(b), offset));
            }
        }

        public static byte[] NextBytes(this byte[] b, ref int offset, int length)
        {
            try
            {
                var nb = new byte[length];
                Buffer.BlockCopy(b, offset, nb, 0, length);
                offset = offset + length;
                return nb;
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("NextBytes failed - bytes:{0},  offset: {1}", BitConverter.ToString(b), offset));
            }
        }

        public static byte[] RemoveBeginning(this byte[] b, int count)
        {
            int size = b.Length - count;
            if (size > 0)
            {
                var n = new byte[b.Length - count];
                Buffer.BlockCopy(b, count, n, 0, b.Length - count);
                return n;
            }
            else
            {
                throw new FormatException(string.Format("The byte array size ({0}) is too small - length: {1}", b.Length, size));
            }
        }

        public static List<byte[]> SplitBy(this byte[] b, byte[] delimiter)
        {
            int delSize = delimiter.Length;
            List<int> idx = b.IndexesOf(delimiter);
            var msgBlocks = new List<byte[]>();
            int k = 0;

            foreach (int l in idx)
            {
                int bsize = l - k;
                var d1 = new byte[bsize];
                Buffer.BlockCopy(b, k, d1, 0, bsize);
                msgBlocks.Add(d1);
                k = l + delSize; // for next offset
            }

            if (b != null && b.Length != k)
            {
                // Find bytes remaining
                int s2 = b.Length - k;
                var remainingBytes = new byte[s2];
                Buffer.BlockCopy(b, k, remainingBytes, 0, s2);
                msgBlocks.Add(remainingBytes);
                //Debug.Print("Byte Left: {0}", BitConverter.ToString(remainingBytes));
            }

            return msgBlocks;
        }
        
        public static List<byte[]> SplitBy(this byte[] b, byte[] delimiter, ref byte[] remaining)
        {
            int delSize = delimiter.Length;
            List<int> idx = b.IndexesOf(delimiter);
            var msgBlocks = new List<byte[]>();
            int k = 0;

            foreach (int l in idx)
            {
                int bsize = l - k;
                var d1 = new byte[bsize];
                Buffer.BlockCopy(b, k, d1, 0, bsize);
                msgBlocks.Add(d1);
                k = l + delSize; // for next offset
            }

            if (b != null && b.Length != k)
            {
                // Find bytes remaining
                int s2 = b.Length - k;
                var remainingBytes = new byte[s2];
                Buffer.BlockCopy(b, k, remainingBytes, 0, s2);
                remaining = remainingBytes;

                //Debug.Print("Byte Left: {0}", BitConverter.ToString(remainingBytes));
            }
            else
            {
                remaining = null;
            }

            return msgBlocks;
        }

        public static byte[] Append(this byte[] oldBytes, byte[] newBytes)
        {
            byte[] b = null;

            if (oldBytes != null)
            {
                b = new byte[oldBytes.Length + newBytes.Length];
                Buffer.BlockCopy(oldBytes, 0, b, 0, oldBytes.Length);
                Buffer.BlockCopy(newBytes, 0, b, oldBytes.Length, newBytes.Length);
            }
            else
            {
                b = new byte[newBytes.Length];
                Buffer.BlockCopy(newBytes, 0, b, 0, newBytes.Length);
            }

            return b;
        }

        public static byte[] Append(this byte[] oldBytes, byte[] newBytes, int countNewBytes)
        {
            byte[] b = null;

            if (oldBytes != null)
            {
                b = new byte[oldBytes.Length + countNewBytes];
                Buffer.BlockCopy(oldBytes, 0, b, 0, oldBytes.Length);
                Buffer.BlockCopy(newBytes, 0, b, oldBytes.Length, countNewBytes);
            }
            else
            {
                b = new byte[countNewBytes];
                Buffer.BlockCopy(newBytes, 0, b, 0, countNewBytes);
            }

            return b;
        }

        public static byte[] Decompress(this byte[] b)
        {
            var firstTwo = new byte[] {b[0], b[1]};
            var header = new byte[] {0x78, 0x9C};

            if (firstTwo.SequenceEqual(header))
            {
                var ms = new MemoryStream(b, 2, b.Length - 2); // Strip off headers
                byte[] decompressedBytes = null;
                using (var stream = new DeflateStream(ms, CompressionMode.Decompress))
                {
                    decompressedBytes = ReadToEnd(stream);
                }
                return decompressedBytes;
            }
            else
            {
                throw new InvalidDataException("Invalid GZip stream");
            }
        }

        public static string ConvertToDecompressedString(this byte[] compressBytes)
        {
            //http://softdeveloping.blogspot.com/2012/01/example-of-compressing-and.html

            // Strip off 78-9C byte
            //MemoryStream ms = new MemoryStream(compressBytes, 2, compressBytes.Length - 2);
            //Debug.Print("Compress length: {0}", ms.Length);
            ////MemoryStream output = new MemoryStream();

            string decompressed = string.Empty;

            //byte[] decompressedBytes = null;
            //using (var stream = new DeflateStream(ms, CompressionMode.Decompress))
            //{
            //    decompressedBytes = ReadToEnd(stream);
            //}

            //Debug.Print("DeCompress length: {0}", decompressedBytes.Length);
            //List<int> idx = decompressedBytes.IndexesOf(new byte[] { 0x02 });
            //Debug.Print("Deliminator #: {0}", idx.Count);

            //List<byte[]> msgBlocks = new List<byte[]>();
            //int k = 0;

            //// If there are multiple data, seperate by end deliminator FF-0A
            //foreach (var l in idx)
            //{
            //    int bsize = l - k;
            //    byte[] d1 = new byte[bsize];
            //    Buffer.BlockCopy(decompressedBytes, k, d1, 0, bsize);
            //    msgBlocks.Add(d1);
            //    k = l + 1;  // Adding 2 because we skip FF-OA byte array
            //}


            byte[] decompressedBytes = compressBytes.Decompress();
            var msgBlocks = decompressedBytes.SplitBy(new byte[] {0x02});
            var sb = new List<string>();
            foreach (var msgBlock in msgBlocks)
            {
                string msgString = Encoding.UTF8.GetString(msgBlock);
                sb.Add(msgString);
            }

            return string.Join(";", sb);
        }

        //public static string ConvertToDecompressedString2(this byte[] compressBytes)
        //{
        //    string strResult = "";
        //    int totalLength = 0;
        //    byte[] writeData = new byte[4096];
        //    Stream inflaterInputStream = new InflaterInputStream(new MemoryStream(compressBytes));

        //    try
        //    {
        //        while (true)
        //        {
        //            int size = inflaterInputStream.Read(writeData, 0, writeData.Length);
        //            if (size > 0)
        //            {
        //                totalLength += size;
        //                strResult += System.Text.Encoding.ASCII.GetString(writeData, 0, size);
        //            }
        //            else
        //            {
        //                break;
        //            }
        //        }
        //        inflaterInputStream.Flush();
        //        inflaterInputStream.Close();
        //        return strResult;
        //    }
        //    catch
        //    {
        //        return string.Empty;
        //    }
        //}

        public static byte[] ToDecompressBytes(this byte[] compressedBytes)
        {
            // Create a GZIP stream with decompression mode.
            // ... Then create a buffer and write into while reading from the GZIP stream.

            var output = new MemoryStream();
            using (var compressedStream = new MemoryStream(compressedBytes))
            using (var zipStream = new GZipStream(compressedStream, CompressionMode.Decompress))
            {
                zipStream.CopyTo(output);
                zipStream.Close();
                output.Position = 0;
                return output.ToArray();
            }
        }

        public static bool IsStreamOrSnapshot(this byte[] b)
        {
            int i = 0;
            string headerId = b.ConvertToByte(ref i);
            return (headerId == "S") || (headerId == "N");
        }
        
        public static StreamingServiceType GetStreamingType(this byte[] b)
        {
            int i = 0;

            try
            {
                string headerId = b.ConvertToByte(ref i);

                if (headerId == "H")
                {
                    return StreamingServiceType.HeartBeat;
                }

                int msgLength = b.ConvertToShort(ref i);

                if (headerId == "N" && msgLength == 3)
                {
                    return StreamingServiceType.StreamerServer;
                }

                int sid = b.ConvertToShort(ref i);

                switch (sid)
                {
                    case 1:
                        if (headerId == "S")
                        {
                            return StreamingServiceType.L1QuoteStreaming;
                        }
                        return StreamingServiceType.L1QuoteSnapshot;

                    case 5:
                        return StreamingServiceType.TimeSales;

                    case 27:
                        return StreamingServiceType.News;

                    //case 28:
                    //    return StreamingServiceType.NewsHistory;

                    case 81:
                        return StreamingServiceType.L2NYSEBook;

                    case 82:
                        return StreamingServiceType.NYSE_Chart;

                    case 83:
                        return StreamingServiceType.NASDAQ_Chart;

                    case 85:
                        return StreamingServiceType.INDEX_Chart;

                    case 87:
                        return StreamingServiceType.L2TotalViewL2;

                    case 90:
                        return StreamingServiceType.AccountActivity;

                    case 100:
                        return StreamingServiceType.StreamerServer;

                    default:
                        //Debug.Print("Sid: {0} couldn't be found", sid);
                        return StreamingServiceType.NotDefined;
                }
            }
            catch (Exception e)
            {
                return StreamingServiceType.Error;
            }
        }

        public static byte[] ReadToEnd(System.IO.Stream stream)
        {
            long originalPosition = 0;

            if (stream.CanSeek)
            {
                originalPosition = stream.Position;
                stream.Position = 0;
            }

            try
            {
                var readBuffer = new byte[4096];

                int totalBytesRead = 0;
                int bytesRead;

                while ((bytesRead = stream.Read(readBuffer, totalBytesRead, readBuffer.Length - totalBytesRead)) > 0)
                {
                    totalBytesRead += bytesRead;

                    if (totalBytesRead == readBuffer.Length)
                    {
                        int nextByte = stream.ReadByte();
                        if (nextByte != -1)
                        {
                            var temp = new byte[readBuffer.Length*2];
                            Buffer.BlockCopy(readBuffer, 0, temp, 0, readBuffer.Length);
                            Buffer.SetByte(temp, totalBytesRead, (byte) nextByte);
                            readBuffer = temp;
                            totalBytesRead++;
                        }
                    }
                }

                byte[] buffer = readBuffer;
                if (readBuffer.Length != totalBytesRead)
                {
                    buffer = new byte[totalBytesRead];
                    Buffer.BlockCopy(readBuffer, 0, buffer, 0, totalBytesRead);
                }
                return buffer;
            }
            finally
            {
                if (stream.CanSeek)
                {
                    stream.Position = originalPosition;
                }
            }
        }
    }
}