using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class AppLog: EventArgs
    {
        #region Object Session

        public DateTime LogTime { get; set; }
        public AppLogType LogType { get; set; }
        public string Message { get; set; }

        public AppLog()
        {
            LogTime = DateTime.Now;
            LogType = AppLogType.Info;
            Message = string.Empty;
        }

        #endregion

        #region Static Session

        private static List<AppLog> _logs = new List<AppLog>();
        public static EventHandler<AppLog> OnAppLogAdded; 

        public static List<AppLog> Logs
        {
            get { return new List<AppLog>(_logs); }
        }

        static AppLog()
        {
            // empty
        }

        public static void Insert(AppLog log)
        {
            _logs.Add(log);

            if (OnAppLogAdded != null)
            {
                OnAppLogAdded(null, log);
            }
        }

        #endregion

    }

    public enum AppLogType
    {
        Alert,
        Info,
        Debug
    }
}
