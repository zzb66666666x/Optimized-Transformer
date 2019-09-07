%��άɢ��ͼ
data=xlsread('nano_112KW_20KHz_filteration.csv');
x=data(:,9);
y=data(:,8); 
z=data(:,11);
S = 10; %�����Ĵ�С/�ߴ�
scatter(x,y,S,z,'filled') %filled��ʾ����ʵ�ĵ㣬ȱʡ��Ϊ���ĵ�
xlabel('Power Density��kW/L��')
ylabel('Efficient��%��')
h = colorbar;
set(get(h,'label'),'string','delta temperature');%����ɫ������ 
xlim([3 50]) %����������̶�ȡֵ��Χ
ylim([0.982 0.998])

