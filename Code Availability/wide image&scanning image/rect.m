function y = rect(a,x)
y=zeros(size(x));
y(abs(x)<=(a/2))=1;
end

