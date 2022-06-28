%% Component-Based Modeling with Model Reference
% This example walks you through simulation and code generation of a model
% that references another model multiple times. In this example,
% Simulink(R) generates code for accelerated simulation, and Simulink(R)
% Coder(TM) generates code that can be deployed in standalone applications.

% Copyright 1990-2020 The MathWorks, Inc.

%% Model Reference Behavior
% Model Reference has several advantages over subsystems:
%
% * You can develop the referenced model independently from the models in
% which it is used.
% * You can reference a model multiple times in another model without
% having to make redundant copies.
% * Multiple models can reference a single model.
% * The referenced model is not loaded until it is needed. This incremental
% loading speeds up model load times.
% * If a model is referenced in accelerator mode, Simulink creates special
% binaries to be used in simulations. If the referenced model has not
% changed since the binaries were created, and the binaries are therefore
% up to date, no code generation occurs when models that use these binaries
% are simulated or compiled. This process is called _incremental code
% generation_. The use of binaries makes updating and simulating the model
% faster and increases modularity in code generation.
% * Generating code for a model with Model blocks also takes advantage of
% incremental code generation.
%% Incremental Loading 
% Open the example model.
open_system('sldemo_mdlref_basic')
%%
% This model contains three Model blocks: CounterA, CounterB and CounterC.
% These blocks reference the same model, |sldemo_mdlref_counter|, which is
% a separate model and not a subsystem of |sldemo_mdlref_basic|.
%%
% To determine what models are loaded in memory after opening the top model
% in the model hierarchy, enter this command:
get_param(Simulink.allBlockDiagrams,'Name')
%%
% The referenced model is not listed because it is not loaded.
%%
% Open the referenced model by double-clicking on any Model block or
% by entering this command:
open_system('sldemo_mdlref_counter')
%%
% Query the models loaded in memory again.
get_param(Simulink.allBlockDiagrams,'Name')
%%
% The referenced model is now listed, demonstrating that models are loaded
% incrementally as they are needed.
%% Inherited Sample Times
% Navigate back to the parent model |sldemo_mdlref_basic|.
%
% |sldemo_mdlref_basic| is configured to display sample time colors when
% it is compiled. On the *Debug* tab, click *Update Model*.
%
% <<../sldemo_mdlref_basic_sample_time_colors.png>>
%
% The Model blocks inherit different sample times because the referenced
% model |sldemo_mdlref_counter| does not explicitly specify a sample time.
%% Simulation Through Code Generation (Does Not Require Simulink Coder)
% Model blocks have a *Simulation mode* parameter that controls how
% the referenced model is simulated. If the parameter is set to |Normal|,
% the referenced model is simulated in interpreted mode. If the parameter
% is set to |Accelerator|, the referenced model is simulated through code
% generation. This process uses a binary file called a _simulation target_
% for each unique model referenced in accelerator mode. Generating a
% simulation target does not require a Simulink Coder license.
%
% In this model, CounterA and CounterB reference |sldemo_mdlref_counter| in
% normal mode, which is indicated by the hollow corners on the Model block
% icons. The other instance, CounterC, references |sldemo_mdlref_counter|
% in accelerator mode, which is indicated by the filled corners on the
% Model block icon.
%
% You can create the simulation target for the |sldemo_mdlref_counter|
% model by performing any of these actions:
%
% * Updating |sldemo_mdlref_basic|
% * Simulating |sldemo_mdlref_basic|
% 
% To build the simulation target programmatically, use this command:
%
%  slbuild('sldemo_mdlref_counter','ModelReferenceSimTarget')
%
% Once the simulation target is built, subsequently simulating or updating
% |sldemo_mdlref_basic| does not trigger a rebuild of the simulation target
% unless |sldemo_mdlref_counter| has changed.
%
% If all three instances of the referenced model were set to simulate in
% normal mode, the simulation target would not be built.
%% Code Generation for Standalone Applications (Requires Simulink Coder)
% When creating a standalone executable for |sldemo_mdlref_basic|, the
% build first generates the code and binaries for the _model reference
% coder target_ of |sldemo_mdlref_counter|. Generating a model reference
% coder target requires a Simulink Coder license.
%
% You can build the model reference coder target for
% |sldemo_mdlref_counter| and the standalone executable for
% |sldemo_mdlref_basic| by performing any of these actions:
%
% * Building the standalone executable for |sldemo_mdlref_basic|.
% * Building the model reference coder target of |sldemo_mdlref_counter|,
% then building the standalone executable for |sldemo_mdlref_basic|.
%
% To build the standalone executable programmatically, use this command:
%
%  slbuild('sldemo_mdlref_basic','StandaloneCoderTarget')
%
% Once the model reference coder target is built, subsequently building
% |sldemo_mdlref_basic| does not trigger a rebuild of the model reference
% coder target unless |sldemo_mdlref_counter| has changed. The code
% generated for the referenced model |sldemo_mdlref_counter| is reused.
%
% The code generation report for |sldemo_mdlref_basic| links to the report
% for |sldemo_mdlref_counter| in the *Referenced Models* section.