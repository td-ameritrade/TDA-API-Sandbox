using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Xml;
using TDAmeritradeNet;

namespace TDAmeritradeNet
{
    public class WebPostRequest
    {
        //WebRequest webRequest;
        HttpWebRequest webRequest;
        HttpWebResponse webResponse;
        List<string> queryData;

        public WebPostRequest()
        {
            queryData = new List<string>();
        }

        public WebPostRequest(string url)
        {
            webRequest = (HttpWebRequest)WebRequest.Create(url);
            webRequest.ContentType = "application/x-www-form-urlencoded";
            webRequest.Method = "POST";
            webRequest.Timeout = 5000;
            webRequest.ReadWriteTimeout = 5000;
            webRequest.KeepAlive = false;

            //webRequest = WebRequest.Create(url);
            //// Set the encoding type
            //webRequest.ContentType = "application/x-www-form-urlencoded";
            //webRequest.Method = "POST";
            //webRequest.Timeout = 5000;
            //((HttpWebRequest)webRequest).KeepAlive = false;

            queryData = new List<string>();
        }

        public async Task<Stream> GetResponseStreamAsync()
        {
            // Reference: http://msdn.microsoft.com/en-us/library/hh156513.aspx
            //http://msdn.microsoft.com/en-us/library/vstudio/hh191443.aspx
            //http://msdn.microsoft.com/en-us/library/vstudio/hh300224.aspx

            // The download ends up in variable content.
            var content = new MemoryStream();
            
            try
            {
                //var webReq = WebRequest.Create(url);
                //webReq.ContentType = "application/x-www-form-urlencoded";
                //webReq.Method = "POST";
                //webReq.Timeout = 5000;
                //webReq.Proxy = null;
                //((HttpWebRequest)webReq).KeepAlive = false;
                // Build a string containing all the parameters
                //string parameters = String.Join("&", (String[])queryData.ToArray(typeof(string)));
                string parameters = String.Join("&", queryData);
                webRequest.ContentLength = parameters.Length;

                if (webRequest.ContentLength > 0)
                {
                    // For Post Request you first call GetResponseStream and
                    // Post your date/parameter there
                    using (var stream = await webRequest.GetRequestStreamAsync())
                    {
                        using (var streamWriter = new StreamWriter(stream))
                        {
                            streamWriter.Write(parameters);
                        }
                    }
                }

                // **Call GetResponseAsync instead of GetResponse, and await the result.
                // GetResponseAsync returns a Task<WebResponse>.
                using (var response = await webRequest.GetResponseAsync())
                {
                    // Get the data stream that is associated with the specified URL.
                    using (var responseStream = response.GetResponseStream())
                    {
                        // ** Call CopyToAsync instead of CopyTo, and await the response.
                        // CopyToAsync returns a Task, not a Task<T>.
                        await responseStream.CopyToAsync(content);
                    }
                }
            }
            catch (Exception e)
            {
                Debug.Print(string.Format("GetRespoonseStream Exception: {0}", e.Message));
                return content;
            }
            
            // Reset Stream Position
            content.Position = 0;

            // Return the result as a stream.
            return content;
        }


        public void Add(string key, string value)
        {
            queryData.Add(String.Format("{0}={1}", key, HttpUtility.UrlEncode(value)));
        }

        public XmlDocument GetResponseXmlDocument()
        {
            try
            {
                // Build a string containing all the parameters
                //string parameters = String.Join("&", (String[])queryData.ToArray(typeof(string)));
                string parameters = String.Join("&", queryData);
                webRequest.ContentLength = parameters.Length;

                // We write the parameters into the request
                StreamWriter sw = new StreamWriter(webRequest.GetRequestStream());
                sw.Write(parameters);
                sw.Close();

                // Execute the query
                webResponse = (HttpWebResponse)webRequest.GetResponse();
                StreamReader sr = new StreamReader(webResponse.GetResponseStream());
                string content = sr.ReadToEnd();

                //Debug.Print(content);

                XmlDocument xDoc = new XmlDocument();
                xDoc.LoadXml(content);

                return xDoc;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        public string GetResponseString()
        {
            try
            {
                // Build a string containing all the parameters
                //string parameters = String.Join("&", (String[])queryData.ToArray(typeof(string)));
                string parameters = String.Join("&", queryData);
                webRequest.ContentLength = parameters.Length;

                // We write the parameters into the request
                StreamWriter sw = new StreamWriter(webRequest.GetRequestStream());
                sw.Write(parameters);
                sw.Close();

                // Execute the query
                webResponse = (HttpWebResponse)webRequest.GetResponse();
                StreamReader sr = new StreamReader(webResponse.GetResponseStream());
                string content = sr.ReadToEnd();

                return content;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        public Stream GetResponseStream()
        {
            try
            {
                // Build a string containing all the parameters
                //string parameters = String.Join("&", (String[])queryData.ToArray(typeof(string)));
                string parameters = String.Join("&", queryData);
                webRequest.ContentLength = parameters.Length;

                // We write the parameters into the request
                StreamWriter sw = new StreamWriter(webRequest.GetRequestStream());
                sw.Write(parameters);
                sw.Close();

                // Execute the query
                webResponse = (HttpWebResponse)webRequest.GetResponse();
                Stream stream = webResponse.GetResponseStream();

                return stream;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        public async Task<WebRequest> Send()
        {
            // Build a string containing all the parameters
            //string parameters = String.Join("&", (String[])queryData.ToArray(typeof(string)));

            webRequest.ContentType = "application/x-www-form-urlencoded";
            ((HttpWebRequest)webRequest).Accept = "Accept image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-powerpoint, application/vnd.ms-excel, application/msword, application/x-shockwave-flash, */*";
            //req.Method = "GET";
            ((HttpWebRequest)webRequest).MaximumResponseHeadersLength = 650000;
            ((HttpWebRequest)webRequest).AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate;
            webRequest.Timeout = 10000;
            ((HttpWebRequest)webRequest).ReadWriteTimeout = 10000;
            ((HttpWebRequest)webRequest).ServicePoint.ConnectionLimit = 150;
            ((HttpWebRequest) webRequest).ServicePoint.Expect100Continue = true;
            ((HttpWebRequest) webRequest).ServicePoint.ConnectionLimit = 1;
            ((HttpWebRequest) webRequest).Expect = "";
            ((HttpWebRequest)webRequest).KeepAlive = false;
            ((HttpWebRequest)webRequest).ProtocolVersion = HttpVersion.Version10;

            string parameters = String.Join("&", queryData);
            webRequest.ContentLength = parameters.Length;

            ((HttpWebRequest)webRequest).KeepAlive = false;

            if (webRequest.ContentLength > 0)
            {
                // For Post Request you first call GetResponseStream and
                // Post your date/parameter there
                using (var stream = await webRequest.GetRequestStreamAsync())
                {
                    using (var streamWriter = new StreamWriter(stream))
                    {
                        streamWriter.Write(parameters);
                    }
                }
            }

            Debug.Print("Request Url: {0}", webRequest.RequestUri);

            return webRequest;
        }
    }
}
