%Hyp1 Using 2 Variables in a power 3 equation

clear all   
ds = datastore('heart_DD.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
T = read(ds);
size(T);
Alpha=.001;
m=length(T{1:175,1});
mTest=length(T{176:end,1});
% U0=T{:,2};
U=T{1:175,[1 4]};
UTest=T{176:end,[1 4]};
% U1=T{:,13:14};
% U2=T{:,20:21};
% X=[ones(m,1) U U1 U.^2 U.^3];
X=[ones(m,1) (U) U.^2 U.^3];
XTest=[ones(mTest,1) (UTest) UTest.^2 UTest.^3];


n=length(X(1,:));
for w=2:n   
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));
    end
end

nTest=length(XTest(1,:));
for w=2:nTest    
    if max(abs(XTest(:,w)))~=0
    XTest(:,w)=(XTest(:,w)-mean((XTest(:,w))))./std(XTest(:,w));
    end
end

Y=T{1:175,14}/mean(T{1:175,14});
YTest=T{176:end,14}/mean(T{1:175,14});
Theta=zeros(n,1);
k=1;
Y=Y';
XTest=XTest';
X=X';
YTest=YTest';
E(k)=-(1/(m))*sum((Y.*log(1./(1+exp((-Theta')*X))))+((1-Y).*log(1./(1+exp((-Theta')*X))))); %Calculation Error (Cost function)

R=1;
while R==1
Alpha=Alpha*1;
Theta=Theta-(Alpha/m)*X*(((log(1./(1+exp((-Theta')*X))))-Y)');
k=k+1
E(k)=-(1/(m))*sum((Y.*log(1./(1+exp((-Theta')*X))))+((1-Y).*log(1./(1+exp((-Theta')*X)))));
if E(k-1)-E(k)<0
    break
end 
q=(E(k-1)-E(k))./E(k-1);
if q <.000001;
    R=0;
end
end
figure(1)
plot(E)

 Etest=-(1/(mTest))*sum((YTest.*log(1./(1+exp((-Theta')*XTest))))+((1-YTest).*log(1./(1+exp((-Theta')*XTest)))));
TargetNew=(1./(1+exp((-Theta')*XTest)));

% MSE=((TargetNew-YTest).^2)/(mTest);
% MSEsum=sum(MSE);
% figure(2)
% plot(MSE)
