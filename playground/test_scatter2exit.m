% clear all;
g=gpuDevice();
reset(g);

wavelength=1;
beta=1e-4;
delta=1e-4;
maxangle=25;
minangle=1;
dz=1/4;
gpu=true;

ldx=[1/2,1/4];
lN=[2*1024,4*1024];
lradius=[20,200];


maxn=numel(lN)*numel(ldx)*numel(lradius);
results(maxn).dx=0;
 n=0;
ndx
% for nN=1:numel(lN)
%     for ndx=1:numel(ldx)
%         for nradius=1:numel(lradius)
            n=n+1;
%             dx=ldx(ndx);
%             N=lN(nN);
%             radius=lradius(nradius);
dx=0.5;N=4*1024;radius=20;
            results(n).dx=dx;
            results(n).N=N;
            results(n).radius=radius;
            
            objects=cell(1);
            objects{1}=scatterObjects.sphere();
            objects{1}.radius=radius;
            objects{1}.beta=beta;
            objects{1}.delta=delta;
            
            
            %%
            tic;
            exitM=(multislice(wavelength,objects,N,dx,dz,gpu));
            exitM=exitM-exitM(1);
            exitM=gather(exitM);
            toc;
            %%
            tic;
            scatter1=(abs(ft2(exitM)).^2*(dx^2));
            % [~,rM]=rprofil(scatter1,N/2);
            % clear scatter;
            % rM=gather(rM);
            % scatter=gather(scatter);
          
            toc;
            
            %%
            tic
            exitMp=pad2size((exitM),2*N,exitM(1));
            scatter2=(abs(ft2(exitMp)).^2*(dx^2));
            clear exitMp
            toc
            
            tic
            exitMpp=pad2size((exitM),4*N,exitM(1));
            scatter4=(abs(ft2(exitMpp)).^2*(dx^2));
            clear exitMpp
            toc
            
            clear exitM
            %%
            reset(g);
            x1=asin(((0:N/2-1)*1/(N*dx))*wavelength)';
            x2=asin(((0:N-1)*1/(2*N*dx))*wavelength)';
            x4=asin(((0:2*N-1)*1/(4*N*dx))*wavelength)';
            % xHQ=asin(((0:(4*N)-1)*1/(8*N*dx))*wavelength)';
            a1=single(anglemap(N/2,2*dx,wavelength)*180/pi);
            a2=single(anglemap(2*N/2,2*dx,wavelength)*180/pi);
            a4=single(anglemap(4*N/2,2*dx,wavelength)*180/pi);
            
            %%
            tic
            % [~,rmie]=mie(wavelength,radius,beta,delta,x1);
            % [~,rmie2]=mie(wavelength,radius,beta,delta,x2);
            % [~,rmie4]=mie(wavelength,radius,beta,delta,x4);
            % [~,rmieHQ]=mie(wavelength,radius,beta,delta,xHQ);
            
