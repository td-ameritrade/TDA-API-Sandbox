using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace TDAmeritradeNet
{
    public class StreamerInfo
    {
        public string StreamerUrl { get; set; }
        public string Token { get; set; }
        public string TimeStamp { get; set; }
        public string CdDomainId { get; set; }
        public string UserGroup { get; set; }
        public string AccessLevel { get; set; }
        public string ACL { get; set; }
        public string AppId { get; set; }
        public string Authorized { get; set; }
        public string ErrorMsg { get; set; }

        public StreamerInfo(Stream stream)
        {
            try
            {
                var xml = XDocument.Load(stream).Root;

                if (xml.Element("result").Value == "OK")
                {
                    XElement streamerInfo = xml.Element("streamer-info");
                    StreamerUrl = streamerInfo.Element("streamer-url").Value;
                    Token = streamerInfo.Element("token").Value;
                    TimeStamp = streamerInfo.Element("timestamp").Value;
                    CdDomainId = streamerInfo.Element("cd-domain-id").Value;
                    UserGroup = streamerInfo.Element("usergroup").Value;
                    AccessLevel = streamerInfo.Element("access-level").Value;
                    ACL = streamerInfo.Element("acl").Value;
                    AppId = streamerInfo.Element("app-id").Value;
                    Authorized = streamerInfo.Element("authorized").Value;
                    ErrorMsg = streamerInfo.Element("error-msg").Value;
                }

                // Just to verifying information
                var sb = new StringBuilder();
                sb.AppendLine("\r\n--------------------[ Streamer Info ]-------------------");
                sb.AppendLine("StreamerUrl: " + StreamerUrl);
                sb.AppendLine("Token: " + Token);
                sb.AppendLine("TimeStamp: " + TimeStamp);
                sb.AppendLine("CdDomainId: " + CdDomainId);
                sb.AppendLine("UserGroup: " + UserGroup);
                sb.AppendLine("ACL: " + ACL);
                sb.AppendLine("AppId: " + AppId);
                sb.AppendLine("Authorized: " + Authorized);
                sb.AppendLine("ErrorMsg: " + ErrorMsg);
                sb.AppendLine("\r\n--------------------[ Streamer End ]-------------------");
                Debug.Print(sb.ToString());

                // log into app log
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "--------------------[ Streamer Info ]-------------------" });
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "StreamerUrl: " + StreamerUrl });
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "Token: " + Token });
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "TimeStamp: " + TimeStamp });
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "CdDomainId: " + CdDomainId });
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "UserGroup: " + UserGroup });
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "ACL: " + ACL });
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "AppId: " + AppId });
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "Authorized: " + Authorized });
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "ErrorMsg: " + ErrorMsg });
                AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "--------------------[ Streamer End ]-------------------" });
            }
            catch (Exception)
            {
                throw new FormatException("Can't parse streamer info xml");
            }
        }
    }
}
