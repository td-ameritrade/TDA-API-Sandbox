using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public enum StreamerServerReturnCode
    {
        SUCCESS = 0,
        SERVICE_DOWN = 1,
        SERVICE_TIMEOUT = 2,
        LOGIN_DENIED = 3,
        AUTHORIZER_BUSY = 4,
        AUTHORIZER_DOWN = 5,
        USER_NOT_FOUND = 6,
        ACCOUNT_ON_HOLD = 7,
        ACCOUNT_FROZEN = 8,
        UNKNOWN_FAILURE = 9,
        FAILURE = 10,
        SERVICE_NOT_AVAILABLE = 11,
        CLOSE_APPLET = 12,
        USER_STATUS = 13,
        ACCOUNT_EMPTY = 14,
        MONOPOLIZE_ACK = 15,
        NOT_AUTHORIZED_FOR_SERVICE = 16,
        NOT_AUTHORIZED_FOR_QUOTE = 17,
        STREAMER_SERVER_ID = 18,
        REACHED_SYMBOL_LIMIT = 19,
        STREAM_CONNECTION_NOT_FOUND = 20,
        BAD_COMMAND_FORMAT = 21,
        FAILED_COMMAND_SUBS = 22,
        FAILED_COMMAND_UNSUBS = 23,
        FAILED_COMMAND_ADD = 24,
        FAILED_COMMAND_VIEW = 25,
        SUCCEEDED_COMMAND_SUBS = 26,
        SUCCEEDED_COMMAND_UNSUBS = 27,
        SUCCEEDED_COMMAND_ADD = 28,
        SUCCEEDED_COMMAND_VIEW = 29
    }
}
