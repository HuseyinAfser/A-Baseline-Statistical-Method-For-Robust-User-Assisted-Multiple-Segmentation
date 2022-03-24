function testbench
% Author: Huseyin Afşer
% This function generates the accuracy plot for the paper "A Baseline Statistical Method 
% for Robust User-Assisted Multiple Segmentation" by testing the method under 
% different user input types and amounts.
% UI type 1 : a fraction of labeled pixels from ground truth masks
% UI type 2 : a number of seed points within ground truth masks
% UI type 3 : a fraction of labeled pixels from bounding boxes
% UI type 4 : pixels from randomly perturbed bounding boxes
% UI amount : {1,0.75,0.5,0.25} for UI type 1, 3
% UI amount : {10,15,20} for UI type 2
% UI amount : {5,10,15} for UI type 4

accuracy(1,:) = testbench_UI_type_amount(1,1);    % test 100% of labeled pixels from ground truth masks
accuracy(2,:) = testbench_UI_type_amount(1,0.75); % test 75% of labeled pixels from ground truth masks
accuracy(3,:) = testbench_UI_type_amount(1,0.5);  % test 50% of labeled pixels from ground truth masks
accuracy(4,:) = testbench_UI_type_amount(1,0.25); % test 25% of labeled pixels from ground truth masks
accuracy(5,:) = testbench_UI_type_amount(2,10);   % test 10 labeled seeds within ground truth masks
accuracy(6,:) = testbench_UI_type_amount(2,15);   % test 15 labeled seeds within ground truth masks
accuracy(7,:) = testbench_UI_type_amount(2,20);   % test 20 labeled seeds within ground truth masks
accuracy(8,:) = testbench_UI_type_amount(3,1);    % test 100% of labeled pixels from bounding boxes
accuracy(9,:) = testbench_UI_type_amount(3,0.75); % test 75% of labeled pixels from bounding boxes
accuracy(10,:) = testbench_UI_type_amount(3,0.5); % test 50% of labeled pixels from bounding boxes
accuracy(11,:) = testbench_UI_type_amount(3,0.25);% test 25% of labeled pixels from bounding boxes
accuracy(12,:) = testbench_UI_type_amount(4,5);   % test 5% randomly perturbed bounding boxes
accuracy(13,:) = testbench_UI_type_amount(4,10);  % test 10% randomly perturbed bounding boxes
accuracy(14,:) = testbench_UI_type_amount(4,15);  % test 15% randomly perturbed bounding boxes
save;


clf;
hold on;
t=1:2:100;
plot(t,accuracy(1,1:2:100),'-.ob' );
plot(t,accuracy(2,1:2:100),'-.*b' );
plot(t,accuracy(3,1:2:100),'-.sb' );
plot(t,accuracy(4,1:2:100),'-.+b' );

plot(t,accuracy(5,1:2:100),'-.or' );
plot(t,accuracy(6,1:2:100),'-.*r' );
plot(t,accuracy(6,1:2:100),'-.sr' );

plot(t,accuracy(8,1:2:100),'-.om' );
plot(t,accuracy(9,1:2:100),'-.*m' );
plot(t,accuracy(10,1:2:100),'-.sm' );
plot(t,accuracy(11,1:2:100),'-.+m' );

plot(t,accuracy(12,1:2:100),'-.oc' );
plot(t,accuracy(13,1:2:100),'-.*c' );
plot(t,accuracy(14,1:2:100),'-.sc' );


x0=10;
y0=10;
width=550;
height=400
set(gcf,'position',[x0,y0,width,height])

ylim([0.75 0.98001])
yticks([0.76:0.02:0.98])
grid on;

ylabel('Accuracy (IoU)','FontSize', 16);
xlabel('Number of relabeled superpixels','FontSize', 16)

legend('DGL$_{GT}^{100 \%}$','DGL$_{GT}^{75 \%}$','DGL$_{GT}^{50 \%}$','DGL$_{GT}^{25 \%}$','DGL$_{GT}^{10 \hspace{1 pt} pts}$','DGL$_{GT}^{15 \hspace{1 pt} pts}$' ...
    ,'DGL$_{GT}^{20 \hspace{1 pt} pts}$','DGL$_{BB}^{100\%}$','DGL$_{BB}^{75\%}$','DGL$_{BB}^{50\%}$','DGL$_{BB}^{25\%}$', ...
    'DGL$_{BB}^{5 \% pt}$','DGL$_{BB}^{10 \% pt}$','DGL$_{BB}^{15 \% pt}$','Location','South','Interpreter','Latex','FontSize', 16, 'NumColumns',2);

saveas(gcf,'results/accuracy.png');