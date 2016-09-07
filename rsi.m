%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%rsi.m
%This computes the relative strength index for stations across a region
%see Crowell et al., 2016 for details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Usage:
%1: Download time series data from  garner.ucsd.edu
%/pub/timeseries/measures/ats/WesternNorthAmerica
%generally use filtered, residual, combination
%2: Unpack tar file and place files in data
%3: Create station file
%4: Run rsi.m
%5: Output will be individual station files in folder results and a
%Individual station files are output as follows:
%time,year,day,north(mm),east(mm),up(mm),north rsi, east rsi, up rsi,
%north prob, east prob, up prob
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
treatment = 'Filter'; % can be Filter, Clean or Raw
trend = 'Resid'; % can be Resid, Detrend, or Trend
startyear = 2005; %starting year
stopyear = 2015; % stopping year, this year is included, i.e. would have december 20XX.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Define Regions, read sites
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[lon,lat,ev,nv,eve,nve,neve,site,uv,uve]=textread(['stations.txt'],'%f %f %f %f %f %f %f %s %f %f','commentstyle','shell');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create Vectors of times
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d1 = 0.5:364.5;
d2 = 0.5:365.5;
d12 = 1:365;
d22 = 1:366;
year1 = startyear;
year2 = stopyear;
years = year1:1:year2;
yeari=[];
dayi=[];
dayi2 = [];
for i = 1:length(years)
    if (leapyear(years(i)) == 0)
        yeari = [yeari years(i)*ones(1,365)];
        dayi = [dayi d1./365];
        dayi2 = [dayi2 d12];
    else
        yeari = [yeari years(i)*ones(1,366)];
        dayi = [dayi d2./366];
        dayi2 = [dayi2 d22];
    end
        
end

timei = yeari+dayi;
timei = timei.*10000;
timei = round(timei);
timei = timei./10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute Values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for s = 1:length(site)  
    siterb = sprintf('%s',char(site(s)));
    fname = ['data/' siterb treatment trend '.neu'];
    [time,year,day,north,east,up,ne,ee,ue]=textread(fname, ...
        '%f %u %u %f %f %f %f %f %f', 'commentstyle','shell');
    
    N = NaN.*ones(1,length(timei));
    E = NaN.*ones(1,length(timei));
    U = NaN.*ones(1,length(timei));
    
    ncma = NaN.*ones(1,length(timei));
    ecma = NaN.*ones(1,length(timei));
    ucma = NaN.*ones(1,length(timei));
    
    for i = 1:length(time)
        aa = find(time(i) == timei);
        N(aa) = north(i);
        E(aa) = east(i);
        U(aa) = up(i);
    end
    
    a1 = find(~isnan(N));
    
    
    nrsi = rsindex(N',21);
    ersi = rsindex(E',21);
    ursi = rsindex(U',21);
    
    ncma = centralmovavg(nrsi,21);
    ecma = centralmovavg(ersi,21);
    ucma = centralmovavg(ursi,21);
    
    [nprobc1] = kurtsolver(ncma);
    [eprobc1] = kurtsolver(ecma);
    [uprobc1] = kurtsolver(ucma);
    

    
    
    fid2 = fopen(['rawresults/' siterb '.txt'],'wt');
    for i = 32:length(timei)
        if (nrsi(i) > 0 && nrsi(i) <= 100)
            if (~isnan(N(i-31:i)))
                fprintf(fid2, ...
                    '%1.4f %1.0f %1.0f %1.4f %1.4f %1.4f %1.2f %1.2f %1.2f %1.4f %1.4f %1.4f %1.4f %1.4f\n', ...
                    timei(i),yeari(i),dayi2(i),N(i),E(i),U(i),ncma(i),ecma(i),ucma(i), nprobc1(i),eprobc1(i),uprobc1(i),lat(s), lon(s));
            end
        end
    end
    fclose(fid2);
    clear nrsi ersi ursi ncma ecma ucma N E U time north east up ne ee ue nprobc1 eprobc1 uprobc1 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Event Aggregator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
direction = ['n';'s';'e';'w';'u';'d'];
for r = 1:6
    fid = fopen(['detectionresults/rsi_' direction(r) '.txt'],'wt');
    for s = 1:length(site)
        siter = site(s);
        sitera = char(siter);
        siterb = sprintf('%s',sitera);
        
        [t,year,day,n,e,u,ncma,ecma,ucma, nprobc1,eprobc1,uprobc1,lats,lons]=textread(['rawresults/' siterb '.txt'],'%f %f %f %f %f %f %f %f %f %f %f %f %f %f');
        if (r == 1 || r == 2)
            prob1 = nprobc1;
        end
        if (r == 3 || r == 4)
            prob1 = eprobc1;
        end
        if (r == 5 || r == 6)
            prob1 = uprobc1;
        end
        
        if (rem(r,2) == 1)
            a1 = find(prob1 > 0);        
        else
            a1 = find(prob1 < 0);
        end
        
        
        for i = 1:length(a1)
            aa = find(t(a1(i)) == t);
            if (abs(prob1(aa)) > 0.0)
            fprintf(fid,'%s %1.4f %1.4f %1.4f %1.4f\n',siterb,t(a1(i)),prob1(a1(i)),lats(i),lons(i));
            end
        end
        
    end
    
fclose(fid);
end


    


    
