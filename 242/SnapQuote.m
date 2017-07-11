classdef SnapQuote < handle
    properties
        Symbol;
        FullName;
        Bid;
        Ask;
        BidSize;
        AskSize;
        Last;
        LastSize;
        Open;
        High;
        Low;
        PrevClose;
        Volume;
        High52;
        Low52;
        Change;
    end
    methods
        function obj = SnapQuote( eventargs ) 
            global snapQuotes
            %   Place object on the instance list
            snapQuotes = [snapQuotes obj];     
            %assignin('base',snapQuotes,snapQuotes); 
            %   Elaborate the object
            obj.Symbol = eventargs.Quote.Symbol;
            obj.FullName = eventargs.Quote.FullName;
            obj.Bid = eventargs.Quote.Bid;
            obj.Ask = eventargs.Quote.Ask;
            obj.BidSize = eventargs.Quote.BidSize;
            obj.AskSize = eventargs.Quote.AskSize;
            obj.Last = eventargs.Quote.Last;
            obj.LastSize = eventargs.Quote.LastSize;
            obj.Open = eventargs.Quote.Open;
            obj.High = eventargs.Quote.High;
            obj.Low = eventargs.Quote.Low;
            obj.PrevClose = eventargs.Quote.PrevClose;
            obj.Volume = eventargs.Quote.Volume;
            obj.High52 = eventargs.Quote.High52;
            obj.Low52 = eventargs.Quote.Low52;
            obj.Change = eventargs.Quote.Change;
        end
        function Display(obj)
            fprintf('%s  O: %5.2f H: %5.2f L: %5.2f C: %5.2f\n', ...
                obj.Symbol, obj.Open, obj.High, obj.Low, obj.PrevClose );
        end
    end
    methods (Static)
        %   Clear the instance list
        function Clear
            global snapQuotes snapQuoteRequestCount
            snapQuotes = [];
            snapQuoteRequestCount = 0;
        end
        %   Query for an instance
        function [obj, index] = Query( ticker )
            global snapQuotes
            if ~isempty(snapQuotes)
                tickers = {snapQuotes(:).Symbol};
                selectedQuotes = strcmp(ticker,tickers);
                if sum(selectedQuotes)
                    index = find(selectedQuotes);
                    obj = snapQuotes(index(1));
                else
                    error('Query not found');
                end
            else
                error('No SnapQuote instances to return.');
            end
        end
        %   Request a quote and increment the count
        function Request( ticker )
            global tdaapi snapQuoteRequestCount
            tdaapi.RequestSnapshotQuotes(ticker);
            snapQuoteRequestCount = snapQuoteRequestCount+1;
        end
        %   Test whether all requests have elaborated
        function result = Elaborated
            global snapQuotes snapQuoteRequestCount
            %fprintf('Elaborated: length=%d\n', length(snapQuotes));
            if length(snapQuotes)>=snapQuoteRequestCount
                result = true;
            else
                result = false;
            end
        end
    end
end

