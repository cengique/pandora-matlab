% Pandora module for analyzing voltage and current clamp experiments.
% Version 1.0 dd-mmm-yyyy

% Dump of all functions (TODO: fix this list)
% cellset_L1                     - Dataset of files from multiple cells.
% current_clamp                  - Current clamp object with current and voltage traces.
% data_L1_passive                - Holds passive recordings from L1 cells.
% model_data_vcs                 - Combines model description that fits a voltage clamp data.
% model_data_vcs_DmNav           - OBSOLETE Combines model description that fits a voltage clamp data.
% model_data_vcs_DmNavTPS        - Contains separate transient and persistent DmNav models and oocyte data.
% model_data_vcs_Kprepulse       - Keeps model and data for K recordings with and without an inactivation prepulse.
% traceset_L1_Verena             - R:\Logy\fred-workingDir\@traceset_L1_Verena
% traceset_L1_passive            - Dataset of multiple ABF files that belong to the same cell.
% voltage_clamp                  - Voltage clamp object with current and voltage traces.
% paramsNeurofit                 - Extract Hodgkin-Huxley type ion channel parameters from a Neurofit report file.
% plotVclampAbf                  - Vertical stack plot of voltage-clamp I and V traces from ABF file.
% plotVclampStack                - Vertical stack plot of voltage-clamp I and V traces.
% scale_IClCa_NaP_sub_IClCa      - Scale IClCa and steady-state of INaP from voltage-step protocol data and subtract IClCa.
% scale_cap_leak_Ca_sub_cap_leak - Scale capacitance and leak artifacts to subtract them.
% scale_sub_cap_leak             - scale_cap_leak_Ca_sub_cap_leak - Scale capacitance and leak artifacts to subtract them.
% sub2VclampAbf                  - Subtract  ABF filename2 from filename1.
% subTTXcontrol                  - Subtract voltage clamp object vc2 from vc1.
% taum_from_time2peak            - Approximate taum from tauh and time to peak.
