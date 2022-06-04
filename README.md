# LiveOnnx

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## supportted model

* ResNet18
* AlexNet
* SqueezeNet
* Vgg16 
* ConvNext

## unsupportted model

* densenet -> unsupported "Pad" 2022/06/05
* inception -> unsupported "Pad" 2022/06/05
* shufflenet -> unable to build model from ONNX graph, expected value onnx::Conv_378 to be a graph input, but it was not present in built graphs 2022/06/05

## export onnx proccess 
see model/model_name directory