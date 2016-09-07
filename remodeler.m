[lon,lat,ev,nv,eve,nve,neve,site,uv,uve]=textread(['stations.txt'],'%f %f %f %f %f %f %f %s %f %f','commentstyle','shell');
fid = fopen('remodeled_results.txt','wt');
for s = 1:length(site)
    
    siter = site(s);
    sitera = char(siter);
    siterb = sprintf('%s',sitera);
    
    a = load(['rawresults/' siterb '.txt']);
    
    t = a(:,1);
    
    
    n = a(:,4);
    e = a(:,5);
    u = a(:,6);
    
    np1 = a(:,10);
    ep1 = a(:,11);
    up1 = a(:,12);
    
    
    anp1 = find(abs(np1) > 0.50);
    aep1 = find(abs(ep1) > 0.50);
    aup1 = find(abs(up1) > 0.50);
    
    ap1 = [anp1;aep1;aup1];
    
    ap1 = sort(ap1);
    
    ap1 = unique(ap1);
    
    
    
    AN1 = [];
    ANN1 = [];
    

    
    
    for i = 1:length(n);
        dt = t(i)-t(1);
        ANN1 = [1 dt];
    
        if (~isempty(ap1))
            for j = 1:length(ap1)
                ANN1 = [ANN1 heaviside2(t(i),t(ap1(j)))];
            end
        end
        
        
        AN1 = [AN1;ANN1]; 
        
    end
    N1 = lsqlin(AN1,n);
    
    
    E1 = lsqlin(AN1,e);
    
    
    U1 = lsqlin(AN1,u);
    
    
    
    fprintf(fid,'%s %1.4f %1.4f %1.4f %1.4f %1.4f\n',siterb,a(1,13),a(1,14),N1(2),E1(2),U1(2));

    
    
    
    %     x = zeros(length(a(:,1)),1);
    %     for i = 1:length(a(:,1))
    %         x(i) = x(i)+X(1)+X(2)*(a(i,1)-a(1,1));
    %         for j = 1:length(a1)
    %             x(i) = x(i)+X(2+j)*heaviside(a(i,1),a(a1(j),1));
    %         end
    %     end
end

fclose(fid);