function [mdot_comp, hOut_comp, Pdot_Comp] = compressor(P_1, P_2, h_1)

% Inputs:
% - P_1, P_2: pressures at states 1 and 2 (in kPa)
% - h_1: specific enthalpy at state 1 (in kJ/kg)
% Outputs:
% - Pdot_Comp: compressor power (in W)
% - mdot_comp: mass flow rate of refrigerant (in kg/s)
% - hOut_comp: specific enthalpy at the compressor outlet (in kJ/kg)

%% ===== defining parameters for the compressor =====
etaVol_comp = 0.9; % Volumetric Efficiency
etamech_comp = 0.9; %Motor Efficiency
eta_isen = 0.65; % Isentropic Efficiency
Dv_comp = 92.5e-06; % Compressor Displacement Volume (m^3)
RPM_comp = 1000; % Compresssor speed in rev/min 

%% Calculate the refrigerant Properties 
% Define the refrigerant
% CoolProp
Ref = 'R410A';
pyenv('Version','C:\Program Files\Python311\python.exe');

rho_1 = py.CoolProp.CoolProp.PropsSI('D', ...
                                'P', P_1*1e3, 'H', h_1*1e3, Ref);
s_1 = py.CoolProp.CoolProp.PropsSI('S', ...
    'P', P_1*1e3, 'H', h_1*1e3, Ref);
h_2s = py.CoolProp.CoolProp.PropsSI('H', ...
    'P', P_2*1e3, 'S', s_1, Ref);

%% Calculate models at state 1-2
mdot_comp = rho_1*Dv_comp*etaVol_comp*RPM_comp/60;

hOut_comp = h_1 + ((h_2s*1e-03) - h_1)/eta_isen;

Pdot_Comp = (mdot_comp*(hOut_comp - h_1)/etamech_comp)*1e3;

end