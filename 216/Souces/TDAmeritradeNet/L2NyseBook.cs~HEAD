using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class L2NYSEBook
    {
        public string Symbol { get; set; }
        public DateTime TimeStamp { get; set; }

        public L2NYSEBook()
        {
            // empty
        }

        public L2NYSEBook(byte[] b)
        {
            int i = 0;
            try
            {
                var headerId = b.ConvertToByte(ref i);
                var msgLength = b.ConvertToShort(ref i);
                var sid = b.ConvertToShort(ref i);

                var colNum0 = b.ConvertToColumnNumber(ref i);
                var symbolLength = b.ConvertToShort(ref i);
                this.Symbol = b.ConvertToString(ref i, symbolLength);
                Debug.Print("NYSE_BOOK Symbol: {0}", this.Symbol);

                var colNum1 = b.ConvertToColumnNumber(ref i);
                var time = b.ConvertToInt32(ref i);
                this.TimeStamp = DateTime.Today.AddMilliseconds(time);

                // process compressed data below
                var dataLength = b.ConvertToShort(ref i);

                byte[] temp1 = new byte[dataLength]; // create temp. storage for compressed data
                Buffer.BlockCopy(b, i, temp1, 0, dataLength);
                byte[] decompress = temp1.Decompress();

                Debug.Print("NYSE_BOOK Raw Data: {0}", decompress.ConvertToString());
            }
            catch (Exception)
            {
                
                throw;
            }
        }
    }
}
