using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class MarketHours
    {
        private static string _holidaySchedulePath = "holidays.txt";
        private static DateTime preMarket = DateTime.MinValue;
        private static DateTime marketOpen = DateTime.MinValue;
        private static DateTime marketClose = DateTime.MinValue;
        private static DateTime afterHours = DateTime.MinValue;
        private static TimeZoneInfo _easternZone = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
        private static SortedDictionary<DateTime, bool> _holidays = null;
        private static bool isWeekend;

        public static DateTime LastMarketDay = DateTime.MinValue;
        public static bool LastMarketDayCloseEarly = false;
        public static DateTime PreviousMarketDay = DateTime.MinValue;
        public static bool PreviousMarketDayCloseEarly = false;

        public static MarketHoursCode StatusCode = MarketHoursCode.Closed;


        public static DateTime PreMarket
        {
            get { return preMarket; }
            set { preMarket = value; }
        }

        public static DateTime MarketOpen
        {
            get { return marketOpen; }
            set { marketOpen = value; }
        }

        public static DateTime MarketClose
        {
            get { return marketClose; }
            set { marketClose = value; }
        }

        public static DateTime AfterHours
        {
            get { return afterHours; }
            set { afterHours = value; }
        }

        public static bool IsWeekend
        {
            get { return isWeekend; }
        }

        static MarketHours()
        {
            LoadHoliday();

            // check if today is weekend
            isWeekend = DateTime.Today.DayOfWeek == DayOfWeek.Saturday || DateTime.Today.DayOfWeek == DayOfWeek.Sunday;

            // Get LastMarketDay
            var lastDate = DateTime.Today;
            while (lastDate.DayOfWeek == DayOfWeek.Saturday ||
                   lastDate.DayOfWeek == DayOfWeek.Sunday ||
                   _holidays.Any(o => o.Key == lastDate.Date && o.Value == false))
            {
                lastDate = lastDate.AddDays(-1);
            }
            LastMarketDay = lastDate;

            LastMarketDayCloseEarly = IsCloseEarly(LastMarketDay);

            // Get PreviousMarketDay
            // Get LastMarketDay
            lastDate = DateTime.Today.AddDays(-1);
            while (lastDate.DayOfWeek == DayOfWeek.Saturday ||
                   lastDate.DayOfWeek == DayOfWeek.Sunday ||
                   _holidays.Any(o => o.Key == lastDate.Date && o.Value == false))
            {
                lastDate = lastDate.AddDays(-1);
            }
            PreviousMarketDay = lastDate;
            PreviousMarketDayCloseEarly = IsCloseEarly(PreviousMarketDay);

            StatusCode = GetStatus();
        }

        public static MarketHoursCode GetStatus()
        {
            return GetStatus(DateTime.Now);
        }

        public static bool IsCloseEarly(DateTime date)
        {
            var estTime = GetLocalTimeToEasternTime(date);

            if (_holidays != null && _holidays.ContainsKey(estTime.Date))
            {
                return _holidays[estTime.Date];
            }

            return false;
        }

        public static MarketHoursCode GetStatus(DateTime currentTime)
        {
            var estTime = GetLocalTimeToEasternTime(currentTime);

            preMarket = GetEasternTimeToLocalTime(LastMarketDay.AddHours(8));
            marketOpen = GetEasternTimeToLocalTime(LastMarketDay.AddHours(9).AddMinutes(30));
            marketClose = GetEasternTimeToLocalTime(LastMarketDay.AddHours(16));
            afterHours = GetEasternTimeToLocalTime(LastMarketDay.AddHours(20));

            //Debug.Print("Eastern Standard Time: {0:HH:mm:ss}", estTime);

            if (estTime.DayOfWeek == DayOfWeek.Saturday ||
                estTime.DayOfWeek == DayOfWeek.Sunday)
            {
                StatusCode = MarketHoursCode.Closed;
                return MarketHoursCode.Closed;
            }

            if (_holidays != null && _holidays.ContainsKey(estTime.Date))
            {
                var closeEarly = _holidays[estTime.Date];
                if (closeEarly)
                {
                    preMarket = GetEasternTimeToLocalTime(LastMarketDay.AddHours(8));
                    marketOpen = GetEasternTimeToLocalTime(LastMarketDay.AddHours(9).AddMinutes(30));
                    marketClose = GetEasternTimeToLocalTime(LastMarketDay.AddHours(13));
                    afterHours = GetEasternTimeToLocalTime(LastMarketDay.AddHours(17));
                }
                else
                {
                    StatusCode = MarketHoursCode.Closed;
                    return MarketHoursCode.Closed;
                }
            }

            if (marketOpen == DateTime.MinValue || marketClose == DateTime.MinValue)
            {
                StatusCode = MarketHoursCode.Closed;
                return MarketHoursCode.Closed;
            }

            if (estTime >= preMarket && marketOpen > estTime)
            {
                StatusCode = MarketHoursCode.PreMarket;
                return MarketHoursCode.PreMarket;
            }

            if (estTime >= marketOpen && estTime < marketClose)
            {
                StatusCode = MarketHoursCode.Opened;
                return MarketHoursCode.Opened;
            }

            if (estTime >= marketClose && estTime < afterHours)
            {
                StatusCode = MarketHoursCode.AfterHours;
                return MarketHoursCode.AfterHours;
            }

            StatusCode = MarketHoursCode.Closed;
            return MarketHoursCode.Closed;
        }

        public static void LoadHoliday()
        {
            _holidays = new SortedDictionary<DateTime, bool>();

            // Load Holiday Schedules
            // http://www.nyx.com/holidays-and-hours/nyse
            if (File.Exists(_holidaySchedulePath))
            {
                using (TextReader tr = new StreamReader(_holidaySchedulePath))
                {
                    string l = string.Empty;
                    while ((l = tr.ReadLine()) != null)
                    {
                        try
                        {
                            if (!l.StartsWith("#"))
                            {
                                string[] s = l.Split(new char[] { ';', ',', ' ', '\t' });
                                if (s.Length >= 2)
                                {
                                    var holidayDate = Convert.ToDateTime(s[0]).Date;
                                    var isCloseEarly = Convert.ToBoolean(s[1].Trim().ToLower());

                                    if (!_holidays.ContainsKey(holidayDate))
                                        _holidays.Add(holidayDate, isCloseEarly);
                                }
                            }
                        }
                        catch (Exception e)
                        {
                            throw new InvalidCastException("Unable to cast holiday. line: " + l);
                        }
                    }
                }
            }
        }

        public static DateTime GetLocalTime(DateTime dateTime)
        {
            //DateTime utc = dateTime.ToUniversalTime();
            return TimeZone.CurrentTimeZone.ToLocalTime(dateTime);
        }

        public static DateTime GetUniversalTime(DateTime dateTime)
        {
            return TimeZone.CurrentTimeZone.ToUniversalTime(dateTime);
        }

        public static DateTime GetEasternTimeToUniversalTime(DateTime estTime)
        {
            DateTime time = DateTime.SpecifyKind(estTime, DateTimeKind.Unspecified);
            try
            {
                return TimeZoneInfo.ConvertTimeToUtc(time, _easternZone);
            }
            catch (Exception)
            {
                throw new InvalidCastException("Can't convert from EST to UTC.");
            }
        }

        public static DateTime GetEasternTimeToLocalTime(DateTime estTime)
        {
            try
            {
                return TimeZone.CurrentTimeZone.ToLocalTime(GetEasternTimeToUniversalTime(estTime));
            }
            catch (Exception)
            {
                throw new InvalidCastException("Can't convert from EST to Local.");
            }
        }

        public static DateTime GetLocalTimeToEasternTime(DateTime dateTime)
        {
            try
            {
                if (!_easternZone.IsDaylightSavingTime(dateTime))
                {
                    return GetUniversalTime(dateTime).AddHours(-5);  // Eastern Standard Time
                }
                else
                {
                    return GetUniversalTime(dateTime).AddHours(-4);  // Eastern Daylight Saving
                }
            }
            catch (Exception)
            {
                throw new InvalidCastException("Can't convert local time to eastern time.");
            }
        }
    }

    public enum MarketHoursCode
    {
        Closed,
        PreMarket,
        Opened,
        AfterHours,
        Unknown
    }
}