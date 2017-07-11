using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class StreamingStatusEventArgs: EventArgs
    {
        public StreamingErrorCodes Code { get; set; }
        public string Message { get; set; }
    }

    public enum StreamingErrorCodes
    {
        WebRequestError,
        Disconnected,
        StreamerNotFound,
        NullResponse,
        ResponseException
    }
}
