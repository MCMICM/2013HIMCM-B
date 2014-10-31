function BankServiceProblem
% HIMCM 2013 Problem B: Bank Service Problem
%
% The bank manager is trying to improve customer satisfaction by offering 
% better service. Management wants the average customer to wait less than 2 
% minutes for service and the average length of the queue (length of the 
% waiting line) to be 2 persons or fewer. The bank estimates it serves about
% 150 customers per day. The existing arrival and service times are given 
% in the tables below.
% 
%                         Table 1: Arrival times
%  ----------------------------------------------------------------------
%  Time between arrival (min.) | 0    | 1    | 2    | 3    | 4    | 5
%  Probability                 | 0.10 | 0.15 | 0.10 | 0.35 | 0.25 | 0.05
%  ----------------------------------------------------------------------
%
%                         Table 2: Service times
%  ----------------------------------------------------------------------
%  Service Time (min.)         | 1    | 2    | 3    | 4    
%  Probability                 | 0.25 | 0.20 | 0.40 | 0.15 
%  ----------------------------------------------------------------------
%
%  (1) Build a mathematical model of the system.
%  (2) Determine if the current customer service is satisfactory according 
%      to the manager guidelines. If not, determine, through modeling, the 
%      minimal changes for servers required to accomplish the manager’s goal.
%  (3) In addition to the contest’s format, prepare a short 1-2 page non-
%      technical letter to the bank’s management with your final recommendations.
%
%%-------------------------------------------------------------------------
%  zhou lvwen: zhou.lv.wen@gmail.com
%%-------------------------------------------------------------------------

n = 150;   %The bank estimates it serves about 150 customers per day

% between arrival time and probability
ta = [5 4 3 2 1 0];  pa = [0.05 0.25 0.35 0.10 0.15 0.10]; 

% service time and probability
ts = [  4 3 2 1  ];  ps = [     0.15 0.40 0.20 0.25     ];

% test 100 times
for i = 1:100
    [Twait(i,:), line(i,:)] = bankservice(n, ta, pa, ts, ps);
end

% wait time
figure
hist(Twait(:));
xlabel('time')
ylabel('number of customers')

% line length
figure
hist(line(:))
xlabel('line length')
ylabel('number of customers')


function [Twait, line] = bankservice(n, ta, pa, ts, ps)

pacum = cumsum(pa); % cumulative sum of between arrival time probability
pscum = cumsum(ps); % cumulative sum of service time probability

% get each customers' arrival time
Tarrival = rand(1,n);
for i = 1:length(pa)
    Tarrival(Tarrival<pacum(i)) = ta(i);
end
Tarrival = cumsum(Tarrival);

% get each service time for customers 
Tservice = rand(1,n);
for i = 1:length(ps)
    Tservice(Tservice<pscum(i)) = ts(i);
end

Tstart = zeros(1,n); % start service time
Tleave = zeros(1,n); % leave time
Twait  = zeros(1,n); % wait time
line   = zeros(1,n); % line length


% Tstart(i) = max{ Tleave(i-1), Tarrival(i) }
% Tleave(i) = Tstart(i) + Tservice(i)
% Twait(i)  = Tleave(i) - Tstart(i) - Tservice(i)

% for first customer
Tstart(1) = Tarrival(1);
Tleave(1) = Tstart(1) + Tservice(1);
Twait(1) = Tleave(1) - Tarrival(1) - Tservice(1);
line(1) = 0;

% for 2:n customers
for i = 2:n
   Tstart(i) = max(Tleave(i-1), Tarrival(i));
   k = i-1;
   while ( k>0 )&&( Tarrival(i)<Tleave(k) )
       line(i) = line(i) + 1;
       k = k - 1;
   end
   Tleave(i) = Tstart(i) + Tservice(i);
   Twait(i) = Tleave(i) - Tarrival(i) - Tservice(i);
end