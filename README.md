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

## vgg16.onnx export 
```
pip install torch torchvision
```

```python
# インポート
import torchvision
import torch

net = torchvision.models.vgg16(pretrained = True)
# モデル出力のための設定
model_onnx_path = "vgg16.onnx" # 出力するモデルのファイル名
input_names = [ "input" ] # データを入力する際の名称
output_names = [ "output" ] # 出力データを取り出す際の名称

# ダミーインプットの作成
input_shape = (3, 224, 224) # 入力データの形式
batch_size = 1 # 入力データのバッチサイズ
dummy_input = torch.randn(batch_size, *input_shape) # ダミーインプット生成

# 変換実行！！
output = torch.onnx.export(net, dummy_input, model_onnx_path, \
                   verbose=False, input_names=input_names, output_names=output_names)

```

## vgg16.dets create

```elixir
{model, params} = AxonOnnx.import("vgg16.onnx")

# detsに保存

:dets.open_file("vgg16", type: :bag, file: 'vgg16.dets')
:dets.insert("vgg16",{1,{model,params}}) 
:dets.sync("vgg16")
:dets.stop
```