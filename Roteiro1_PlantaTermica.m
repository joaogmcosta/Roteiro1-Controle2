clear all
close all
clc
%5.1.1 Definindo constantes
K=0.4725;
T=100;
L=10;
theta_AMB=33.6;
%5.1.2
t=0:0.1:600;
%5.1.3
%a
FT1=tf([K],[T 1]);
FT2=tf([-L 2],[L 2]);%(aproximação padé 1a ordem)
%b 
planta_MA1=FT1*FT2;
%5.1.4
%a e b
y=step(45*planta_MA1,t);
%c

figure(1)

plot(t,y+theta_AMB);
grid on
xlabel('Tempo [s]')
ylabel('Temperatuta [ºC]')
%5.1.5
FT3=tf([L^2 -6*L 12],[L^2 6*L 12]);%(aproximação padé 2a ordem)
planta_MA2=FT1*FT3;
y2=step(45*planta_MA2,t);

figure(2)

plot(t,y2+theta_AMB);
grid on
xlabel('Tempo [s]')
ylabel('Temperatuta [ºC]')

%5.1.6
%a
s=tf('s')
%b
planta_MA3=(K*exp(-L*s))/((T*s)+1)
%c
y3=step(45*planta_MA3,t);

figure(3)

plot(t,y3+theta_AMB);
grid on
xlabel('Tempo [s]')
ylabel('Temperatuta [ºC]')

%5.1.7

figure(4)
plot(t,y+theta_AMB,'-.','LineWidth',1.2);
hold on
plot(t,y2+theta_AMB,'--','LineWidth',1.2)
plot(t,y3+theta_AMB,'LineWidth',1.2);
hold off
legend('Aprox. 1a ordem','Aprox. 2a ordem','Atraso sem aprox.')
grid on
xlabel('Tempo [s]')
ylabel('Temperatuta [ºC]')

%5.1.8 
%Somente há diferenças no período transitório. Isso se deve ao fato de que 
%as aproximações de 1a e 2a ordem alteram o período transitório do sistema.
%Logo, as aproximações de Padé representam com fidelidade a resposta do sistema para o regime peanente
%embora não representa com fiddelidade a resposta do sistema no regime transitório.

%5.2.1
Kp=T/(K*L)
%5.2.2
tf=0:0.1:250;
%5.2.3
%item 1
planta_MF1=feedback(planta_MA1*Kp,1)
%item 2
planta_MF2=feedback(planta_MA2*Kp,1)
%item3
planta_MF3=feedback(planta_MA3*Kp,1)

% 5.2.4
y4=step((45-theta_AMB)*planta_MF1,tf);
y5=step((45-theta_AMB)*planta_MF2,tf);
y6=step((45-theta_AMB)*planta_MF3,tf);

%5.2.5
figure(5)
plot(tf,y4+theta_AMB,'-.','LineWidth',1.2);
hold on
plot(tf,y5+theta_AMB,'--','LineWidth',1.2);
plot(tf,y6+theta_AMB,'LineWidth',1.2);
hold off
legend('Aprox. 1a ordem','Aprox. 2a ordem','Atraso sem aprox.')
grid on
xlabel('Tempo [s]')
ylabel('Temperatuta [ºC]')

%5.2.6
% Para o sistema realimentado, nota-se que as aproximações de 1a
% e 2a ordem no regime transitório e permanente são diferentes do sistema
% real(sem considerar aproximações), embora a aproximação de 2a ordem
% aproxima-se mais da resposta real do sistema em MF.

%5.3
%5.3.3) o sinal não está dentro dos limites do atuador (0-100%)

%5.3.8
figure (6)
%Script
plot(tf,y4+theta_AMB,'-.','LineWidth',1.2,'color','r');
hold on
plot(tf,y5+theta_AMB,'LineWidth',1.2,'color','[0.4940 0.1840 0.5560]');
%Simulink
out=sim('Roteiro1_Planta.slx')
plot(out.t_simulacao,out.Resposta_MF_Simulink_1ordem,'--','LineWidth',1.2,'color','b')
plot(out.t_simulacao,out.Resposta_MF_Simulink_2ordem,':','LineWidth',1.2,'color','g')
legend('Aprox. 1a ordem Script','Aprox. 2a ordem Script','Aprox. 1a ordem Simulink','Aprox. 2a ordem Simulink')
grid on
xlabel('Tempo [s]')
ylabel('Temperatuta [ºC]')
%Informações das FTs dos scriptes
%1ordem
stepinfo((45-theta_AMB)*planta_MF1)
%2ordem
stepinfo((45-theta_AMB)*planta_MF2)

%CÁLCULO OVERSHOOT SIMULINK
%1a ordem
y_p1 = max(out.Resposta_MF_Simulink_1ordem)-theta_AMB %Valor de pico
y_rp1 = out.Resposta_MF_Simulink_1ordem(2501,1)-theta_AMB %Valor em regime
overshoot_1aordem= ((y_p1/y_rp1)-1)*100 %Overshoot em %

%2a ordem
y_p2 = max(out.Resposta_MF_Simulink_2ordem)-theta_AMB %Valor de pico
y_rp2 = out.Resposta_MF_Simulink_2ordem(2501,1)-theta_AMB %Valor em regime
overshoot_2aordem= ((y_p2/y_rp2)-1)*100 %Overshoot em %

%CÁLCULO TEMPO SUBIDA SIMULINK
%1 ordem
%Tempo de subida 90% 1ordem
t_subida90_1aordem=0;
for i=1:1:2500    
    if out.Resposta_MF_Simulink_1ordem(i,1)>(0.89*(out.Resposta_MF_Simulink_1ordem(2501,1)-theta_AMB)+theta_AMB) && out.Resposta_MF_Simulink_1ordem(i,1)<(0.901*(out.Resposta_MF_Simulink_1ordem(2501,1)-theta_AMB)+theta_AMB)
    t_subida90_1aordem=out.t_simulacao(i,1)
    end
    i=i+1;
