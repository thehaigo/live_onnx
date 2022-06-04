## alexnet.onnx export 
export from torchvision alexnet

```
pip install torch torchvision
```

```python
import torchvision
import torch

net = torchvision.models.alexnet(pretrained = True)

model_onnx_path = "model/alexnet/model.onnx" 
input_names = [ "input" ] 
output_names = [ "output" ] 

input_shape = (3, 224, 224)
batch_size = 1
dummy_input = torch.randn(batch_size, *input_shape) 


output = torch.onnx.export(net, dummy_input, model_onnx_path, \
                   verbose=False, input_names=input_names, output_names=output_names)

```

## model.dets create
AxonOnnx import too slow
becasue load from dets

```elixir
{model, params} = AxonOnnx.import("model/alexnet/model.onnx")

# save to dets
:dets.open_file("alexnet", type: :bag, file: 'model/alexnet/model.dets')
:dets.insert("alexnet",{1,{model,params}}) 
:dets.sync("alexnet")
:dets.stop
```

