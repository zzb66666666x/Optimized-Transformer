%Inputs are in the form of SI Unit
%System Requirement
%Inputs V1,V2,n,Viso,Nratio,Pout,f,Tmax
V1_cal=1026;%V
V2_cal=775;%V
n_cal=45/34;
Viso_cal=30000;%V
Nratio_cal=45/34;
Pout_cal=224e3;%W(224kW)
f_cal=20e3;%Hz(20kHZ)
Tmax_cal=120+273.15;%K(120C)

%Free Parameter
%Inputs nc,Acore,ds1,ds2,m1,Nl1,Jmax
nc_cal=1;
Acore_cal=3e-2;%m(3cm)
ds1_cal=500e-6;%m(500um)
ds2_cal=500e-6;%m(500um)
m1_cal=15;
Nl1_cal=2;
Jmax_cal=4e6;%A/m^2(4A/mm^2)

%Initializing
name='demo.csv';
file=fopen(name,'w');
fprintf(file,"V1,V2,n,Viso,Nratio,Pout,f,Tmax,nc,Acore,ds1,ds2,m1,Nl1,Jmax,Efficiency,Powerdensity,Tcalmax,\r\n");

%Calculating
for nc_cal=1:1:5
    for Acore_cal=3e-2:1e-2:7e-2
        for m1_cal=1:1:10
            for Nl1_cal=1:1:30
                for Jmax_cal=2e6:1e6:6e6
                    [Efficiency_cal,Powerdensity_cal,Tcalmax_cal]=ferrite(V1_cal,V2_cal,n_cal,Viso_cal,Nratio_cal,Pout_cal,f_cal,Tmax_cal,nc_cal,Acore_cal,ds1_cal,ds2_cal,m1_cal,Nl1_cal,Jmax_cal);
                    fprintf(file,"%d,%d,%f,%d,%f,%d,%d,%f,%d,%f,%f,%f,%d,%d,%d,%f,%f,%f,\r\n",V1_cal,V2_cal,n_cal,Viso_cal,Nratio_cal,Pout_cal,f_cal,Tmax_cal,nc_cal,Acore_cal,ds1_cal,ds2_cal,m1_cal,Nl1_cal,Jmax_cal,Efficiency_cal,Powerdensity_cal,Tcalmax_cal);
                end
            end
        end
    end
end