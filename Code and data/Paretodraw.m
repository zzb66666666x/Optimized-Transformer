%二维散点图
data=xlsread('nano_112KW_20KHz_filteration.csv');
x=data(:,9);
y=data(:,8); 
z=data(:,11);
S = 10; %坐标点的大小/尺寸
scatter(x,y,S,z,'filled') %filled表示点是实心点，缺省则为空心点
xlabel('Power Density（kW/L）')
ylabel('Efficient（%）')
h = colorbar;
set(get(h,'label'),'string','delta temperature');%给颜色栏命名 
xlim([3 50]) %设置坐标轴刻度取值范围
ylim([0.982 0.998])

