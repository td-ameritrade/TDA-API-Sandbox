
    SnapQuote.Clear;
    OptionChainWithQuotes.Clear;
    OptionChain.Clear;
    AccountPositions.Clear;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Stock Quote Example
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Make some requests for quotes
    display('Requesting quotes');
    SnapQuote.Request('AAPL');
    SnapQuote.Request('INSY');
    SnapQuote.Request('SRPT');
    SnapQuote.Request('MU');
    SnapQuote.Request('BBY');
    SnapQuote.Request('MYGN');
    %   Wait for elaboration of the requests
    while ~SnapQuote.Elaborated
        pause(0.25);
    end
    %   Associate the received quotes with variables
    display('Fetching quotes');
    aapl = SnapQuote.Query('AAPL');
    insy = SnapQuote.Query('INSY');
    srpt = SnapQuote.Query('SRPT');
    mu = SnapQuote.Query('MU');
    bby = SnapQuote.Query('BBY');
    mygn = SnapQuote.Query('MYGN');
    %   Display the quotes
    display('Displaying quotes');
    aapl.Display;
    insy.Display;
    srpt.Display;
    mu.Display;
    bby.Display;
    mygn.Display;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Option Chain With Quotes Example
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Make some requests for quotes
    display('Requesting OCWQs');
    OptionChainWithQuotes.Request('INSY','type=c&strike=30');
    OptionChainWithQuotes.Request('AAPL','strike=90');
    %   Wait for elaboration of the requests
    while ~OptionChainWithQuotes.Elaborated
        pause(0.25);
    end
    %   Associate the received quotes with variables
    display('Fetching option chains');
    aaplChain = OptionChainWithQuotes.Query('AAPL');
    aaplChain.Display
    %   Display the quotes
    insyChain = OptionChainWithQuotes.Query('INSY');
    insyChain.Display
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Account Positions Example
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Request account positions
    display('Requesting Account Positions');
    accountNumber = num2str(input('Enter Account Number:'));
    AccountPositions.Request(accountNumber);
    %   Wait for elaboration
    while ~AccountPositions.Elaborated
        pause(0.25);
    end
    %   Fetch positions
    display('Fetching account positions');
    acctPositions = AccountPositions.Query(accountNumber);
    %   Display positions
    acctPositions.Display;
