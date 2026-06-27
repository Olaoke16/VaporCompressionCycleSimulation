# Lumped-Parameter Vapor Compression Cycle Model

This repository contains a lumped-parameter vapor compression cycle (VCC) model for simulating the steady-state performance of a refrigeration/air-conditioning system. 
The model uses refrigerant thermodynamic properties from **CoolProp** and solves the coupled cycle equations using **`fsolve`**.

The purpose of this model is to provide a simple, transparent, and computationally efficient framework for analyzing the main thermodynamic states and performance parameters of a vapor compression cycle.

## Model Description

The vapor compression cycle is represented using four main components:

1. **Compressor**
2. **Condenser**
3. **Expansion valve**
4. **Evaporator**

The cycle is solved using a lumped-parameter approach. Instead of resolving detailed spatial variations inside each component, 
the model represents the system through key thermodynamic state variables and algebraic balance equations.

CoolProp is used to calculate refrigerant properties such as pressure, enthalpy, entropy, temperature, 
density, saturation properties, and phase-dependent thermodynamic quantities.

## Unknown Variables
The nonlinear cycle model is solved for six unknown variables:
p1, p2, p3, p4, h1, h3

where:
p1 = compressor suction / evaporator outlet pressure
p2 = compressor discharge / condenser inlet pressure
p3 = condenser outlet pressure
p4 = expansion valve outlet / evaporator inlet pressure
h1 = compressor suction / evaporator outlet enthalpy
h3 = condenser outlet enthalpy

The remaining thermodynamic states are calculated from these solved variables using CoolProp property calls and component-level assumptions.

## Governing Equation Structure

The six unknowns are solved using six nonlinear equations representing the thermodynamic and component constraints of the cycle. 
These equations include pressure relationships, enthalpy relationships, heat-exchanger assumptions, mass and energy balance, compressor relations, expansion-valve behavior, and refrigerant property constraints.

The system of equations is solved using:
MATLAB Fsolve

At convergence, the solver returns the final pressure and enthalpy states of the cycle.

## Refrigerant Property Calculations

Refrigerant properties are evaluated using **CoolProp**. This allows the model to use real-fluid thermodynamic properties instead of idealized assumptions.

Typical CoolProp calculations include:
PropsSI("T", "P", p, "H", h, refrigerant)
PropsSI("S", "P", p, "H", h, refrigerant)
PropsSI("D", "P", p, "H", h, refrigerant)
PropsSI("H", "P", p, "Q", quality, refrigerant)
PropsSI("T", "P", p, "Q", quality, refrigerant)

The refrigerant can be changed depending on the system being analyzed, provided it is supported by CoolProp.

## Outputs

After the simulation converges, the model returns the solved cycle variables, thermodynamic states, and performance parameters.

Typical outputs include:

State pressures
State enthalpies
State temperatures
State entropies
Mass flow rate
Compressor power
Evaporator cooling capacity
Condenser heat rejection
Mass
Other calculated cycle parameters

These results can be used to evaluate the overall cycle performance and compare different operating conditions, refrigerants, or component parameters.

## General Cycle State Definition

A typical state numbering convention is used:

State 1: Compressor inlet / evaporator outlet
State 2: Compressor outlet / condenser inlet
State 3: Condenser outlet / expansion valve inlet
State 4: Expansion valve outlet / evaporator inlet

The cycle follows the standard vapor compression process:

1 → 2: Compression
2 → 3: Heat rejection in condenser
3 → 4: Isenthalpic expansion
4 → 1: Heat absorption in evaporator

## Installation

Install the required Python packages:

```bash
python -m pip install --upgrade pip
python -m pip install CoolProp
## Usage

Run the main simulation script:
RunVaporCCReduced6var

The model will solve the nonlinear cycle equations and print the final thermodynamic states and performance parameters.

## Example Workflow

1. Define the refrigerant.
2. Set the initial guesses for `p1`, `p2`, `p3`, `p4`, `h1`, and `h3`.
3. Define component parameters and operating conditions.
4. Call `fsolve` to solve the six nonlinear equations.
5. Use CoolProp to calculate the remaining thermodynamic properties.
6. Print or save the final cycle results.

## Notes

* The model is intended as a simplified lumped-parameter VCC model.
* The accuracy of the solution depends on the quality of the component assumptions and initial guesses.
* CoolProp provides real-fluid property calculations, which improves physical realism compared with constant-property or ideal-gas assumptions.
* The `fsolve` solution may be sensitive to initial guesses, especially when the cycle equations are strongly nonlinear.
* The model can be extended to include detailed heat-exchanger models, compressor maps, pressure drops, fan models, control logic, and transient system behavior.

## Future Improvements

Possible future extensions include:
Detailed compressor efficiency maps
Pressure drop across heat exchangers
Segmented condenser and evaporator models
Variable-speed compressor operation
Expansion-valve control logic
Superheat and subcooling control
Transient simulation
Modelica/Dymola comparison
Validation against experimental or manufacturer data

## Author

Developed as part of a vapor compression cycle modeling study using MATLAB, CoolProp, and FSOLVE nonlinear equation solving.



<img width="1236" height="985" alt="image" src="https://github.com/user-attachments/assets/f87789a9-6a06-4fdc-9df7-dc676504a75a" />

