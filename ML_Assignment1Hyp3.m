%Second Hypothesis By Using linearly Normalized Bedrooms Bathrooms , sqft Living and sqft
%lot

clc
close all
clear all
ds = tabularTextDatastore('house_data_complete.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
T = read(ds);
size(T);
Alpha=.01;


U0=T{1:18000,2} ;  % Data 2
%U=T{1:18000,4:19};    % Data from 4 to 19

U1=T{1:18000,20:21};    %Data 20 and 21
%U2=U.^2;
%U3= U.^3;

UTrain = T{1:18000,[3 4 5 6]};
UTest = T{18001:end,[3 4 5 6]};
m=length(UTrain);
mTest=length(UTest);

%X=[ones(m,1) U U1 U.^2 U.^3];     
X=[ones(m,1) UTrain  ];
XTest=[ones(mTest,1) UTest ];

n=length(X(1,:));
for w=2:n
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));
    end
end
f = length(XTest(1,:));
for w=2:f
    if max(abs(XTest(:,w)))~=0
    XTest(:,w)=(XTest(:,w)-mean((XTest(:,w))))./std(XTest(:,w));
    end
end

YTrain=T{1:18000,3}/mean(T{1:18000,3});
YTest=T{18001:end,3}/mean(T{1:18000,3});
Theta=zeros(n,1);
k=1;

E(k)=(1/(2*m))*sum((X*Theta-YTrain).^2);   %Error Calculations (Cost Function).

R=1;
while R==1
Alpha=Alpha*1;
Theta=Theta-(Alpha/m)*X'*(X*Theta-YTrain);  %Updating All Thetas using matrix format.
k=k+1
E(k)=(1/(2*m))*sum((X*Theta-YTrain).^2);    %New Cost Function.
if E(k-1)-E(k)<0
    break
end 
q=(E(k-1)-E(k))./E(k-1);               %Diff between old and new errors in percentage.
if q <.000001;
    R=0;
end
end

YNew=((XTest*Theta))

figure()
plot(E)


MSE=sum((YTest-YNew).^2)/(2*mTest) ;
