# 8-bit ALU + Register File + Execution Unit

## Summary
This is a modular Verilog design of a basic CPU component setup including:
- 8-bit ALU with arithmetic, logic, shift, comparison, parity ops
- 32x8 Register File
- Instruction decoder (Execution Unit)
- Single-cycle processor wrapper (`processing.v`)
- R-type instruction (so far)

##  Features
- Full 8-bit addition with overflow detection
- Subtraction using 2's complement
- Logical & arithmetic shift ops
- SLT, equality check, parity
- Register File with 32 registers
- Simulates a simple 32-bit instruction format

## Testing

Below are example instruction encodings and the expected ALU behavior.

### Test Case 1: ADD
- **Instruction**: `0x08430800`
- **Binary**: `0000 00001 00010 00011` (rest don't matter for now since they're unused)
  - Opcode: `0000` (ADD)
  - rs1 = R1, value = 10
  - rs2 = R2, value = 5
  - rd  = R3
- **Expected**: R3 = 15

---

### Test Case 2: SUBTRACT
- **Instruction**: `0x18430800`
  - Opcode: `0001` (SUB)
  - rs1 = R1, value = 10
  - rs2 = R2, value = 5
  - rd  = R3
- **Expected**: R3 = 5

---

### Test Case 3: AND
- **Instruction**: `0x28430800`
  - Opcode: `0010` (AND)
  - R1 = 8'b11001100  
  - R2 = 8'b10101010
- **Expected**: R3 = 8'b10001000

---

### Test Case 4: Set-Less-Than
- **Instruction**: `0xA8430800`
  - Opcode: `1010` (SLT)
  - R1 = 5  
  - R2 = 10
- **Expected**: R3 = 1

## File Structure
- `alu_8bit.v`: Arithmetic Logic Unit
- `regfile.v`: 32-register file
- `execution_unit.v`: Instruction decode logic
- `processing.v`: Integrates all modules
- `processing_tb.v`: Testbench

## Next Steps
- Extend instruction format to more custom ISAs to include immediate values
- Add memory access and program counter

---
