```elixir
  base_path = Path.join(["model", "gpt2"])
  File.mkdir_p(base_path)

  path = Path.join([base_path, model_name])
  model_path = Path.join([path, "model.onnx"])
  System.cmd("python3", ["-m", "transformers.onnx", "--model=gpt2", "#{path}"])
```