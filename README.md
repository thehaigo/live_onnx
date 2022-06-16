# LiveOnnx

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * get supported onnx model
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## demo

https://user-images.githubusercontent.com/91950/172017672-ad98402d-93a7-4d7a-9e94-b69eebc1cea2.mp4

## supported model

* ResNet18
* AlexNet
* SqueezeNet
* Vgg16 
* ConvNext

## unsupported model

* densenet -> unsupported "Pad" 2022/06/05
* inception -> unsupported "Pad" 2022/06/05
* shufflenet -> unable to build model from ONNX graph, expected value onnx::Conv_378 to be a graph input, but it was not present in built graphs 2022/06/05

## export onnx proccess 
see model/model_name directory
