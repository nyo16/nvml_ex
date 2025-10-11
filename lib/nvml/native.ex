defmodule Nvml.Native do
  @moduledoc """
  NIF bindings for NVML (NVIDIA Management Library).
  """

  use Rustler, otp_app: :nvml, crate: "nvml_native"

  # When your NIF is loaded, it will override these functions.
  def init(), do: :erlang.nif_error(:nif_not_loaded)
  def device_count(), do: :erlang.nif_error(:nif_not_loaded)
  def device_name(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_temperature(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_memory_info(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_utilization(_index), do: :erlang.nif_error(:nif_not_loaded)
end
