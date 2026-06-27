function [mdot_exp, hOut_exp] = expansionvalve(P_3, P_4, h_3)

% Inputs:
% - P_3, P_4: pressures at states 3 and 4 (in kPa)
% - h_3: specific enthalpy at state 3 (in kJ/kg)
% Outputs:
% - mdot_exp: mass flow rate of refrigerant in the expansion valve (in kg/s)
% - hOut_exp: specific enthalpy at the expansion valve outlet (in kJ/kg)

%% ===== defining parameters for the expansion device =====
f_exp = 1; % Flow coefficient
D_exp = 1.0e-3; %Tube diameter (m)

%% Calculate the refrigerant Properties
% Define the refrigerant
% CoolProp
Ref = 'R410A';
pyenv('Version','C:\Program Files\Python311\python.exe');

rho_3 = py.CoolProp.CoolProp.PropsSI('D', ...
    'P', P_3*1e3, 'H', h_3*1e3, Ref);

%% Calculate models at state 3-4
mdot_exp = f_exp*D_exp^2*(rho_3*(P_3 - P_4)*1e3)^0.5;
hOut_exp = h_3;

% disp("=========Expansion device run completed============")

end