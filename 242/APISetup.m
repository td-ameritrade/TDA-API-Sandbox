global tdaapi 

%   Determine whether we are logged in
try
    if isempty(tdaapi)
        loggedIn = false;
    else
        loggedIn = tdaapi.LoggedIn;
    end
catch
    loggedIn = false;
end

%   Set up the API if not logged in
if ~loggedIn
    %   Register the TDA activeX server
    APIRegister;
    
    %   Instantiate the TDA API server
    tdaapi = actxserver('tdaactx.TDAAPIComm');
    
    %   Register a handler for all events
    tdaapi.registerevent('serverevents');
    
    %   Turn on logging
    tdaapi.Logfile = 'TDA_API.log';
    tdaapi.loglevel = 10;
    
    %   Log in to the server
    set(tdaapi, 'SourceApp', input('Source ID: ','s'));
    set(tdaapi, 'LoginName', input('Username: ','s'));
    set(tdaapi, 'LoginPassword', input('PWD: ','s'));
    
    %   Start the interface
    tdaapi.STARTIT;
end
 
