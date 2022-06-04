defmodule LiveOnnxWeb.PageLive do
  use LiveOnnxWeb, :live_view
  require Axon
  EXLA.set_as_nx_default([:tpu, :cuda, :rocm, :host])

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> assign_enable_model()
      |> assign(:list, File.read!("model/classlist.json") |> Jason.decode!())
      |> assign(:upload_file, nil)
      |> assign(:tensor, nil)
      |> assign(:ans, [])
      |> allow_upload(
        :image,
        accept: :any,
        chunk_size: 6400_000,
        progress: &handle_progress/3,
        auto_upload: true
      )

    {:ok, socket}
  end

  defp assign_enable_model(socket) do
    model_names =
      File.ls!("model")
      |> Enum.filter(fn name -> File.exists?("model/#{name}/model.onnx") end)

    assign(socket, :enable_model, model_names)
  end

  def handle_params(%{"id" => "vgg16"}, _action, socket) do
    {:ok, dets} = :dets.open_file('model/vgg16/model.dets')
    [{1, {model, params}}] = :dets.lookup(dets, 1)

    {:noreply, assign_model(socket, model, params, "vgg16")}
  end

  def handle_params(%{"id" => "convnext"}, _action, socket) do
    {model, params} = AxonOnnx.import("model/convnext/model.onnx")

    {:noreply, assign_model(socket, model, params, "convnext")}
  end

  def handle_params(%{"id" => "resnet18"}, _action, socket) do
    {model, params} = AxonOnnx.import("model/resnet18/model.onnx")

    {:noreply, assign_model(socket, model, params, "resnet18")}
  end

  def handle_params(%{}, _action, socket) do
    {:noreply, assign(socket, model_name: "None")}
  end

  defp assign_model(socket, model, params, model_name) do
    socket
    |> assign(:model, model)
    |> assign(:params, params)
    |> assign(:model_name, model_name)
    |> assign(:ans, [])
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
  def handle_event("selected", %{"model" => model}, socket) do
    {:noreply, push_patch(socket, to: "/#{model}", replace: true)}
  end

  @impl true
  def handle_event(
        "detect",
        _params,
        %{assigns: %{tensor: tensor, model: model, params: params}} = socket
      ) do
    ans =
      Axon.predict(model, params, tensor)
      |> Nx.flatten()
      |> Nx.argsort()
      |> Nx.reverse()
      |> Nx.slice([0], [5])
      |> Nx.to_flat_list()

    {:noreply, assign(socket, :ans, ans)}
  end

  @impl true
  def handle_event("clear", _params, socket) do
    socket =
      socket
      |> assign(:upload_file, nil)
      |> assign(:tensor, nil)
      |> assign(:ans, [])

    {:noreply, socket}
  end
end
