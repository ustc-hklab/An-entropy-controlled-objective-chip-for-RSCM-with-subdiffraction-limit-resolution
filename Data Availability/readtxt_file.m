clc;clear;

filename='fig.2h_ESF_exp.txt';
s=importdata(filename);
A=s.data;
figure(1)
plot(A(:,1), A(:,2),'o');
axis tight
hold on


filename='fig.2h_ESF_fitting.txt';
s=importdata(filename);
A=s.data;
figure(1)
plot(A(:,1), A(:,2));
axis tight


filename='fig.2h_LSF.txt';
s=importdata(filename);
A=s.data;
figure(1)
plot(A(:,1), A(:,2));
axis tight

