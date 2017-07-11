using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class StreamingChartBar
    {
        public string Symbol { get; set; }
        public int Sequence { get; set; } // 0-629
        public float Open { get; set; }
        public float High { get; set; }
        public float Low { get; set; }
        public float Close { get; set; }
        public float Volume { get; set; }
        public DateTime TimeStamp { get; set; }

        public StreamingChartBar()
        {
            // EMPTY
        }

        public StreamingChartBar(byte[] b)
        {
            var byteLength = b.Length;
            var days = 0;
            var seconds = 0;
            int i = 0;

            try
            {
                var headerId = b.ConvertToByte(ref i);
                var msgLength = b.ConvertToShort(ref i);
                var sid = b.ConvertToShort(ref i);

                while (i < byteLength)
                {
                    var colNum = b.ConvertToColumnNumber(ref i);

                    switch (colNum)
                    {
                        case 0:
                            var symbolLength = b.ConvertToShort(ref i);
                            this.Symbol = b.ConvertToString(ref i, symbolLength);
                            break;

                        case 1:
                            this.Sequence = b.ConvertToInt32(ref i);
                            break;

                        case 2:
                            this.Open = b.ConvertToFloat(ref i);
                            break;

                        case 3:
                            this.High = b.ConvertToFloat(ref i);
                            break;

                        case 4:
                            this.Low = b.ConvertToFloat(ref i);
                            break;

                        case 5:
                            this.Close = b.ConvertToFloat(ref i);
                            break;

                        case 6:
                            this.Volume = b.ConvertToInt32(ref i);
                            break;

                        case 7:
                            seconds = b.ConvertToInt32(ref i); // Seconds since midnight
                            break;

                        case 8:
                            days = b.ConvertToInt32(ref i); // Days since 1/1/1970
                            this.TimeStamp = DateTime.Today.AddHours(8).AddMinutes(this.Sequence);   // * Use the bar sequence for the time on each bar instead of the time
                            break;
                    }
                }
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("{0} - Stream Chart Bar parsing failed. (content: {1})",
                                                        this.Symbol, BitConverter.ToString(b)));
            }
        }
    }
}