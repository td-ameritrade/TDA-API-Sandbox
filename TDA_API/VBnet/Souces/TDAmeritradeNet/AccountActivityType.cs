using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public enum AccountActivityType
    {
        SUBSCRIBED,
        ERROR,
        BrokenTrade,
        ManualExecution,
        OrderActivation,
        OrderCancelReplaceRequest,
        OrderCancelRequest,
        OrderEntryRequest,
        OrderFill,
        OrderPartialFill,
        OrderRejection,
        TooLateToCancel,
        UROUT,
        NotFound
    }
}
