# WhizniumDBE Module Template Evaluation Device

WhizniumDBE comes with a plethora of simple logic but also complex vendor-agnostic module templates. This project, alongside [Whiznium StarterKit Device](https://github.com/mpsitech/wskd-Whiznium-StarterKit-Device) and [Laser Scanner By Platform](https://mpsitech.github.io/Laser-Scanner-By-Platform) serves as a real-life test-bench for some of those module templates, implemented on various platforms of various vendors.

## Source code

### Directory structure

Sub-folder|Content|
-|-|
_mdl|model files, text-based and diff-able between versions|
_rls|Makefiles and build/deploy scripts|
extra|code using the C++ device access library for bin-to-.vcd of the (FSM) tracking modules|
ezdevwted|auto-generated C++ easy model device access library|
fpgawted|auto-generated VHDL FPGA code by target|
fpgawted/cleb|Lattice CrossLink-NX evaluation board|
fpgawted/tidk|Efinix Titanium Ti180 development kit|
fpgawted/zudk|Avnet ZUBoard (Xilinx MPSoC)|
model|model files, to be edited in Excel for convenience|
wtedterm|auto-generated C++ interactive terminal|

## Contact

The Whiznium project is developed and curated by Munich-based start-up [MPSI Technologies GmbH](https://www.mpsitech.com). Feel free to [contact us](mailto:contact@mpsitech.com) with any questions.
