% //////////////////////////////////////////////////////////////////////
% Abbring and Salimans (2021), Figure 1 (fka laplace/invtest.m)
% - Approximation Error of the Log Likelihood for Various M
%
% Dependencies: strkdur.asc migaussmle.m lhmigauss.m numinvlap.m
% Output: - fig1.csv
% //////////////////////////////////////////////////////////////////////

%% clear screen and workspace
clear
clc
format long

%% settings
dispplot = false; % set to true to have script plot results

nrunobs=4;
nrshocks=0;
est=0;

%% read strike data
rawdata=load('strkdur.asc');

x=rawdata(:,2);
y=rawdata(:,1);
cens=false(length(y),1);

timea = [];
timen = [];
for j=1:100
fprintf('.');
%% parameters analytical, estimated or start

if est
    [parMLE, stderr]=migaussmle(y,cens,x,nrunobs);
else
    % set starting values
    mm=mean(y);
    mu=1/mm;
    var=mean(1./y-mu);
    v=exp(randn(nrunobs-1,1));
    p=ones(nrunobs-1,1)/nrunobs;
    if isempty(x);
        beta=[];
    else
        beta=zeros(size(x,2),1);
    end
    parMLE=[mu; var; v; p; beta];
end

mu=parMLE(1);
var=parMLE(2);
v=[1; parMLE(3:1+nrunobs)];
p=[1-sum(parMLE(2+nrunobs:2*nrunobs)); parMLE(2+nrunobs:2*nrunobs)];
beta=parMLE(end);

%% parameters numerical

% rescale
var=var/mu^2;
v=v/mu;
p=log(p);
p=p-p(1)+1;
p=p(2:end);

% convert to parameter vector of startvalues
par2=[log(var); p; log(v); beta];

%% test
tic
a_probs=lhmigauss(parMLE,y,cens,x,nrunobs);
timea=[timea;toc];
tic
n_probs=numinvlap(@pointpoint,par2,y,cens,x,nrunobs,nrshocks)./y;
timen=[timen;toc];
errs=[a_probs abs(a_probs-n_probs) abs(a_probs-n_probs)./n_probs];
maxerrs=max(errs);
meanerrs=mean(abs(errs));
logerr=abs(sum(log(n_probs))-sum(log(a_probs)));

%% graph maker
le{j}=zeros(30,1);
for i=1:30
    le{j}(i)=log(abs(sum(log(numinvlap2(@pointpoint,par2,y,i,cens,x,nrunobs,nrshocks)./y))-sum(log(a_probs))));
end
end
fprintf('\n');
lerr=zeros(30,1);
for j=1:100
    lerr=lerr+le{j}/100;
end
if dispplot
    llhplot(exp(lerr))
end
f1=fopen('fig1times.tex','w'); 
fprintf(f1,'Note: Mean calculation times are $%0.5e$ seconds (analytical) and ',...
    mean(timea));
fprintf(f1,'$%0.5e$ seconds (numerical inversion), so that ',mean(timen));
fprintf(f1,'mean time numerical $=%6.2f\\times$ mean time analytical\n',...
    mean(timen)/mean(timea));
fclose(f1);

%% Export data to csv file for TikZ

f1=fopen('fig1.csv','w');                % mhtellherr.csv
fprintf(f1,'M, llherr, dummy\n');
fprintf(f1,'%6.0f, %6.6f, 1.0\n',[(1:30)' lerr/log(10)]');
fclose(f1);
