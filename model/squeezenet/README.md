## squeeze.onnx export 
export from torchvision squeezenet

```
pip install torch torchvision
```

```python
import torchvision
import torch

net = torchvision.models.squeezenet1_0(pretrained = True)

model_onnx_path = "model/squeezenet/model.onnx" 
input_names = [ "input" ] 
output_names = [ "output" ] 

input_shape = (3, 224, 224)
batch_size = 1
dummy_input = torch.randn(batch_size, *input_shape) 


output = torch.onnx.export(net, dummy_input, model_onnx_path, \
                   verbose=False, input_names=input_names, output_names=output_names)

```