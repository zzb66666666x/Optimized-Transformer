%generate input here
clc;
clear;
nc_range=[1 2 3 4 5];
ds1=500e-6;%m
ds2=500e-6;%m
Acore_range=[3 4 5 6 7];
Jmax_range=[2 3 4 5 6];
f_range=[10,20,30,40];
temp=xlsread("m1_and_Nl1.xls");
m1_range=temp(:,1)';%139 elements here
Nl1_range=temp(:,2)';
Number_elements = length(m1_range);

%store the result
fid=fopen(".\Try_Different_Frequencies\result_ferrite_frequency_112KW.csv","w");
fprintf(fid,"nc,Acore,ds1,ds2,m1,Nl1,Jmax,frequency(khz),efficiency,powerdensity(KW/L),Tmax,Delta T");
fprintf(fid,"\r\n");
%loop
for nc_pointer=1:1:5
   for  Acore_pointer=1:1:5
       for Jmax_pointer=1:1:5
          for m1Nl1_pointer=1:1:Number_elements
              for f_pointer = 1:1:4
                nc=nc_range(nc_pointer);Acore=Acore_range(Acore_pointer);Jmax=Jmax_range(Jmax_pointer);f=f_range(f_pointer);
                m1=m1_range(m1Nl1_pointer);Nl1=Nl1_range(m1Nl1_pointer);
                [efficiency,powerdensity,Tmax]=ferrite(1026,775,45/34,30000,45/34,112e3,f*1000,400,nc,Acore/100,ds1,ds2,m1,Nl1,Jmax*1e6);
                deltaT=Tmax-300;
                fprintf(fid,"%d,%d,%d,%d,%d,%d,%d,%d,%f,%f,%f,%f",nc,Acore,ds1,ds2,m1,Nl1,Jmax,f,efficiency,powerdensity/1e6,Tmax,deltaT);
                fprintf(fid,"\r\n");
              end
          end
       end
   end
end
fclose(fid);
