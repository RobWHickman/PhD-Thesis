function typeHandshakeSelection(source, eventdata)
%   typeHandshakeSelection(source, eventdata)
%
% Callback function for radio button selecting type of handshake in Modig.
%
% rbm 1.13
global UserInfo MENUs

% verify what figure calls back
if strcmp(get(source,'tag'),'typeOfHandshake')
    UserInfo.typeOfHandshake = get(eventdata.NewValue,'String');
    
    % enable/disable toggle button to open connection
    switch UserInfo.typeOfHandshake,
        case 'NI',
            set(MENUs.ModigMainMenu.handles.togglebutton_openConnection,'enable','off')
        case 'TCP',
            set(MENUs.ModigMainMenu.handles.togglebutton_openConnection,'enable','on')            
    end
else
    error('Unknown caller to typeHandshakeSelection: %s',get(source,'tag'))
end
