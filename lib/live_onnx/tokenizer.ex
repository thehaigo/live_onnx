defmodule Tokenizer do
  def encode(text) do
    {:ok, py_exec} = :python.start(python_path: 'python')
    result = :python.call(py_exec, :tokenizer, :encode, [text])
    :python.stop(py_exec)
    result
  end
end
