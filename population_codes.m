%%%%%%%  Population vector

clear all;

N=6; % number of neurons
DSi=2*pi/N; % stimulus preference tiling step
Scenter=[DSi/2:DSi:2*pi-DSi/2]; %location of prefered stimuli 

rmax=50; %max firing rate
gamma=3; %slope=2*N/(pi); 
T=0.25; %observation time

M=1000; %trial number
DS=0.01; %stimulus step
S=[DS:DS:2*pi]; %stimulus space
Sest=S; %estimate space
Sigma_Sest=zeros(length(S),1);


for i=1:length(S) %range over stimulus

  Stim=S(i);
  Response=zeros(M,length(Scenter));
  Sest_array=zeros(M,1);
  
  % this wraps the code on the circle
  Scenter_min=zeros(3,length(Scenter));
  Scenter_min(1,:)=Scenter-Stim;
  Scenter_min(2,:)=Scenter-2*pi-Stim;
  Scenter_min(3,:)=Scenter+2*pi-Stim;
  Scenter_min_abs=abs(Scenter_min);
  
  [Y,In]=min(Scenter_min_abs,[],1);
  add1=[0:3:3*(length(In)-1)];
  In2=In+add1;
  
  Scenter_redef=Scenter_min(In2)+Stim; %
  
% Population responses  
for j=1:length(Scenter) %range over cells 
    mean1=(T*rmax)*exp(gamma*(cos(Stim-Scenter(j))-1));
    Response(:,j)=random('poiss',mean1,M,1);  
end
 
%Population estimates
for k=1:M 
    Sest_array(k)=sum(Scenter_redef.*Response(k,:))/sum(Response(k,:)); %population vector         
end

  Sest(i)=mean(Sest_array);
  Error=Sest_array-Stim;
  Error=Error.^2;
  Sigma_Sest(i)=mean(Error);

end

figure;plot(S,Sest);xlabel('S','Fontsize',16), ylabel('S estimate','Fontsize',16),title('Stimulus Estimate','Fontsize',20);
figure;plot(S,Sigma_Sest);xlabel('S','Fontsize',16), ylabel('MS-Error','Fontsize',16),title('Population codes error','Fontsize',20);
figure;hold on;xlabel('S','Fontsize',16), ylabel('Mean Response','Fontsize',16),title('Tuning Curves','Fontsize',20);
for i=1:length(Scenter) 
   plot(S,rmax*exp(gamma*(cos(S-Scenter(i))-1)));
end   





