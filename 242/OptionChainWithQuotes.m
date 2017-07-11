%   This implements a query with quotes.  
classdef OptionChainWithQuotes < OptionChain
    properties
        %   Basic properties inhereted from OptionChain
        %   Quote properties
        Punctuality;
        Bid;
        Ask;
        Last;
        Change;
        ChangePercent;
        Volume;
        BidSize;
        AskSize;
        LastTradeTime;
        LastTradeDate;
        OpenInterest;
        Delta;
        Gamma;
        Theta;
        Vega;
        Rho;
        ImpliedVolatility;
        TimeValueIndex;
        Multiplier;
        InOutTheMoney;
        TheoreticalValue;        
    end
    
    methods
        function obj = OptionChainWithQuotes( eventargs )
            %   Instantiate the superclass -- This must occur before any
            %   other references to the object.
            obj = obj@OptionChain( eventargs );
            %   Place object on the instance list
            global optionChainsWithQuotes
            optionChainsWithQuotes = [optionChainsWithQuotes obj];
            %   Instantiate this subclass
            N = eventargs.Chain.Count;
            obj.Punctuality         = cell(N,1);
            obj.Bid                 = zeros(N,1);
            obj.Ask                 = zeros(N,1);
            obj.Last                = zeros(N,1);
            obj.Change              = zeros(N,1);
            obj.ChangePercent       = zeros(N,1);
            obj.Volume              = zeros(N,1);
            obj.BidSize             = zeros(N,1);
            obj.AskSize             = zeros(N,1);
            obj.LastTradeTime       = zeros(N,1);
            obj.LastTradeDate       = zeros(N,1);
            obj.OpenInterest        = zeros(N,1);
            obj.Delta               = zeros(N,1);
            obj.Gamma               = zeros(N,1);
            obj.Theta               = zeros(N,1);
            obj.Vega                = zeros(N,1);
            obj.Rho                 = zeros(N,1);
            obj.ImpliedVolatility   = zeros(N,1);
            obj.TimeValueIndex      = zeros(N,1);
            obj.Multiplier          = zeros(N,1);
            obj.InOutTheMoney       = cell(N,1);
            obj.TheoreticalValue    = zeros(N,1);
            %   Elaborate the object
            for i=0:obj.Count-1
                obj.Punctuality{i+1}        = eventargs.Chain.Punctuality(i);
                obj.Bid(i+1)                = eventargs.Chain.Bid(i);
                obj.Ask(i+1)                = eventargs.Chain.Ask(i);
                obj.Last(i+1)               = eventargs.Chain.Last(i);
                obj.Change(i+1)             = eventargs.Chain.Change(i);
                obj.ChangePercent(i+1)      = eventargs.Chain.ChangePercent(i);
                obj.Volume(i+1)             = eventargs.Chain.Volume(i);
                obj.BidSize(i+1)            = eventargs.Chain.BidSize(i);
                obj.AskSize(i+1)            = eventargs.Chain.AskSize(i);
                obj.LastTradeTime(i+1)      = eventargs.Chain.LastTradeTime(i);
                obj.LastTradeDate(i+1)      = eventargs.Chain.LastTradeDate(i);
                obj.OpenInterest(i+1)       = eventargs.Chain.OpenInterest(i);
                obj.Delta(i+1)              = eventargs.Chain.Delta(i);
                obj.Gamma(i+1)              = eventargs.Chain.Gamma(i);
                obj.Theta(i+1)              = eventargs.Chain.Theta(i);
                obj.Vega(i+1)               = eventargs.Chain.Vega(i);
                obj.Rho(i+1)                = eventargs.Chain.Rho(i);
                obj.ImpliedVolatility(i+1)  = eventargs.Chain.ImpliedVolatility(i);
                obj.TimeValueIndex(i+1)     = eventargs.Chain.TimeValueIndex(i);
                obj.Multiplier(i+1)         = eventargs.Chain.Multiplier(i);
                obj.InOutTheMoney{i+1}      = eventargs.Chain.InOutTheMoney(i);
                obj.TheoreticalValue(i+1)   = eventargs.Chain.TheoreticalValue(i);
            end
        end
        function Display(obj)
            baseDate = datenum('1/1/1970');
            secondsInDay = 60*60*24;
            for i=1:obj.Count
                % issues with ExpDate (year), LastTradeTime, LastTradeDate,
                % 
                fprintf('%s  CallPut: %s; ExpDate: %s; DaysToExp: %d; Strike: %5.2f; ExpType: %s; OptType: %s; Description: %s\n', ...
                    obj.Symbol{i}, obj.CallPut{i}, datestr(baseDate+obj.ExpDate(i)), obj.DaysToExp(i), ...
                    obj.Strike(i), obj.ExpType{i}, obj.OptType{i}, obj.Description{i} );
                fprintf('\tPunctuality: %s; Bid: %5.2f; Ask: %5.2f; Last: %5.2f; Change: %5.2f; Change%%: %5.4f; Vol: %d; Bid Size: %d; AskSize: %d\n', ...
                    obj.Punctuality{i}, obj.Bid(i), obj.Ask(i), obj.Last(i), obj.Change(i), obj.ChangePercent(i), obj.Volume(i), obj.BidSize(i), obj.AskSize(i) );
                fprintf('\tLastTrade: %s; OpenInterest: %d; Delta: %5.2f; Gamma: %5.2f; Theta: %5.2f; Vega: %5.2f; Rho: %5.2f\n', ...
                    datestr(baseDate+obj.LastTradeDate(i)+obj.LastTradeTime(i)/secondsInDay), obj.OpenInterest(i), obj.Delta(i), obj.Gamma(i), obj.Theta(i), obj.Vega(i), obj.Rho(i) );
                fprintf('\tImpliedVolatility: %5.2f; TimeValueIndex: %5.2f; Multiplier: %5.2f; InOutTheMoney: %s; TheoreticalValue: %5.2f\n', ...
                    obj.ImpliedVolatility(i), obj.TimeValueIndex(i), obj.Multiplier(i), obj.InOutTheMoney{i}, obj.TheoreticalValue(i) );
            end
        end
    end
    methods (Static)
        %   Clear the instance list
        function Clear
            global optionChainsWithQuotes optionChainWithQuotesRequestCount
            optionChainsWithQuotes = [];
            optionChainWithQuotesRequestCount = 0;
        end
        %   Query for an instance
        function [obj, index] = Query( ticker )
            global optionChainsWithQuotes
            obj = []; index = 0;
            for i=1:length(optionChainsWithQuotes)
                chainTicker = optionChainsWithQuotes(i).Symbol{1};
                if strcmp(chainTicker(1:length(ticker)),ticker)
                    index = i;
                    obj = optionChainsWithQuotes(i);
                    break;  
                end
            end
            if isempty(obj)
                error('Query not found');
            end
        end
        %   Request a quote and increment the count
        function Request( ticker, argString )
            global tdaapi optionChainWithQuotesRequestCount
            if ~isempty(argString)
                argString = ['quotes=true&' argString];
            else
                argString = ['quotes=true'];
            end
            tdaapi.RequestOptionChain(ticker, argString);
            optionChainWithQuotesRequestCount = optionChainWithQuotesRequestCount+1;
        end
        %   Test whether all requests have elaborated
        function result = Elaborated
            global optionChainsWithQuotes optionChainWithQuotesRequestCount
            %fprintf('Elaborated: length=%d\n', length(optionChainsWithQuotes));
            if length(optionChainsWithQuotes)>=optionChainWithQuotesRequestCount
                result = true;
            else
                result = false;
            end
        end
    end
    
end

