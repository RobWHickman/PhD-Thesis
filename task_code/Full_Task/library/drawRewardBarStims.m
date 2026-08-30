function drawRewardBarStims
global VisParam TaskOp
scrCtr = VisParam.scr_rect(3:4)/2;

Stim.choices.target_center.x = scrCtr(1) + [-300; 300]; % stim center
Stim.choices.target_center.y = repmat(scrCtr(2),2,1);

% bar stim params     
Stim.choices.barH = 150;
Stim.choices.size = 30;
Stim.choices.distCtr = 300;
Stim.choices.szHB = 30;

% proportional payoff in the bars:
rew = [0 50 75 100];
Stim.choices.alt = rew;
selRew = randperm(length(rew)); % equal prob. 
Stim.choices.rewRange = [50 150];
Stim.choices.actRew = rew(sort(selRew(1:2)));
Stim.choices.bkgclr = [255 255 255];

Stim.choices.chocolor = [256 0 0];
Stim.choices.tolerance_window = 200;
Stim.choices.filter_time = 4.75;

% TaskOp.choJuice(TaskOp.choPos) = 50;%abs((50 ./1000)-0.005);


% horizontal bars -px-
% cs.rewRange = [0 1500]; % in microlitres
% cs.actRew = 500;
% cs.position = [10 10 300 500];
% cs.size = 1;
% cs.hBarHeigth = 100;
cs = Stim.choices;


propRew = (cs.actRew-min(cs.rewRange))./(max(cs.rewRange)-min(cs.rewRange));
pFpos  = [ cs.position(1),...
           cs.position(4)-(cs.size*propRew),...
           cs.position(3),...
           cs.position(4)-(cs.size*propRew)+cs.hBarHeigth];      
csPos = pFpos;
       pos = num2str([csPos; pFpos]);
wb = ['Screen(''FillRect'',VisParam.scr_handle,[255 255 255],[10 10 110 510]);'];
hb = ['Screen(''FillRect'',VisParam.scr_handle,[255 0 0],[10 310 110 350]);'];
wbf = ['Screen(''FrameRect'',VisParam.scr_handle,[255 0 0],[10 10 110 510],3);'];

% in case we have a '0' reward value
if cs.actRew>0
    csstr = [wb,' ', hb, wbf];
else
    csstr = [wb,wbf];
end

    cshdl = [];
    tarHdl = zeros(3,1);
    sz = Stim.target.position(3:4)-Stim.target.position(1:2);
    cs = Stim.CSon;
%     cssz = cs.position(3:4)-cs.position(1:2);
    % target and rest cue 
    for i=1:3,
                sz = cs.hBarHeigth*2;
                cshdl(i) = rectangle(...
                'Position', [pFpos(1) VisParam.scr_rect(4)-pFpos(2) pFpos(3)-pFpos(1) sz],...
                'FaceColor',cs.chocolor./256,...
                'Parent',h_monitor,...
                'Visible', 'off');
    end
    
            onehb  = [ctr(1)-pF.distCtr-pF.size, ctr(2)-pF.barH,...
                   ctr(1)-pF.distCtr+pF.size, ctr(2)+pF.barH];

        twohb  = [ctr(1)+pF.distCtr-pF.size, ctr(2)-pF.barH,...
                    ctr(1)+pF.distCtr+pF.size, ctr(2)+pF.barH];

        % horizontal bars -px-
        propRew = (pF.actRew-min(pF.rewRange))./(max(pF.rewRange)-min(pF.rewRange));
        pFpos(1,:)  = [ctr(1)-pF.distCtr-pF.size,...
               onehb(4)-(pF.barH*2*propRew(TaskOp.choPos(1)))-pF.szHB,...
               ctr(1)-pF.distCtr+pF.size,...
               onehb(1,4)-(pF.barH*2*propRew(TaskOp.choPos(1)))];      
        pFpos(2,:)  = [ctr(1)+pF.distCtr-pF.size,...
                onehb(1,4)-(pF.barH*2*propRew(TaskOp.choPos(2)))-pF.szHB,...
                ctr(1)+pF.distCtr+pF.size,...
                onehb(1,4)-(pF.barH*2*propRew(TaskOp.choPos(2)))];
        % converting matrix to char and then to evaluatable string ain't
        % allowed!
        pos(:,:,1) = [onehb; pFpos(1,:)];
        pos(:,:,2) = [twohb; pFpos(2,:)];
        for i = 1:2,
            wb = ['Screen(''FillRect'',VisParam.scr_handle,[',num2str(pF.bkgclr),'],[',num2str(pos(1,:,i)),']);'];
            hb = ['Screen(''FillRect'',VisParam.scr_handle,[',num2str(pF.chocolor),'],[',num2str(pos(2,:,i)),']);'];
            wbf = ['Screen(''FrameRect'',VisParam.scr_handle,[',num2str(pF.chocolor),'],[',num2str(pos(1,:,i)),'],3);'];
            % in case we have a '0' reward value
            if pF.actRew(TaskOp.choPos(i))>0
%                 pfacq = [pos(2,1:2,i)-50 pos(2,3:4,i)+50]; % green circle
%                 around the horizontal bar
                pfstr(i).s = [wb,' ', hb, wbf];
            else
                pfstr(i).s = [wb,wbf];
                % momo related
%                 pF.chocolor(i,:) = [0 255 255];%light blue
%                 pFpos(i,2) = ctr(2);
            end
            pfacq = [pos(1,1:2,i)-50 pos(1,3:4,i)+50]; % green circle around the whole stim
            pfacqs = ['Screen(''FrameOval'', VisParam.scr_handle,[0 256 0],[',num2str(pfacq),'],3);'];
            pfacqstr(i).s = [pfstr(i).s pfacqs];
        end
        pF.size = [10,10];