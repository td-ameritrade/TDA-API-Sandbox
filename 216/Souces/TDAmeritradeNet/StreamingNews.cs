using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace TDAmeritradeNet
{
    public class StreamingNews
    {
        private static DateTime fromDate = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        public string Symbol { get; set; }
        public DateTime NewsTimeStamp { get; set; }
        public string Source { get; set; }
        public string Headline { get; set; }
        public string NewsUrl { get; set; }
        public string VendorId { get; set; }
        public int NewsCount { get; set; }
        public string Keywords { get; set; }

        public StreamingNews()
        {
            // EMPTY
        }

        public StreamingNews(byte[] b)
        {
            var byteLength = b.Length;
            var i = 0;

            try
            {
                var headerId = b.ConvertToByte(ref i);
                var msgLength = b.ConvertToShort(ref i);
                var sid = b.ConvertToShort(ref i);
                var col0 = b.ConvertToColumnNumber(ref i);
                var symbolLength = b.ConvertToShort(ref i);
                this.Symbol = b.ConvertToString(ref i, symbolLength);

                var col1 = b.ConvertToColumnNumber(ref i);
                var timeStampLength = b.ConvertToShort(ref i);

                this.NewsTimeStamp = fromDate.AddMilliseconds(Convert.ToInt64(b.ConvertToString(ref i, timeStampLength))).ToLocalTime();

                var col2 = b.ConvertToColumnNumber(ref i);
                var dataLength = b.ConvertToShort(ref i);

                byte[] temp1 = new byte[dataLength];
                Buffer.BlockCopy(b, i, temp1, 0, dataLength);
                byte[] decompressed = temp1.Decompress();
                List<byte[]> msgBlocks = decompressed.SplitBy(new byte[] {0x02});

                this.Source = msgBlocks[1].ConvertToString();
                this.Headline = msgBlocks[2].ConvertToString();
                this.NewsUrl = msgBlocks[3].ConvertToString();
                this.VendorId = msgBlocks[4].ConvertToString();
                this.NewsCount = msgBlocks[5].ConvertToInt32();

                // if it has symbol indicator, replace with the previous symbol
                if (this.Headline.Contains(">"))
                {
                    this.Symbol = this.Headline.Split('>')[1].Trim().ToUpper();
                }

                if (msgBlocks.Count >= 7)
                {
                    List<byte[]> keywordBytes = msgBlocks[6].SplitBy(new byte[] {0x03});
                    List<string> words = new List<string>();

                    foreach (var keyword in keywordBytes)
                    {
                        words.Add(keyword.ConvertToString());
                    }
                    this.Keywords = string.Join("; ", words);
                }
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("News ({0}) parsing failed. (content: {1})", this.Symbol, BitConverter.ToString(b)));
            }
        }
    }
}
