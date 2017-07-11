using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class StreamServer
    {
        public int ServiceID { get; set; }
        public int ReturnCode { get; set; }
        public string Description { get; set; }

        public StreamServer()
        {
            // EMPTY
        }

        public StreamServer(byte[] b)
        {
         
            try
            {
                int i = 0;
                var headerId = b.ConvertToByte(ref i);
                var nextStringLength = b.ConvertToShort(ref i);
                var snapshotId = b.ConvertToString(ref i, nextStringLength);
                var msgLength = b.ConvertToInt32(ref i);
                var sid = b.ConvertToShort(ref i);
                var col0 = b.ConvertToColumnNumber(ref i);
                this.ServiceID = b.ConvertToShort(ref i);
                var col1 = b.ConvertToColumnNumber(ref i);
                this.ReturnCode = b.ConvertToShort(ref i);
                var col2 = b.ConvertToColumnNumber(ref i);
                var descriptionLength = b.ConvertToShort(ref i);
                //this.Description = b.ConvertToString(ref i, descriptionLength);
                this.Description = Enum.GetName(typeof (StreamerServerReturnCode), this.ReturnCode);  // this works better
            }
            catch (Exception e)
            {
                throw new FormatException("StreamServer array is not correct...");
            }

        }
    }
}
