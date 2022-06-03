defmodule LiveOnnxWeb.PageLive do
  use LiveOnnxWeb, :live_view
  require Axon
  EXLA.set_as_nx_default([:tpu, :cuda, :rocm, :host])

  @impl true
  def mount(_params, _session, socket) do
    {:ok, params} = :dets.open_file('model/vgg16/model.dets')
    [{1, {model, params}}] = :dets.lookup(params, 1)
    list = File.read!("model/classlist.json") |> Jason.decode!()

    {
      :ok,
      socket
      |> assign(:model, model)
      |> assign(:params, params)
      |> assign(:list, list)
      |> assign(:upload_file, nil)
      |> assign(:ans, [])
      |> allow_upload(
        :image,
        accept: :any,
        chunk_size: 6400_000,
        progress: &handle_progress/3,
        auto_upload: true
      )
    }
  end

  def handle_progress(:image, _entry, socket) do
    upload_file =
      consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
        File.read(path)
      end)
      |> List.first()

    {:ok, image} = StbImage.from_binary(upload_file)
    {:ok, image} = StbImage.resize(image, 224, 224)

    tensor =
      StbImage.to_nx(image)
      |> Nx.divide(255)
      |> Nx.subtract(Nx.tensor([0.485, 0.456, 0.406]))
      |> Nx.divide(Nx.tensor([0.229, 0.224, 0.225]))
      |> Nx.transpose()
      |> Nx.new_axis(0)

    {
      :noreply,
      socket
      |> assign(:upload_file, upload_file)
      |> assign(:tensor, tensor)
    }
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "detect",
        _params,
        %{assigns: %{tensor: tensor, model: model, params: params}} = socket
      ) do
    ans =
      Axon.predict(model, params, tensor)
      |> IO.inspect()
      |> Nx.flatten()
      |> Nx.argsort()
      |> Nx.reverse()
      |> Nx.slice([0], [5])
      |> Nx.to_flat_list()

    {:noreply, assign(socket, :ans, ans)}
  end
end
