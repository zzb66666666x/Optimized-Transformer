matrix=[];
for m1=1:1:10
   for Nl1 = 1:1:30
      result = m1*Nl1;
      if result>20 && result<100
          matrix=[matrix;[m1,Nl1,result]];
      end
   end
end
xlswrite("m1_and_Nl1.xls",matrix);