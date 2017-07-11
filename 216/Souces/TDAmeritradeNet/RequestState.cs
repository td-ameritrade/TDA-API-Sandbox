using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class RequestState: IDisposable
    {
        // This class stores the state of the request. 
        public int Id { get; set; }
        private const int BUFFER_SIZE = 65535;
        public StringBuilder RequestData;
        public byte[] BufferRead = new byte[BUFFER_SIZE * 10];
        public HttpWebRequest WebRequest;
        public HttpWebResponse WebResponse;
        public Stream ResponseStream;
        public Decoder StreamDecode = Encoding.UTF8.GetDecoder();
        private bool _disposed;

        public RequestState()
        {
            BufferRead = new byte[BUFFER_SIZE * 10];
            RequestData = new StringBuilder("");
            WebRequest = null;
            WebResponse = null;
            ResponseStream = null;

            Id = this.GetHashCode();

            Debug.Print("ReqestState Created with Id: {0}", Id);
        }

        public void Dispose()
        {
            Dispose(true);

            // Use SupressFinalize in case a subclass 
            // of this type implements a finalizer.
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            // If you need thread safety, use a lock around these  
            // operations, as well as in your methods that use the resource. 
            if (!_disposed)
            {
                if (disposing)
                {
                    if (this.WebRequest != null)
                    {
                        this.WebRequest.Abort();
                    }
                    if (this.WebResponse != null)
                    {
                        this.WebResponse.Dispose();
                    }
                    if (this.ResponseStream != null && this.ResponseStream.CanRead)
                    {
                        this.ResponseStream.Flush();
                        this.ResponseStream.Close();
                        this.ResponseStream.Dispose();
                    }
                    this.BufferRead = null;

                    Console.WriteLine("RequestState Disposed: Id: {0}", Id);
                }

                // Indicate that the instance has been disposed.
                _disposed = true;
            }
        }
    }
}
