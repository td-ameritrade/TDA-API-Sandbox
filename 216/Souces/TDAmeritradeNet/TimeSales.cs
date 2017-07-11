using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class TimeSales
    {
        public string Symbol { get; set; }
        public DateTime TimeStamp { get; set; }
        public float Price { get; set; }
        public long Volume { get; set; }
        public int Sequence { get; set; }
        public int Updated { get; set; }

        public TimeSales()
        {
            // EMPTY
        }

        public TimeSales(byte[] b)
        {
            var byteLength = b.Length;
            var i = 0;

            try
            {
                var headerId = b.ConvertToByte(ref i);
                var msgLength = b.ConvertToShort(ref i);
                var sid = b.ConvertToShort(ref i);

                int col = 0;

                while (i < byteLength)
                {
                    col = b.ConvertToColumnNumber(ref i);

                    switch (col)
                    {
                        case 0:
                            var symbolLength = b.ConvertToShort(ref i);
                            this.Symbol = b.ConvertToString(ref i, symbolLength);
                            break;

                        case 1:
                            var time = b.ConvertToInt32(ref i);
                            this.TimeStamp = DateTime.Today.AddSeconds(time);
                            break;

                        case 2:
                            this.Price = b.ConvertToFloat(ref i);
                            break;

                        case 3:
                            this.Volume = b.ConvertToLong(ref i) * 100;   // Multiply 100 to the volume
                            break;

                        case 4:
                            this.Sequence = b.ConvertToInt32(ref i);
                            break;

                        default:
                            throw new FormatException("TimeSales Exception: Incorrect column number.");
                            break;

                    }
                }
            }
            catch (Exception e)
            {
                throw new FormatException(string.Format("{0} - TimeSales parsing failed. (content: {1})", this.Symbol, BitConverter.ToString(b)));
            }

        }
    }
}
