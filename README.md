# Tiny_LeViT_Hardware_Accelerator
 This is my hobby project with System Verilog.
## Network Architecture

## Convolutional layer
- Use row stationary (RS) and systolic array to get parallel computing. The delay is only 3 cycle from input data to first output data. Also, it has specific core to accelerate the convolutional layer when stride=2 and padding=1.
## Attention layer
- For attention layer, use Tanh instead of softmax and use ReLU instead of Hardswish to simplify that difficulty of hardware calculation.