function KeyPressed(guiHdl, evnt)
% KeyPressed(src, evnt)
%
% callback for GUI property "KeyPressFcn",
%
% during trials it doesn't interrupts them -it has a low priority-
%
% rbm 01.08
global MENUs

% different guis have different key strokes combinations
if guiHdl==MENUs.ModigMainMenu.handle,
    if length(evnt.Modifier)==1 && strcmpi(evnt.Modifier,'alt'),
        switch evnt.Key,
            case 'f'
                % free juice
                ModigCommand('juice');
            case 's'
                % "press" start button
                myVal = get(MENUs.ModigMainMenu.handles.CNTR_PUSH_START,'value');
                newVal = abs(myVal-1);
                set(MENUs.ModigMainMenu.handles.CNTR_PUSH_START,'value',newVal);
                ModigCommand('start_button');
        end
    end
end
