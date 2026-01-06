defmodule Nvml.Native do
  @moduledoc """
  NIF bindings for NVML (NVIDIA Management Library).
  """

  use Rustler, otp_app: :nvml, crate: "nvml_native"

  # When your NIF is loaded, it will override these functions.

  # Core functions
  def init(), do: :erlang.nif_error(:nif_not_loaded)
  def device_count(), do: :erlang.nif_error(:nif_not_loaded)
  def device_name(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_temperature(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_memory_info(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_utilization(_index), do: :erlang.nif_error(:nif_not_loaded)

  # Power management
  def device_power_usage(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_power_limit(_index), do: :erlang.nif_error(:nif_not_loaded)

  # Clock speeds
  def device_clock_info(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_max_clock_info(_index), do: :erlang.nif_error(:nif_not_loaded)

  # PCIe
  def device_pcie_link_info(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_pcie_throughput(_index), do: :erlang.nif_error(:nif_not_loaded)

  # Fan and performance
  def device_fan_speed(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_performance_state(_index), do: :erlang.nif_error(:nif_not_loaded)

  # Encoder/decoder
  def device_encoder_utilization(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_decoder_utilization(_index), do: :erlang.nif_error(:nif_not_loaded)

  # Device info
  def device_uuid(_index), do: :erlang.nif_error(:nif_not_loaded)

  # System info
  def driver_version(), do: :erlang.nif_error(:nif_not_loaded)
  def nvml_version(), do: :erlang.nif_error(:nif_not_loaded)

  # Process monitoring
  def device_compute_processes_count(_index), do: :erlang.nif_error(:nif_not_loaded)
  def device_graphics_processes_count(_index), do: :erlang.nif_error(:nif_not_loaded)

  # ECC errors
  def device_ecc_errors(_index), do: :erlang.nif_error(:nif_not_loaded)
end