%             a1=a1(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
%             a2=a2(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
%             a4=a4(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
            scatter1=scatter1(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
            scatter2=scatter2(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
            scatter4=scatter4(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
            scatter1=normalize2(scatter1,~isnan(a1));
            scatter2=normalize2(scatter2,~isnan(a2));
            scatter4=normalize2(scatter4,~isnan(a4));
            
            toc
            %%
            imie1=mie_scatter(wavelength,radius,beta,delta,N/2,2*dx);
            imie2=mie_scatter(wavelength,radius,beta,delta,2*N/2,2*dx);
            imie4=mie_scatter(wavelength,radius,beta,delta,4*N/2,2*dx);
            
%             imie1=imie1(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
%             imie2=imie2(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
%             imie4=imie4(1+1/4*end:3/4*end,1+1/4*end:3/4*end);
%             
            imie1=normalize2(imie1,~isnan(a1));
            imie2=normalize2(imie2,~isnan(a2));
            imie4=normalize2(imie4,~isnan(a4));
            
            %% full
            err1=(scatter1-imie1)./imie1;
            err2=(scatter2-imie2)./imie2;
            err4=(scatter4-imie4)./imie4;
            
            results(n).medianerror{1}=median(abs(err1(a1>minangle&a1<maxangle)));
            results(n).medianerror{2}=median(abs(err2(a2>minangle&a2<maxangle)));
            results(n).medianerror{3}=median(abs(err4(a4>minangle&a4<maxangle)));
            
            wait(g)
            reset(g)
            wait(g)
            cs1=icorrectoffsetspan(scatter1,imie1,a1>minangle&a1<maxangle);
            wait(g)
            reset(g)
            wait(g)
            cs2=icorrectoffsetspan(scatter2,imie2,a2>minangle&a2<maxangle);
            wait(g)
            reset(g)
            wait(g)
            cs4=icorrectoffsetspan(scatter4,imie4,a4>minangle&a4<maxangle);
            
            cerr1=(cs1-imie1)./imie1;
            cerr2=(cs2-imie2)./imie2;
            cerr4=(cs4-imie4)./imie4;
            
            results(n).cmedianerror{1}=median(abs(cerr1(a1>minangle&a1<maxangle)));
            results(n).cmedianerror{2}=median(abs(cerr2(a2>minangle&a2<maxangle)));
            results(n).cmedianerror{3}=median(abs(cerr4(a4>minangle&a4<maxangle)));
            %%
            
            [~,rerr1]=rprofil(err1,N/4);
            [~,crerr1]=rprofil(cerr1,N/4);
            results(n).rerr{1}=rerr1;
            results(n).crerr{1}=crerr1;
            
            [~,rerr2]=rprofil(err2,2*N/4);
            [~,crerr2]=rprofil(cerr2,2*N/4);
            results(n).rerr{2}=rerr2;
            results(n).crerr{2}=crerr2;
            
            [~,rerr4]=rprofil(err4,4*N/4);
            [~,crerr4]=rprofil(cerr4,4*N/4);
            results(n).rerr{3}=rerr4;
            results(n).crerr{3}=crerr4;
            
            
            [~,r1]=rprofil(scatter1,N/4);
            [~,r2]=rprofil(scatter2,2*N/4);
            [~,r4]=rprofil(scatter4,4*N/4);
            results(n).profil{1}=r1;
            results(n).profil{2}=r2;
            results(n).profil{3}=r4;
            
            
            [~,cr1]=rprofil(cs1,N/4);
            [~,cr2]=rprofil(cs2,2*N/4);
            [~,cr4]=rprofil(cs4,4*N/4);
            [~,rm]=rprofil(imie4,4*N/4);
            results(n).cprofil{1}=cr1;
            results(n).cprofil{2}=cr2;
            results(n).cprofil{3}=cr4;
            results(n).mieprofil=rm;
            results(n).x{1}=x1(1:end/2)/pi*180;
            results(n).x{2}=x2(1:end/2)/pi*180;
            results(n).x{3}=x4(1:end/2)/pi*180;
            results(n).angle4=a4;
            results(n).cscatter4=cs4;
            results(n).cerr4=cerr4;
            
            clear cs1 cs2 cs4 err1 err2 err4 r1 r2 r4 rerr1 rerr2 rerr4 rm rM x1 x2 x4 cerr1 cerr2 cerr4 cr1 cr2 cr4 crerr1 crerr2 crerr4
            
            
            %% halfimage
            himie1=halfimage(imie1);
            himie2=halfimage(imie2);
            himie4=halfimage(imie4);
            
            hscatter1=halfimage(scatter1);
            hscatter2=halfimage(scatter2);
            hscatter4=halfimage(scatter4);
            
            ha1=single(halfimage(double(a1)));
            ha2=single(halfimage(double(a2)));
            ha4=single(halfimage(double(a4)));
            
            clear a1 a2 a4 imie1 imie2 imie4 scatter1 scatter2 scatter4
            
            himie1=normalize2(himie1,~isnan(ha1));
            himie2=normalize2(himie2,~isnan(ha2));
            himie4=normalize2(himie4,~isnan(ha4));
            
            herr1=(hscatter1-himie1)./himie1;
            herr2=(hscatter2-himie2)./himie2;
            herr4=(hscatter4-himie4)./himie4;
            
            results(n).medianerror{4}=median(abs(herr1(ha1>minangle&ha1<maxangle)));
            results(n).medianerror{5}=median(abs(herr2(ha2>minangle&ha2<maxangle)));
            results(n).medianerror{6}=median(abs(herr4(ha4>minangle&ha4<maxangle)));
            
            wait(g)
            reset(g)
            wait(g)
            hcs1=icorrectoffsetspan(hscatter1,himie1,ha1>minangle&ha1<maxangle);
            wait(g)
            reset(g)
            wait(g)
            hcs2=icorrectoffsetspan(hscatter2,himie2,ha2>minangle&ha2<maxangle);
            wait(g)
            reset(g)
            wait(g)
            hcs4=icorrectoffsetspan(hscatter4,himie4,ha4>minangle&ha4<maxangle);
            
            hcerr1=(hcs1-himie1)./himie1;
            hcerr2=(hcs2-himie2)./himie2;
            hcerr4=(hcs4-himie4)./himie4;
            
            results(n).cmedianerror{4}=median(abs(hcerr1(ha1>minangle&ha1<maxangle)));
            results(n).cmedianerror{5}=median(abs(hcerr2(ha2>minangle&ha2<maxangle)));
            results(n).cmedianerror{6}=median(abs(hcerr4(ha4>minangle&ha4<maxangle)));
            %%
            
            [~,hrerr1]=rprofil(herr1,N/4/2);
            [~,hcrerr1]=rprofil(hcerr1,N/4/2);
            results(n).rerr{4}=hrerr1;
            results(n).crerr{4}=hcrerr1;
            
            [~,hrerr2]=rprofil(herr2,2*N/4/2);
            [~,hcrerr2]=rprofil(hcerr2,2*N/4/2);
            results(n).rerr{5}=hrerr2;
            results(n).crerr{5}=hcrerr2;
            
            [~,hrerr4]=rprofil(herr4,4*N/4/2);
            [~,hcrerr4]=rprofil(hcerr4,4*N/4/2);
            results(n).rerr{6}=hrerr4;
            results(n).crerr{6}=hcrerr4;
            
            
            [~,hr1]=rprofil(hscatter1,N/4/2);
            [~,hr2]=rprofil(hscatter2,2*N/4/2);
            [~,hr4]=rprofil(hscatter4,4*N/4/2);
            results(n).profil{4}=hr1;
            results(n).profil{5}=hr2;
            results(n).profil{6}=hr4;
            
            
            [~,hcr1]=rprofil(hcs1,N/4/2);
            [~,hcr2]=rprofil(hcs2,2*N/4/2);
            [~,hcr4]=rprofil(hcs4,4*N/4/2);
            [~,hrm]=rprofil(himie4,4*N/4/2);
            results(n).cprofil{4}=hcr1;
            results(n).cprofil{5}=hcr2;
            results(n).cprofil{6}=hcr4;
            results(n).hmieprofil=hrm;
            results(n).x{4}=ha1(end/2+1:end,end/2+1);
            results(n).x{5}=ha2(end/2+1:end,end/2+1);
            results(n).x{6}=ha4(end/2+1:end,end/2+1);
            results(n).hangle4=ha4;
            results(n).hcscatter4=hcs4;
            results(n).hcerr4=hcerr4;
            
            clear ha1 ha2 ha4 hcerr1 hcerr2 hcerr4 hcr1 hcr2 hcr4 hcrerr1 hcrerr2 hcrerr4 hcs1 hcs2 hcs4 herr1 herr2 herr4 himie1 himie2 himie4 hr1 hr2 hr4 hrerr1 hrerr2 hrerr4 hrm hscatter1 hscatter2 hscatter4
%         end
%     end
% end