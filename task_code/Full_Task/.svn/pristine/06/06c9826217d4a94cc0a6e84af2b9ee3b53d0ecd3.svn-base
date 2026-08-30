function z=findreps(x,reps)
% z=findreps(x,reps)
%
% find elements of x repeated more than or equal to reps times.
%
% sk wrote it

[r c]=size(x);
x=reshape(x,1,r*c);
y=zeros(1,r*c);
w=length(x);
if reps<w,
    for a=1:w-reps+1
        if sum(x(a:a+reps-1)==x(a))==reps
            y(a:a+reps-1)=1;
        end
    end
    z=find(y==1);
else
    z=[];
end