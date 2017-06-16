%   This implements a query with quotes.  
classdef OptionChain < handle
    properties
        %   Basic properties
        Count;
        Symbol;
        Description;
        CallPut;
        ExpDate;
        DaysToExp;
        Strike;
        ExpType;
        OptType;
    end
    
    methods
        function obj = OptionChain( eventargs )
            global optionChains
            if nargin > 0
                if strcmp(class(obj),'OptionChain')
                    %   Place object on the instance list
                    optionChains = [optionChains obj];
                end
                N = eventargs.Chain.Count;
                obj.Count = N;
                obj.Symbol = cell(N,1);
                obj.CallPut = cell(N,1);
                obj.ExpDate = zeros(N,1);
                obj.DaysToExp = zeros(N,1);
                obj.Strike = zeros(N,1);
                obj.ExpType = cell(N,1);
                obj.OptType = cell(N,1);
                obj.Description = cell(N,1);
                %   Elaborate the object
                for i=0:obj.Count-1
                    obj.Symbol{i+1} = eventargs.Chain.Symbol(i);
                    obj.Description{i+1} = eventargs.Chain.Description(i);
                    obj.CallPut{i+1} = eventargs.Chain.CallPut(i);
                    obj.ExpDate(i+1) = eventargs.Chain.ExpDate(i);
                    obj.DaysToExp(i+1) = eventargs.Chain.DaysToExp(i);
                    obj.Strike(i+1) = eventargs.Chain.Strike(i);
                    obj.ExpType{i+1} = eventargs.Chain.ExpType(i);
                    obj.OptType{i+1} = eventargs.Chain.OptType(i);
                end
            end
        end
        function Display(obj)
            for i=1:obj.Count
                fprintf('%s  CallPut: %s ExpDate: %s DaysToExp: %d Strike: %5.2f, ExpType: %s; OptType: %s; Description: %s\n', ...
                    obj.Symbol{i}, obj.CallPut{i}, datestr(obj.ExpDate(i)), obj.DaysToExp(i), ...
                    obj.Strike(i), obj.ExpType{i}, obj.OptType{i}, obj.Description{i} );
            end
        end
    end
    methods (Static)
        %   Clear the instance list
        function Clear
            global optionChains optionChainRequestCount
            optionChains = [];
            optionChainRequestCount = 0;
        end
        %   Query for an instance
        function [obj, index] = Query( ticker )
            global optionChains
            obj = []; index = 0;
            for i=1:length(optionChains)
                chainTicker = optionChains(i).Symbol{1};
                if strcmp(chainTicker(1:length(ticker)),ticker)
                    index = i;
                    obj = optionChains(i);
                    break;  
                end
            end
            if isempty(obj)
                error('Query not found');
            end
        end
        %   Request a quote and increment the count
        function Request( ticker, args )
            global tdaapi optionChainRequestCount
            tdaapi.RequestOptionChain(ticker,args);
            optionChainRequestCount = optionChainRequestCount+1;
        end
        %   Test whether all requests have elaborated
        function result = Elaborated
            global optionChains optionChainRequestCount
            %fprintf('Elaborated: length=%d\n', length(optionChains));
            if length(optionChains)>=optionChainRequestCount
                result = true;
            else
                result = false;
            end
        end
    end
    
end

