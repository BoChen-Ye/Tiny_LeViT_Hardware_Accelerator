# Tiny_LeViT_Hardware_Accelerator
 This is my hobby project by using System Verilog. I worked on this project continuously for about 4-5 weeks, only dedicating evenings and weekends to it. I wrote approximately 2000+ lines of SV design code and 1900+ testbench code in total.

 It is based on [LeViT: a Vision Transformer in ConvNet’s Clothing for Faster Inference](https://github.com/facebookresearch/LeViT).

 But I've simplified the original large network into a smaller one, so I call it **Tiny_LeViT**.

 Of course, due to the complexity of hardware accelerators and network functions, many problems arise during the simplification process, some of which are yet to be resolved or will be addressed in the future.

 Problem: 1) It not support float-point number and arithmetic operation. 2) It not support multi-channel. 3) It is only behavior model, not all synthesizable until now. 4) It has wrong connection in multi-head block because I don't understand multi-head attention when I make it.

 Completed:1) finishied Tiny LeViT Hardware Accelerator. 2)finished Convolutional layer and Attention layer. 3) finished Tanh function and divider module. 4) finished Average pooling module.

## Network Architecture
- ```src/Tiny_LeViT_top.sv``` is the top level of Tiny_LeViT. It contain three convolutional layer(16,8,4), four stage1(2-head attention and MLP) and stage2(4-head attention and MLP). In the end, it has e average pooling module.
## Convolutional layer
- Use row stationary (RS) and systolic array to get parallel computing. 
- ```src/Conv_core_sa.sv``` and ```src/PE_ROW_SystolicArry.sv``` is normal version of convolution layer which delay is only 3 cycle from input data to first output data.
- Other convolutional core aim to accelerate the convolutional layer when stride=2 and padding=1. Delay: ```src/Conv16_core.sv```: 10 cycle, ```src/Conv8_core.sv```: 6 cycle,```src/Conv4_core.sv```: 4 cycle.
## Attention layer
- For attention layer, use Tanh instead of softmax and use ReLU instead of Hardswish to simplify that difficulty of hardware calculation.