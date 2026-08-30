function S = SMRX_to_Wavemark(smrx_fname,nBins)

if nargin < 2
    nBins = 500;
end

cedpath = 'C:\CEDMATLAB\CEDS64ML';
CEDS64LoadLib( cedpath );

fhand = CEDS64Open(smrx_fname);

nTics = CEDS64MaxTime(fhand);
[ dSeconds ] = CEDS64TicksToSecs( fhand, nTics );

sFreq = nTics/dSeconds;

[ nEv, evTimes ] = CEDS64ReadEvents( fhand, 2, nTics,  0, -1);

%%
numBins = nBins;
be = linspace(0,nTics,numBins+1);
[n,e,b] = histcounts(double(evTimes),be);

st = [];wv=[];cd=[];
for i=1:numBins
    iN = n(i); 
    if iN == 0
        continue
    end
    iN = iN+1;%+1 to catch spikes that fall on bin edge (I think...)
    [ iRead, ExtMarkers ] = CEDS64ReadExtMarks(fhand, 2, iN, e(i)-1, e(i+1)+1);% the ...e(i)-1, e(i+1)+1... is a sloppy workaround to ensure that it catches all points
    if iRead>0        
        st_tmp = [ExtMarkers.m_Time]';
        wv_tmp = [ExtMarkers.m_Data]';
        cd_tmp = [];
        cd_tmp(:,1) = [ExtMarkers.m_Code1]';
        cd_tmp(:,2) = [ExtMarkers.m_Code2]';
        cd_tmp(:,3) = [ExtMarkers.m_Code3]';
        cd_tmp(:,4) = [ExtMarkers.m_Code4]';
        cdix = [ExtMarkers.m_Code1]'~=0; % take everything but error code
        cd = [cd;cd_tmp(cdix,:)];
        st = [st;st_tmp(cdix,:)];
        wv = [wv;wv_tmp(cdix,:)];
        clear ExtMarkers
    end
end
[~,ia,~] = unique(st); % this is a sloppy workaround to ensure that it catches all points
ust = zeros(length(st),1); % this is a sloppy workaround to ensure that it catches all points
ust(ia) = 1; % this is a sloppy workaround to ensure that it catches all points
ust = logical(ust);

ST = st(ust,:);
CD = cd(ust,:);
WV = wv(ust,:);

S.times = cast(ST,'double')./sFreq;
S.codes = CD;
S.values = WV;
[ iOk ] = CEDS64CloseAll( );
