# 🗂️ Synchronous FIFO Verification Project

<p align="center">
  <img src="docs/fifo_verification_diagram.png" alt="FIFO Verification Environment" width="600"/>
</p>

## 📖 Overview
This project implements and verifies a **Synchronous FIFO** design in SystemVerilog.  
The verification environment is built using **transaction classes, functional coverage, scoreboards, and assertions** to ensure correctness under randomized stimulus and corner-case scenarios.

The work includes:
- FIFO RTL design with assertions  
- UVM-style testbench architecture (interface, monitor, scoreboard, coverage)  
- Randomized stimulus with constraints  
- Functional coverage and assertion coverage  
- Bug detection and reporting with QuestaSim  

---

## ⚙️ Design Parameters
- **FIFO_WIDTH**: Data bus width (default: 16)  
- **FIFO_DEPTH**: Memory depth (default: 8)  

---

## 🔌 Ports

| Port        | Direction | Function |
|-------------|-----------|----------|
| `data_in`   | Input     | Write data bus |
| `wr_en`     | Input     | Write enable |
| `rd_en`     | Input     | Read enable |
| `clk`       | Input     | Clock signal |
| `rst_n`     | Input     | Active-low asynchronous reset |
| `data_out`  | Output    | Read data bus |
| `full`      | Output    | FIFO full flag |
| `almostfull`| Output    | Almost full flag |
| `empty`     | Output    | FIFO empty flag |
| `almostempty`| Output   | Almost empty flag |
| `overflow`  | Output    | Overflow indicator |
| `underflow` | Output    | Underflow indicator |
| `wr_ack`    | Output    | Write acknowledge |

---

## 🧪 Verification Flow
1. **Top Module**  
   - Generates clock and reset  
   - Connects DUT, testbench, and monitor via interface  

2. **Transaction Class (`FIFO_transaction`)**  
   - Holds FIFO inputs/outputs  
   - Randomized stimulus with constraints on `wr_en` and `rd_en`

3. **Coverage Class (`FIFO_coverage`)**  
   - Cross coverage between `wr_en`, `rd_en`, and FIFO status flags  
   - Ensures all combinations of operations are tested  

4. **Scoreboard (`FIFO_scoreboard`)**  
   - Implements reference model  
   - Compares DUT outputs vs expected outputs  
   - Tracks `error_count` and `correct_count`  

5. **Assertions**  
   - Check FIFO flags, counters, and pointer behavior  
   - Guarded with `ifdef SIM` for simulation-only compilation  

---

## 📊 Coverage Goals
- **Code coverage**: 100%  
- **Functional coverage**: 100%  
- **Assertion coverage**: 100%  

---

## 🐞 Bug Reporting
- Bugs detected during simulation are logged with before/after RTL snippets.  
- Reports are included in the submission PDF.  

---

## ▶️ Running the Simulation
1. Compile with QuestaSim using the provided `.do` file:  
   ```tcl
   vlog +define+SIM top.sv
   vsim -do run.do
   ```
2. Generate coverage reports.  
3. View waveforms and class objects (`run 0` → add to waveform → `run -all`).  

---

## 📂 Repository Structure
```
├── rtl/
    ├── FIFO.sv
├── tb/   
│   ├── top.sv  
│   ├── tb.sv  
│   ├── shared_pkg.sv  
│   ├── fifo_if.sv  
│   ├── transaction_pkg.sv
│   ├── monitor_pkg.sv
│   ├── coverage_pkg.sv
│   ├── scoreboard_pkg.sv
├── report.pdf
└── README.md
```

---

## ✨ Notes
- Reset clears all FIFO pointers and counters.  
- Simultaneous read/write behavior:
  - If empty → write only  
  - If full → read only  
- Assertions ensure flags and counters behave correctly under all conditions.