end
%Tempo de subida 10% 1ordem
t_subida10_1aordem=0;
for i=1:1:2500    
    if out.Resposta_MF_Simulink_1ordem(i,1)>(0.089*(out.Resposta_MF_Simulink_1ordem(2501,1)-theta_AMB)+theta_AMB) && out.Resposta_MF_Simulink_1ordem(i,1)<(0.101*(out.Resposta_MF_Simulink_1ordem(2501,1)-theta_AMB)+theta_AMB)
    t_subida10_1aordem=out.t_simulacao(i,1)
    end
    i=i+1;
end

%TEMPO SUBIDA 1ORDEM
t_subida_1ordem = t_subida90_1aordem - t_subida10_1aordem

%2ordem
%Tempo de subida 90% 2ordem
t_subida90_2aordem=0;
for i=1:1:2500    
    if out.Resposta_MF_Simulink_2ordem(i,1)>(0.89*(out.Resposta_MF_Simulink_2ordem(2501,1)-theta_AMB)+theta_AMB) && out.Resposta_MF_Simulink_2ordem(i,1)<(0.901*(out.Resposta_MF_Simulink_2ordem(2501,1)-theta_AMB)+theta_AMB)
    t_subida90_2aordem=out.t_simulacao(i,1)
    end
    i=i+1;
end
%Tempo de subida 10% 1ordem
t_subida10_2aordem=0;
for i=1:1:2500    
    if out.Resposta_MF_Simulink_2ordem(i,1)>(0.089*(out.Resposta_MF_Simulink_2ordem(2501,1)-theta_AMB)+theta_AMB) && out.Resposta_MF_Simulink_2ordem(i,1)<(0.101*(out.Resposta_MF_Simulink_2ordem(2501,1)-theta_AMB)+theta_AMB)
    t_subida10_2aordem=out.t_simulacao(i,1)
    end
    i=i+1;
end

%TEMPO SUBIDA 2ORDEM
t_subida_2ordem = t_subida90_2aordem - t_subida10_2aordem


%CÁLCULO TEMPO ASSENTAMENTO SIMULINK 
%1 ordem
t_assentamento_1ordem = 0;
for i=1:1:2500    
    if out.Resposta_MF_Simulink_1ordem(i,1)>(0.979*(out.Resposta_MF_Simulink_1ordem(2501,1)-theta_AMB)+theta_AMB) && out.Resposta_MF_Simulink_1ordem(i,1)<(0.981*(out.Resposta_MF_Simulink_1ordem(2501,1)-theta_AMB)+theta_AMB)
    t_assentamento_1ordem=out.t_simulacao(i,1)
    end
    i=i+1;
end
t_assentamento_1ordem
%2 ordem
t_assentamento_2ordem = 0;
for i=1:1:2500    
    if out.Resposta_MF_Simulink_2ordem(i,1)>(0.979*(out.Resposta_MF_Simulink_2ordem(2501,1)-theta_AMB)+theta_AMB) && out.Resposta_MF_Simulink_2ordem(i,1)<(0.981*(out.Resposta_MF_Simulink_2ordem(2501,1)-theta_AMB)+theta_AMB)
    t_assentamento_2ordem=out.t_simulacao(i,1)
    end
    i=i+1;
end
t_assentamento_2ordem

%5.3.9
%Considerações sobre o SOBRESSINAL
%De forma geral, observa-se que as curvas de temperatura geradas a partir
%do script tiveram um maior sobressinal em relação as geradas no Simulink
%(com a inclusão do bloco de saturação na saída do atuador). Em termos
%numéricos, obteve-se um sobressinal de 33,86% e 47,76% para as aproximações
%de 1a e 2a ordem dos scripts, respectivamente. Já para as curvas do
%Simulink, foi obtido um sobressinal de 13,14% e 16,94% para as
%aproximações de 1a e 2a ordem, respectivamente. Nota-se que, tanto para o
%script como para o Simulink, as aproximações de 2a odem geraram um
%sobressinal maior em realação as de 1a ordem.

%Considerações sobre TEMPO DE SUBIDA
%De forma geral, observa-se que as curvas de temperatura geradas a partir
%do script tiveram um menor tempo de subida em relação as geradas no Simulink
%(com a inclusão do bloco de saturação na saída do atuador). Em termos
%numéricos, obteve-se um tempo de subida de 7,72s e 7,95s para as aproximações
%de 1a e 2a ordem dos scripts, respectivamente. Já para as curvas do
%Simulink, foi obtido um tempo de subida de 20,1s e 20s para as
%aproximações de 1a e 2a ordem, respectivamente. Nota-se que, tanto para o
%script como para o Simulink, as aproximações de 2a odem geraram um
%tempo de subida ligeiramente maior em realação as de 1a ordem.

%Considerações sobre TEMPO DE ASSENTAMENTO
%De forma geral, observa-se que as curvas de temperatura geradas a partir
%do script tiveram um menor tempo de assentamento em relação as geradas no Simulink
%(com a inclusão do bloco de saturação na saída do atuador). Em termos
%numéricos, obteve-se um tempo de assentamento de 75,86s e 104,61s para as aproximações
%de 1a e 2a ordem dos scripts, respectivamente. Já para as curvas do
%Simulink, foi obtido um tempo de assentamento de 76,1s e 81,2s para as
%aproximações de 1a e 2a ordem, respectivamente. Nota-se que, tanto para o
%script como para o Simulink, as aproximações de 1a odem geraram um
%tempo de assentamento menor em realação as de 2a ordem.










