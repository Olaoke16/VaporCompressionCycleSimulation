function [Qdot_cond, hOut_cond, POut_cond, tOut_air_cond, M_cond, DP_ref_cond] = condenser(P_2, h_2, mdot_comp)

% Inputs:
% - P_2: pressure at state 2 (in kPa)
% - hOut_comp: Specific Enthalpy at the exit of the compressor (kJ/kg)
% - mdot_comp: Mass flow rate at the exit of the compressor (in kg/s)
% Outputs:
% - Qdot_cond: heat transfer rate in the condenser (in W)
% - hOut_cond: specific enthalpy at the condenser outlet (in kJ/kg)
% - POut_cond: pressure at the condenser outlet (in kPa)
% - tOut_air_cond: temperature of air leaving the condenser (in K)


%% ===== defining parameters for the condenser =====
L_cond = 100; % Length (m)
U_cond = 3.5e4; %Overall Heat transfer coefficient (W/m2/K)
D_cond = 9.525e-3; %Tube Diameter (m)
A_cond = 29.9e-3; % Heat transfer area (m^2)
f_cond = 1; % Friction factor
mdot_air_cond = 1.5958; %Mass flow rate of air (kg/s)
tIn_air_cond = 305.15; %295.15; %305.15; % Inlet Air Temperature (K)
Cp_air_cond = 1005.5; % Specific heat capacity at constant pressure (J/kg/K)

%% Calculate the refrigerant Properties 
% Define the refrigerant
% CoolProp
Ref = 'R410A';
pyenv('Version','C:\Program Files\Python311\python.exe');

rho_2 = py.CoolProp.CoolProp.PropsSI('D', ...
    'P', P_2*1e3, 'H', h_2*1e3, Ref);
Tsat_cond = py.CoolProp.CoolProp.PropsSI('T', ...
    'P', P_2*1e3, 'Q', 1, Ref);

mdot_cond = mdot_comp;

mflux = mdot_cond/A_cond;
    
%% Calculate models at state 2-3
Qdot_cond = U_cond*A_cond*(Tsat_cond-tIn_air_cond);

hOut_cond = h_2 - (Qdot_cond/mdot_cond)*1e-3;

% DP_ref_cond = (2*f_cond*L_cond*mdot_cond^2/(pi*rho_2*D_cond));

DP_ref_cond = (2*f_cond*L_cond*(mflux)^2/(D_cond*rho_2))*1e-03;

POut_cond = P_2 - DP_ref_cond;

tOut_air_cond = tIn_air_cond + Qdot_cond/(mdot_air_cond*Cp_air_cond);

M_cond= pi*(D_cond/2)^2*L_cond*rho_2;

% disp("=========Condenser run completed===========")

end