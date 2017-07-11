%   This implements a query with quotes.  
classdef AccountPositions < handle
    properties
        %   Basic properties
        Count;
        AccountID;
        Symbol;
        SymbolWithPrefix;
        FullName;
        AssetType;
        CUSIP;
        AccountType;
        ClosePrice;
        PositionType;
        AveragePrice;
        Quantity;
        PutCall;
        MaintRequirement;
        %%%%%%%%%%%
        Bid;
        Ask;
        Last;
        High;
        Low;
        Close;
        Open;
        Change;
        High52;
        Low52;
        Volume;
        BidSize;
        AskSize;
        LastSize;
        TradeTime;
        TradeDate;
        Volatility;
        NAV;
        OpenInterest;
        TimeValue;
        Delta;
        Gamma;
        Vega;
        Rho;
        Theta;
        StrikePrice;
        ExpirationMonth;
        UnderlyingSymbol;
        DaysToExpiration;
    end
    
    methods
        function obj = AccountPositions( eventargs )
            global accountPositions
            if nargin > 0
                if strcmp(class(obj),'AccountPositions')
                    %   Place object on the instance list
                    accountPositions = [accountPositions obj];
                end
                N = eventargs.Positions.Count;
                obj.Count = N;
                obj.AccountID = cell(N,1);          % string
                obj.Symbol = cell(N,1);             % string
                obj.SymbolWithPrefix = cell(N,1);   % string
                obj.FullName = cell(N,1);           % string
                obj.AssetType = cell(N,1);          % string
                obj.CUSIP = cell(N,1);              % string
                obj.AccountType = cell(N,1);        % string
                obj.ClosePrice = zeros(N,1);
                obj.PositionType = cell(N,1);       % string
                obj.AveragePrice = zeros(N,1);
                obj.Quantity = zeros(N,1);
                obj.PutCall = cell(N,1);            % string
                obj.MaintRequirement = zeros(N,1);
                %%%%%%%%%%%
                obj.Bid = zeros(N,1);
                obj.Ask = zeros(N,1);
                obj.Last = zeros(N,1);
                obj.High = zeros(N,1);
                obj.Low = zeros(N,1);
                obj.Close = zeros(N,1);
                obj.Open = zeros(N,1);
                obj.Change = zeros(N,1);
                obj.High52 = zeros(N,1);
                obj.Low52 = zeros(N,1);
                obj.Volume = zeros(N,1);
                obj.BidSize = zeros(N,1);
                obj.AskSize = zeros(N,1);
                obj.LastSize = zeros(N,1);
                obj.TradeTime = zeros(N,1);
                obj.TradeDate = zeros(N,1);
                obj.Volatility = zeros(N,1);
                obj.NAV = zeros(N,1);
                obj.OpenInterest = zeros(N,1);
                obj.TimeValue = zeros(N,1);
                obj.Delta = zeros(N,1);
                obj.Gamma = zeros(N,1);
                obj.Vega = zeros(N,1);
                obj.Rho = zeros(N,1);
                obj.Theta = zeros(N,1);
                obj.StrikePrice = zeros(N,1);
                obj.ExpirationMonth = zeros(N,1);
                obj.UnderlyingSymbol = cell(N,1);       % string
                obj.DaysToExpiration = zeros(N,1);
                
                %   Elaborate the object
                for i=0:N-1
                    obj.AccountID{i+1}          = eventargs.Positions.AccountID(i);     % string
                    obj.Symbol{i+1}             = eventargs.Positions.Symbol(i);        % string
                    obj.SymbolWithPrefix{i+1}   = eventargs.Positions.SymbolWithPrefix(i);  % string
                    obj.FullName{i+1}           = eventargs.Positions.FullName(i);      % string
                    obj.AssetType{i+1}          = eventargs.Positions.AssetType(i);     % string
                    obj.CUSIP{i+1}              = eventargs.Positions.CUSIP(i);         % string
                    obj.AccountType{i+1}        = eventargs.Positions.AccountType(i);   % string
                    obj.ClosePrice(i+1)         = eventargs.Positions.ClosePrice(i);
                    obj.PositionType{i+1}       = eventargs.Positions.PositionType(i);  % string
                    obj.AveragePrice(i+1)       = eventargs.Positions.AveragePrice(i);
                    obj.Quantity(i+1)           = eventargs.Positions.Quantity(i);
                    obj.PutCall{i+1}            = eventargs.Positions.PutCall(i);       % string
                    obj.MaintRequirement(i+1)   = eventargs.Positions.MaintRequirement(i);
                    %%%%%%%%%%%
                    obj.Bid(i+1)                = eventargs.Positions.Bid(i);
                    obj.Ask(i+1)                = eventargs.Positions.Ask(i);
                    obj.Last(i+1)               = eventargs.Positions.Last(i);
                    obj.High(i+1)               = eventargs.Positions.High(i);
                    obj.Low(i+1)                = eventargs.Positions.Low(i);
                    obj.Close(i+1)              = eventargs.Positions.Close(i);
                    obj.Open(i+1)               = eventargs.Positions.Open(i);
                    obj.Change(i+1)             = eventargs.Positions.Change(i);
                    obj.High52(i+1)             = eventargs.Positions.High52(i);
                    obj.Low52(i+1)              = eventargs.Positions.Low52(i);
                    obj.Volume(i+1)             = eventargs.Positions.Volume(i);
                    obj.BidSize(i+1)            = eventargs.Positions.BidSize(i);
                    obj.AskSize(i+1)            = eventargs.Positions.AskSize(i);
                    obj.LastSize(i+1)           = eventargs.Positions.LastSize(i);
                    obj.TradeTime(i+1)          = eventargs.Positions.TradeTime(i);
                    obj.TradeDate(i+1)          = eventargs.Positions.TradeDate(i);
                    obj.Volatility(i+1)         = eventargs.Positions.Volatility(i);
                    obj.NAV(i+1)                = eventargs.Positions.Volatility(i);
                    obj.OpenInterest(i+1)       = eventargs.Positions.OpenInterest(i);
                    obj.TimeValue(i+1)          = eventargs.Positions.TimeValue(i);
                    obj.Delta(i+1)              = eventargs.Positions.Delta(i);
                    obj.Gamma(i+1)              = eventargs.Positions.Gamma(i);
                    obj.Vega(i+1)               = eventargs.Positions.Vega(i);
                    obj.Rho(i+1)                = eventargs.Positions.Rho(i);
                    obj.Theta(i+1)              = eventargs.Positions.Theta(i);
                    obj.StrikePrice(i+1)        = eventargs.Positions.StrikePrice(i);
                    obj.ExpirationMonth(i+1)    = eventargs.Positions.ExpirationMonth(i);
                    obj.UnderlyingSymbol{i+1}   = eventargs.Positions.UnderlyingSymbol(i);   % string
                    obj.DaysToExpiration(i+1)   = eventargs.Positions.DaysToExpiration(i);
                end
            end
        end

        function Display(obj)
            %baseDate = datenum('1/1/1970');
            %secondsInDay = 60*60*24;            
            fprintf('Account: %s\n', obj.AccountID{1});
            for i=1:obj.Count
                 symbol = obj.Symbol{i};
                 quantity = obj.Quantity(i);
                 bid = obj.Bid(i);
                 ask = obj.Ask(i);
                 vol = obj.Volatility(i);
                 fprintf('\tSymbol: %s; Quantity: %d; bid: %5.2f; ask: %5.2f; vol: %5.2f\n', ...
                     symbol, quantity, bid, ask, vol);
            end
        end
    end
    methods (Static)
        %   Clear the instance list
        function Clear
            global accountPositions accountPositionsRequestCount
            accountPositions = [];
            accountPositionsRequestCount = 0;
        end
        %   Query for an instance
        function [obj, index] = Query( account )
            global accountPositions
            obj = []; index = 0;
            for i=1:length(accountPositions)
                positionsAccount = accountPositions(i).AccountID{1};
                if strcmp(positionsAccount,account)
                    index = i;
                    obj = accountPositions(i);
                    break;  
                end
            end
            if isempty(obj)
                error('Query not found');
            end
        end
        %   Request a quote and increment the count
        function Request( account )
            global tdaapi accountPositionsRequestCount
            tdaapi.RequestBalancesAndPositions( account );
            %   Balances are ignored, for now
            accountPositionsRequestCount = accountPositionsRequestCount+1;
        end
        %   Test whether all requests have elaborated
        function result = Elaborated
            global accountPositions accountPositionsRequestCount
            %fprintf('Elaborated: length=%d\n', length(optionChains));
            if length(accountPositions)>=accountPositionsRequestCount
                result = true;
            else
                result = false;
            end
        end
    end
    
end

