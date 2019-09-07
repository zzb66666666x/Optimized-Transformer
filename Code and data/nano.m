function [Efficiency,Powerdensity,Tcalmax]=nano(V1,V2,n,Viso,Nratio,Pout,f,Tmax,nc,Acore,ds1,ds2,m1,Nl1,Jmax)
    %Inputs are in the form of SI Unit
    
    %System Requirement
    %Inputs V1,V2,n,Viso,Nratio,Pout,f,Tmax
    Irmsp=Pout/V1;
    
    %Fixed Parameters
    %Magnetic Core
    Bsat=0.4;%T
    rho=7.25e3;%kg/m^3
    k=9.662;
    alpha=1.778;
    beta=2.08;
    kc=0.2;
    %Inter Layer & Core Distance
    dins1=0.5e-3;%m(0.5mm)
    dins2=0.5e-3;%m(0.5mm)
    dt1=0.5e-3;%m(0.5mm)
    dt2=0.5e-3;%m(0.5mm)
    dins_int1=0.5e-3;%m(0.5mm)
    dins_int2=0.5e-3;%m(0.5mm)
    dc1=1e-3;%m(1mm)
    dc2=1e-3;%m(1mm)
    
    %Isolation % Clearance Calculations
    Ksaf=0.3;
    dcf1=1e-3;%m(1mm)
    dcl1=10e-3;%m(10mm)
    dcl2=10e-3;%m(10mm)
    diso_min=3.5e-3;%m(3.5mm)
    
    %Free Parameter
    %Inputs nc,Acore,ds1,ds2,m1,Nl1,Jmax
    
    %Dimension Parameter
    %Core Window Dimensions: Litz Dimension
    m2=ceil(m1/n);
    Nl2=round(Nl1/n);
    AR=ceil(Nl1/m1);
    Acore_tol=V1/(4*kc*m1*Nl1*Bsat*f);
    Ns1=round((Irmsp*4)/(3.14*Jmax*ds1^2));
    Ns2=round((Irmsp*4*n)/(3.14*Jmax*ds2^2));
    Bcore=Acore_tol/(2*nc*Acore);
    W1=m1*ds1*sqrt(Ns1/AR)+2*m1*dins_int1+(m1-1)*dins1;
    hw=m1*ds1*sqrt(Ns1*AR)+Nl1*2*dins_int2+Nl1*dt1;
    Height=hw+2*dc1;
    MLT1=2*(2*Acore+dc1+4*dcf1+nc*Bcore+(nc-1)*dc2+2*W1);
    W2=m2*ds2*sqrt(Ns2/AR)+2*m2*dins_int2+(m2-1)*dins2;
    diso=diso_min;
    MLT2=MLT1+4*W1+4*W2+8*diso;
    Gcore=dcf1+W1+diso+W2+dc1;
    ki=5.715e-4;
    Vc=4*nc*Acore*Bcore*(Height+2*Acore)+4*nc*Acore*Bcore*Gcore;
    Mcore=Vc*rho;
    Pcore=2^(alpha+beta)*1*ki*((f*1000)/1e3)^alpha*(Bsat/1)^beta*(Vc/1);%1,W;1e3,1KHz;1,1T;1,1m^3
    Rwire=2.5/1000*(1+(100-20)/234.5);
    Facdc=2;
    sigma=0.0172e-6;%ohm*m
    Ppri=Irmsp^2*(Facdc*4*m1*Nl1*MLT1*sigma)/(ds1^2*3.14*Ns1);
    Psec=(Irmsp*n)^2*(Facdc*4*sigma*m2*Nl2*MLT2)/(ds2^2*3.14*Ns2);
    
    %Thermal Parameter
    knano=8.35;%W/(m*K)
    kbobbin=10;%W/(m*K)
    kepoxy=0.15;%W/(m*K)
    knanoorth=1.07;%W/(m*K)
    kair=0.03;%W/(m*K)
    kal=237;%W/(m*K)
    Rth12=Gcore/(2*Acore*Bcore*knano);
    Rth13=dcf1/(Height*Bcore*kbobbin);
    Rth35=dcl1/(5*2*2*Gcore*Bcore*kepoxy);
    Rth34=diso/(Bcore*hw*kbobbin);
    Rth45=dcl2/(5*2*(hw*Bcore+2*W2*Bcore)*kepoxy);
    Rth25=dcl2/(3*2*(Height*Bcore+2*Gcore*Bcore)*kepoxy);
    Rth2a=Acore/(2*2*(Height+2*Acore)*Bcore*knano);
    Q4=Psec*Bcore/MLT2;
    Q3=Ppri*Bcore/MLT1;
    Q2=(3*Pcore)/(4*nc*2);
    Q1=Pcore/(4*nc*2);
    Ta=300;%K
    T2=(Q1+Q2+Q3+Q4)*Rth2a+Ta;
        %Yth
        Yth=zeros(4,4);
        Yth(1,1)=1/Rth12+1/Rth13;
        Yth(1,2)=(-1)/Rth13;
        Yth(2,1)=(-1)/Rth12;
        Yth(2,4)=(-1)/Rth25;
        Yth(3,1)=(-1)/Rth13;
        Yth(3,2)=1/Rth13+1/Rth34+1/Rth35;
        Yth(3,3)=(-1)/Rth34;
        Yth(3,4)=(-1)/Rth35;
        Yth(4,2)=(-1)/Rth34;
        Yth(4,3)=1/Rth45+1/Rth34;
        Yth(4,4)=(-1)/Rth45;
        %Q
        Q=zeros(4,1);
        Q(1,1)=Q1+T2/Rth12;
        Q(2,1)=Q2+Ta/Rth2a-T2*(1/Rth12+1/Rth2a+1/Rth25);
        Q(3,1)=Q3;
        Q(4,1)=Q4;        
    Tsolv=Yth\Q;
    Tcalmax=max(Tsolv);    
    
    %Loss
    Ptotal_loss=Pcore+Ppri+Psec;
    
    %Efficiency
    Efficiency=Pout/(Ptotal_loss+Pout);
    
    %Total Volume
    High=Height+2*Acore;
    Length=nc*Bcore+(nc-1)*dc2+2*(diso+W1+W2);
    Width=2*(Gcore+2*Acore)+dc1;
    Volume=High*Length*Width;
    Powerdensity=Pout/Volume;
    
end