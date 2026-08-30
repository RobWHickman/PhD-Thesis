function cmap = GenerateColorMap(col_mat,sharp)

% col_mat =  [0 0 1;0 1 0;1 0 0];
    
if nargin<2
    sharp=0;
end

[r,c] = size(col_mat);
cm = zeros(100,3);
ix = linspace(0,100,r);
ix(ix==0)=1;
cm(ix,:) = col_mat;

for i = 1:c
    if sharp~=0
        fn = (0:.01:1).^sharp;
        fnn = [fn,flip(fn)];
        %     elseif strcmp(sharp,'unsharp')
        %         fn = log(0:.01:1);
        %         fnn = [fn,flip(fn)];
        new_col_mat(:,i) = conv(cm(:,i),fnn,'same');
    else
        new_col_mat(:,i) = col_mat(:,i);
    end
end
for i=1:3
    cmap(:,i)=interp1(0:1/(length(new_col_mat(:,1))-1):1,new_col_mat(:,i),0:1/255:1);
end
if any(any(cmap>1))||any(any(cmap<0))
cmap = MinMaxFS(cmap);
end