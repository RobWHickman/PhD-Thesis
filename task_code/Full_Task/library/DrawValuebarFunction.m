function [m]=DrawValuebarFunction(group,solenoid)

global Stim VisParam %Tbl ModigDir

%max=234; %ms this needs to be done better in the future, 
%for now the number that needs to go in here is the opening time that
%corresponds to .8 ml... it should be learned from the daily calibration 

%in the future please program a a menu for this 

% [i,j,k]=size(m);

bg=VisParam.bg(1);

m=repmat(bg,[800 800 3]);

%This piece of code is used to draw separate valuebars for primary and
%alternate groups... which is what I use for my choice task.   Also, the
%'max' you see below is the opening time in milliseconds which corresponds
%to 1 ml of juice being delivered, this is the highest point on the scale.
%This is obviously specific to a given solenoid, so you need to calibrate
%yours and put it in there.  I have two solenoids, so there is why there
%are two
switch(group)
    case('prime')
        switch(solenoid)
            case(1)
                max=332;
            case(2)
                max=286;
        end
        level=Stim.cs.CurTrial.image.rwd_mag/Stim.cs.CurTrial.image.rwd_num;
        levelp=(max-level)/max;
        barcolor=Stim.cs.CurTrial.image.color.rgb;
        position=Stim.cs.CurTrial.position_selection;
        
    case('alt')
        switch(solenoid)
            case(1)
                max=332;
            case(2)
                max=286;
        end
        level=Stim.cs_alt.CurTrial.image.rwd_mag/Stim.cs_alt.CurTrial.image.rwd_num;
        levelp=(max-level)/max;
        barcolor=Stim.cs_alt.CurTrial.image.color.rgb;
        position=Stim.cs_alt.CurTrial.position_selection;
end
        
%OK--writing this note months after I initially wrote the code...
%this looks like a mistake, that the level I am coding (levelp) is actually
%the inverse of what it shoud be, and I think it is but I also think the
%picture is displayed upside down, and that this was a hack I implemented.
%Need to come back and verify....

level=round(800*levelp);
%m = zeros(1000,1000,3);
if level < 11
    bar=1:11;
elseif level == 800
    bar = 789:800;
else
    bar=level-5:level+5;
end

if position==2
    position=randsample([1,5],1);
end
    

%The switch here is implemented so that the value bars image is reflected
%on either side of the FP, not just shifted

switch(position)
    case(5)
        m(1:10,500:800,1)=barcolor(1);
        m(90:100,600:800,1)=barcolor(1);
        m(190:200,600:800,1)=barcolor(1);
        m(290:300,600:800,1)=barcolor(1);
        m(390:400,500:800,1)=barcolor(1);
        m(490:500,600:800,1)=barcolor(1);
        m(590:600,600:800,1)=barcolor(1);
        m(690:700,600:800,1)=barcolor(1);
        m(790:800,500:800,1)=barcolor(1);
        m(:,1:20,1)=barcolor(1);
        m(:,780:800,1)=barcolor(1);

        m(1:10,500:800,2)=barcolor(2);
        m(90:100,600:800,2)=barcolor(2);
        m(190:200,600:800,2)=barcolor(2);
        m(290:300,600:800,2)=barcolor(2);
        m(390:400,500:800,2)=barcolor(2);
        m(490:500,600:800,2)=barcolor(2);
        m(590:600,600:800,2)=barcolor(2);
        m(690:700,600:800,2)=barcolor(2);
        m(790:800,500:800,2)=barcolor(2);
        m(:,1:20,2)=barcolor(2);
        m(:,780:800,2)=barcolor(2);

        m(1:10,500:800,3)=barcolor(3);
        m(90:100,600:800,3)=barcolor(3);
        m(190:200,600:800,3)=barcolor(3);
        m(290:300,600:800,3)=barcolor(3);
        m(390:400,500:800,3)=barcolor(3);
        m(490:500,600:800,3)=barcolor(3);
        m(590:600,600:800,3)=barcolor(3);
        m(690:700,600:800,3)=barcolor(3);
        m(790:800,500:800,3)=barcolor(3);
        m(:,1:20,3)=barcolor(3);
        m(:,780:800,3)=barcolor(3);

    case(1)
        m(1:10,1:300,1)=barcolor(1);
        m(90:100,1:200,1)=barcolor(1);
        m(190:200,1:200,1)=barcolor(1);
        m(290:300,1:200,1)=barcolor(1);
        m(390:400,1:300,1)=barcolor(1);
        m(490:500,1:200,1)=barcolor(1);
        m(590:600,1:200,1)=barcolor(1);
        m(690:700,1:200,1)=barcolor(1);
        m(790:800,1:300,1)=barcolor(1);
        m(:,1:20,1)=barcolor(1);
        m(:,780:800,1)=barcolor(1);

        m(1:10,1:300,2)=barcolor(2);
        m(90:100,1:200,2)=barcolor(2);
        m(190:200,1:200,2)=barcolor(2);
        m(290:300,1:200,2)=barcolor(2);
        m(390:400,1:300,2)=barcolor(2);
        m(490:500,1:200,2)=barcolor(2);
        m(590:600,1:200,2)=barcolor(2);
        m(690:700,1:200,2)=barcolor(2);
        m(790:800,1:300,2)=barcolor(2);
        m(:,1:20,2)=barcolor(2);
        m(:,780:800,2)=barcolor(2);

        m(1:10,1:300,3)=barcolor(3);
        m(90:100,1:200,3)=barcolor(3);
        m(190:200,1:200,3)=barcolor(3);
        m(290:300,1:200,3)=barcolor(3);
        m(390:400,1:300,3)=barcolor(3);
        m(490:500,1:200,3)=barcolor(3);
        m(590:600,1:200,3)=barcolor(3);
        m(690:700,1:200,3)=barcolor(3);
        m(790:800,1:300,3)=barcolor(3);
        m(:,1:20,3)=barcolor(3);
        m(:,780:800,3)=barcolor(3);

        
end


m(bar,21:779,1) = barcolor(1);
m(bar,21:779,2) = barcolor(2);
m(bar,21:779,3) = barcolor(3);

m=uint8(m);
