# RISC-V

## Name convention
All variables must follow this name convention in order to keep the project clean and structured

|Regex|Description |
|--|--|
| **i_(a-z)\*** | to denotate inputs in a component |
| **o_(a-z)\*** | to denotate outputs in a component |
| **s_(a-z)\*0?** | to denotate signals in an architecture |
| **s_(a-z)\*_idex** | to denotate a signal which is output of the ID/EX segmentation register |
| **s_(a-z)\*_exmem** | to denotate a signal which is output of the EX/MEM segmentation register |
| **s_(a-z)\*_memwb** | to denotate a signal which is output of the MEM/WB segmentation register |
| **c_(a-z)\*** | to denotate components in an architecture |
| **R_(A-Z)\*** | to denotate ranges |

