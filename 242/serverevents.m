%   This is the handler for all events on the TDAAPI Interface.
function serverevents(varargin)

    global connectionState
    
    %   Create a system object to display the connection state
    if isempty(connectionState)
        connectionState = ConnectionStatus;
    end
    
    % Display incoming event name
    eventname = varargin{end};

    % Display incoming event args
    eventargs = varargin{end-1};

    switch eventname
        case 'OnPing' 
            fprintf('Received server ping: ');
            switch eventargs.H      % indicator field
                case 'R' 
                    display('Connection Error');
                case 'Y' 
                    display('Logging in');
                case 'G' 
                    display('Running properly');
                otherwise
                    error('Unknown Ping Argument');
            end
        case 'OnStatusChange' 
            connectionState.Update(eventargs.NewStatus);
            connectionState.Display;
        case 'OnSnapQuote' 
            display('Servicing OnSnapQuote');
            SnapQuote( eventargs );  
        case 'OnOptionChain' 
            display('Servicing OptionChain');
            OptionChain( eventargs );  
        case 'OnPositionsChange'
            display('Servicing OnPositionsChange (BalancesAndPositions)');
            AccountPositions( eventargs );
        case 'OnBalancesChange'
            display('Servicing OnBalancesChange (BalancesAndPositions)');
            % Ignore this event for now
        case 'OnOptionChainWithQuotes'
            % Handler for RequestOptionChain
            display('Servicing OnOptionChainWithQuotes...');
            OptionChainWithQuotes( eventargs );  
        otherwise
            display(sprintf('API Event Handler -- event %s is not currently handled', eventname));
    end
end

