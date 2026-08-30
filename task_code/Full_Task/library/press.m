function yes=press()

    keydown=0;
    n=0;

    [keydown,keysecs, keyCode]=KbCheck;
    if keydown~=0
        keyname=KbName(keyCode);

        if size(keyname,2)==1
           n=1;
           if keyname=='q'
               yes=1;
           else
               yes=0;
           end

        elseif size(keyname,2)==3
            n=1;
            if char(keyname(2))=='q'
                yes=1;
            else
                yes=0;
            end
        else
            yes=0;
        end
    else
        yes=0;
    end
    
end