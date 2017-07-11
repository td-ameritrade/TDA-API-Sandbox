classdef ConnectionStatus < handle
    properties
        connectionState = 0;
        connectionStatusStrings = { ...
            'logged in, streaming connection idle' ...
            'logging in' ...
            'log in failed' ...
            'successful login' ...
            'establishing streaming connection' ...
            'streaming connection active' ...
            'streaming connection unexpectedly terminated' ...
            'problem with streaming connection - timeout waiting for data' ...
            'received notification from server - service interruption' ...
            'failed logout' ...
            'successful logout' ...
            'received a valid KeepAlive response' ...
            'received an invalid KeepAlive response' ...
            };
    end
    
    methods
        function obj = ConnectionStatus
            % Nothing to do...
        end
        function Update( obj, newState )
            assert((newState > 0) && (newState <= length(obj.connectionStatusStrings)));
            obj.connectionState = newState;
        end
        function Display( obj )
            if obj.connectionState
                display(sprintf('Connection Status: %s', obj.connectionStatusStrings{obj.connectionState}));
            else
                error('ConnectionStatus Display on invalid state');
            end
        end
    end    
end
