%   Register the TDA activeX server
dos('regsvr32 tdaactx.ocx');

%   Query the registered activeX controls
controls = actxcontrollist;
%   Look for TDA controls
apiCommCount = sum(cell2mat(strfind( controls(:,1), 'TDAAPIComm Control' ))); 
apiGeneralCount = sum(cell2mat(strfind( controls(:,1), 'TDA' ))); 
%   Check that the controls are present in the expected amounts
if  apiCommCount~=1 && apiGeneralCount<24
        %   If not, print an error
    error('Failed to register the server.  Please see readme for remedies.');
end