defmodule Nvml.NativeMock do
  @moduledoc """
  Mock implementation of NVML NIF bindings for development on unsupported platforms.

  Uses fixture data based on real NVIDIA H100 NVL hardware.
  """

  # Fixture data based on real H100 NVL system
  @mock_devices [
    %{
      index: 0,
      name: "NVIDIA H100 NVL",
      uuid: "GPU-mock-0000-0000-0000-000000000000",
      temperature: 49,
      memory: {100_485_038_080, 99_957_604_352, 3_670_016},
      utilization: {0, 0},
      power_usage: 64544,
      power_limit: 400_000,
      clock_info: {345, 345, 2619},
      max_clock_info: {1785, 1785, 2619},
      pcie_link_info: {5, 16},
      pcie_throughput: {844, 880},
      fan_speed: nil,
      performance_state: 0,
      encoder_utilization: {0, 100_000},
      decoder_utilization: {0, 100_000},
      compute_processes: 0,
      graphics_processes: 0,
      ecc_errors: {0, 0}
    },
    %{
      index: 1,
      name: "NVIDIA H100 NVL",
      uuid: "GPU-mock-1111-1111-1111-111111111111",
      temperature: 48,
      memory: {100_485_038_080, 99_957_604_352, 3_670_016},
      utilization: {0, 0},
      power_usage: 63000,
      power_limit: 400_000,
      clock_info: {345, 345, 2619},
      max_clock_info: {1785, 1785, 2619},
      pcie_link_info: {5, 16},
      pcie_throughput: {800, 850},
      fan_speed: nil,
      performance_state: 0,
      encoder_utilization: {0, 100_000},
      decoder_utilization: {0, 100_000},
      compute_processes: 0,
      graphics_processes: 0,
      ecc_errors: {0, 0}
    }
  ]

  @driver_version "570.86.15"
  @nvml_version "12.570.86.15"

  # Core functions
  def init(), do: "NVML initialized successfully (mock)"

  def device_count(), do: length(@mock_devices)

  def device_name(index), do: get_device(index).name

  def device_temperature(index), do: get_device(index).temperature

  def device_memory_info(index), do: get_device(index).memory

  def device_utilization(index), do: get_device(index).utilization

  # Power management
  def device_power_usage(index), do: get_device(index).power_usage

  def device_power_limit(index), do: get_device(index).power_limit

  # Clock speeds
  def device_clock_info(index), do: get_device(index).clock_info

  def device_max_clock_info(index), do: get_device(index).max_clock_info

  # PCIe
  def device_pcie_link_info(index), do: get_device(index).pcie_link_info

  def device_pcie_throughput(index), do: get_device(index).pcie_throughput

  # Fan and performance
  def device_fan_speed(index) do
    case get_device(index).fan_speed do
      nil -> {:error, "Fan speed not supported on this device (mock)"}
      speed -> speed
    end
  end

  def device_performance_state(index), do: get_device(index).performance_state

  # Encoder/decoder
  def device_encoder_utilization(index), do: get_device(index).encoder_utilization

  def device_decoder_utilization(index), do: get_device(index).decoder_utilization

  # Device info
  def device_uuid(index), do: get_device(index).uuid

  # System info
  def driver_version(), do: @driver_version

  def nvml_version(), do: @nvml_version

  # Process monitoring
  def device_compute_processes_count(index), do: get_device(index).compute_processes

  def device_graphics_processes_count(index), do: get_device(index).graphics_processes

  # ECC errors
  def device_ecc_errors(index), do: get_device(index).ecc_errors

  # Helper to get device by index
  defp get_device(index) when is_integer(index) and index >= 0 do
    case Enum.at(@mock_devices, index) do
      nil -> raise "Device index #{index} out of range (mock has #{length(@mock_devices)} devices)"
      device -> device
    end
  end
end
