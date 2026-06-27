function [mdot_comp, hOut_comp, Pdot_Comp, Qdot_cond, hOut_cond, ...
    POut_cond, tOut_air_cond, M_cond, DP_ref_cond, mdot_exp, hOut_exp, Qdot_evap, hOut_evap, ...
    POut_evap, tOut_air_evap, M_evap, DP_ref_evap, P_1, P_2, P_3, P_4, h_1, h_3] ...
    = VaporCCModelreducedto6variables(P_1, P_2, P_3, P_4, h_1, h_3, Msys)

% Inputs:
% - P_1, P_2, P_3, P_4: pressures at states 1, 2, 3, and 4 (in kPa)
% - h_1: specific enthalpy at states 1 (in kJ/kg)
% - h_sub: subcooling specific enthalpy to be determined by the user
% Outputs:
% - Pdot_Comp: compressor power (in W)
% - mdot_comp: mass flow rate of refrigerant (in kg/s)
% - hOut_comp: specific enthalpy at the compressor outlet (in kJ/kg)
% - w_comp: compressor work (in W)
% - Qdot_cond: heat transfer rate in the condenser (in W)
% - hOut_cond: specific enthalpy at the condenser outlet (in kJ/kg)
% - POut_cond: pressure at the condenser outlet (in kPa)
% - tOut_air_cond: temperature of air leaving the condenser (in K)
% - mdot_exp: mass flow rate of refrigerant in the expansion valve (in kg/s)
% - hOut_exp: specific enthalpy at the expansion valve outlet (in kJ/kg)
% - Qdot_evap: heat transfer rate in the evaporator (in W)
% - hOut_evap: specific enthalpy at the evaporator outlet (in kJ/kg)
% - POut_evap: pressure at the evaporator outlet (in kPa)
% - tOut_air_evap: temperature of air leaving the evaporator (in K)

tic

funEval = 0;

%% Function to be solved for the unknown variables
 function res = fun2solve(x)   
        P_1 = x(1); P_2 = x(2); P_3 = x(3); P_4 = x(4); h_1 = x(5); h_3 = x(6); 
        [mdot_comp, hOut_comp, Pdot_Comp] = compressor(P_1, P_2, h_1);
        [Qdot_cond, hOut_cond, POut_cond, tOut_air_cond, M_cond, DP_ref_cond] = condenser(P_2, hOut_comp, mdot_comp);
        [mdot_exp, hOut_exp] = expansionvalve(P_3, P_4, h_3);
        [Qdot_evap, hOut_evap, POut_evap, tOut_air_evap, M_evap, DP_ref_evap] = evaporator(P_4, hOut_exp, mdot_exp);

           res = [mdot_comp - mdot_exp;
                  P_3 - POut_cond;
                  h_3 - hOut_cond;
                  P_1 - POut_evap;
                  h_1 - hOut_evap;
                  (M_evap+M_cond) - Msys];

        funEval = funEval + 1;

        % disp(['P_1: ', num2str(P_1)])
        % disp(['P_2: ', num2str(P_2)])
        % disp(['P_3: ', num2str(P_3)])
        % disp(['P_4: ', num2str(P_4)])
        % disp(['h_1: ', num2str(h_1)])
        % disp(['h_3: ', num2str(h_3)])
        
       
    end

% Define the initial guess
x0 = [P_1; P_2; P_3; P_4; h_1; h_3];

 options = optimoptions('fsolve', 'Display','iter','TolFun',1e-6,...
     'TolX',1e-6, 'MaxFunctionEvaluations', 10000, 'MaxIterations', 1000);
 % Call fsove to resolve the cycle
 x = fsolve(@(x)fun2solve(x), x0, options);


toc

disp(['Number of function evaluations: ', num2str(funEval)])

end