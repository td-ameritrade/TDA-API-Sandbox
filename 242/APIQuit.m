tdaapi.Logout;
display('Logging out...');
while tdaapi.LoggedIn
    pause(0.25);
end
display('Successful logout.');
tdaapi.STOPIT;

%   Release the server
release(tdaapi);