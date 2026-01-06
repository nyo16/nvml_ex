defmodule Nvml do
  @moduledoc """
  Elixir wrapper for NVIDIA Management Library (NVML).

  Provides functions to monitor and manage NVIDIA GPU devices.

  In development mode, if NVML is not available (e.g., on a Mac),
  this module will automatically fall back to mock data.
  """

  alias Nvml.Backend

  defp native, do: Backend.native_module()

  @doc """
  Returns true if using mock backend, false if using real NVML.
  """
  def mock?, do: Backend.mock?()

  @doc """
  Returns true if NVML is available on this system.
  """
  def available?, do: Backend.nvml_available?()

  @doc """
  Initialize NVML library.

  ## Examples

      iex> {:ok, _msg} = Nvml.init()
  """
  def init do
    case native().init() do
      result when is_binary(result) -> {:ok, result}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get the number of NVIDIA GPU devices in the system.

  ## Examples

      iex> {:ok, count} = Nvml.device_count()
      iex> is_integer(count)
      true
  """
  def device_count do
    case native().device_count() do
      count when is_integer(count) -> {:ok, count}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get the name of a GPU device by its index.

  ## Examples

      iex> {:ok, name} = Nvml.device_name(0)
      iex> is_binary(name)
      true
  """
  def device_name(index) when is_integer(index) do
    case native().device_name(index) do
      name when is_binary(name) -> {:ok, name}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get the temperature of a GPU device in Celsius.

  ## Examples

      iex> {:ok, temp} = Nvml.device_temperature(0)
      iex> is_integer(temp)
      true
  """
  def device_temperature(index) when is_integer(index) do
    case native().device_temperature(index) do
      temp when is_integer(temp) -> {:ok, temp}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get memory information for a GPU device.

  Returns a map with total, free, and used memory in bytes.

  ## Examples

      iex> {:ok, %{total: total, free: _free, used: _used}} = Nvml.device_memory_info(0)
      iex> total > 0
      true
  """
  def device_memory_info(index) when is_integer(index) do
    case native().device_memory_info(index) do
      {total, free, used} ->
        {:ok, %{total: total, free: free, used: used}}

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Get utilization rates for a GPU device.

  Returns GPU and memory utilization as percentages (0-100).

  ## Examples

      iex> {:ok, %{gpu: gpu, memory: _memory}} = Nvml.device_utilization(0)
      iex> gpu >= 0 and gpu <= 100
      true
  """
  def device_utilization(index) when is_integer(index) do
    {gpu, memory} = native().device_utilization(index)
    {:ok, %{gpu: gpu, memory: memory}}
  end

  @doc """
  Get power usage for a GPU device in milliwatts.

  ## Examples

      iex> {:ok, power} = Nvml.device_power_usage(0)
      iex> is_integer(power)
      true
  """
  def device_power_usage(index) when is_integer(index) do
    case native().device_power_usage(index) do
      power when is_integer(power) -> {:ok, power}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get power management limit for a GPU device in milliwatts.

  ## Examples

      iex> {:ok, limit} = Nvml.device_power_limit(0)
      iex> is_integer(limit)
      true
  """
  def device_power_limit(index) when is_integer(index) do
    case native().device_power_limit(index) do
      limit when is_integer(limit) -> {:ok, limit}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get current clock speeds for a GPU device in MHz.

  Returns graphics, SM (streaming multiprocessor), and memory clocks.

  ## Examples

      iex> {:ok, %{graphics: g, sm: _s, memory: _m}} = Nvml.device_clock_info(0)
      iex> g > 0
      true
  """
  def device_clock_info(index) when is_integer(index) do
    case native().device_clock_info(index) do
      {graphics, sm, memory} ->
        {:ok, %{graphics: graphics, sm: sm, memory: memory}}

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Get maximum clock speeds for a GPU device in MHz.

  Returns maximum graphics, SM, and memory clocks.

  ## Examples

      iex> {:ok, %{graphics: g, sm: _s, memory: _m}} = Nvml.device_max_clock_info(0)
      iex> g > 0
      true
  """
  def device_max_clock_info(index) when is_integer(index) do
    case native().device_max_clock_info(index) do
      {graphics, sm, memory} ->
        {:ok, %{graphics: graphics, sm: sm, memory: memory}}

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Get PCIe link information for a GPU device.

  Returns PCIe generation and lane width.

  ## Examples

      iex> {:ok, %{generation: gen, width: _width}} = Nvml.device_pcie_link_info(0)
      iex> gen > 0
      true
  """
  def device_pcie_link_info(index) when is_integer(index) do
    {gen, width} = native().device_pcie_link_info(index)
    {:ok, %{generation: gen, width: width}}
  end

  @doc """
  Get PCIe throughput for a GPU device in KB/s.

  Returns TX (send) and RX (receive) throughput.

  ## Examples

      iex> {:ok, %{tx: tx, rx: _rx}} = Nvml.device_pcie_throughput(0)
      iex> is_integer(tx)
      true
  """
  def device_pcie_throughput(index) when is_integer(index) do
    {tx, rx} = native().device_pcie_throughput(index)
    {:ok, %{tx: tx, rx: rx}}
  end

  @doc """
  Get fan speed for a GPU device as a percentage (0-100).

  Note: Not all GPUs support fan speed reading (e.g., data center GPUs
  with liquid cooling may not report fan speed).

  ## Examples

      iex> result = Nvml.device_fan_speed(0)
      iex> match?({:ok, _}, result) or match?({:error, _}, result)
      true
  """
  def device_fan_speed(index) when is_integer(index) do
    case native().device_fan_speed(index) do
      speed when is_integer(speed) -> {:ok, speed}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get performance state (P-state) for a GPU device.

  P-states range from 0 (maximum performance) to 15 (minimum performance).

  ## Examples

      iex> {:ok, state} = Nvml.device_performance_state(0)
      iex> state >= 0 and state <= 15
      true
  """
  def device_performance_state(index) when is_integer(index) do
    case native().device_performance_state(index) do
      state when is_integer(state) -> {:ok, state}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get video encoder utilization for a GPU device.

  Returns utilization percentage and sampling period in microseconds.

  ## Examples

      iex> {:ok, %{utilization: util, sampling_period: _period}} = Nvml.device_encoder_utilization(0)
      iex> util >= 0
      true
  """
  def device_encoder_utilization(index) when is_integer(index) do
    {utilization, sampling_period} = native().device_encoder_utilization(index)
    {:ok, %{utilization: utilization, sampling_period: sampling_period}}
  end

  @doc """
  Get video decoder utilization for a GPU device.

  Returns utilization percentage and sampling period in microseconds.

  ## Examples

      iex> {:ok, %{utilization: util, sampling_period: _period}} = Nvml.device_decoder_utilization(0)
      iex> util >= 0
      true
  """
  def device_decoder_utilization(index) when is_integer(index) do
    {utilization, sampling_period} = native().device_decoder_utilization(index)
    {:ok, %{utilization: utilization, sampling_period: sampling_period}}
  end

  @doc """
  Get UUID for a GPU device.

  ## Examples

      iex> {:ok, uuid} = Nvml.device_uuid(0)
      iex> is_binary(uuid)
      true
  """
  def device_uuid(index) when is_integer(index) do
    case native().device_uuid(index) do
      uuid when is_binary(uuid) -> {:ok, uuid}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get NVIDIA driver version.

  ## Examples

      iex> {:ok, version} = Nvml.driver_version()
      iex> is_binary(version)
      true
  """
  def driver_version do
    case native().driver_version() do
      version when is_binary(version) -> {:ok, version}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get NVML library version.

  ## Examples

      iex> {:ok, version} = Nvml.nvml_version()
      iex> is_binary(version)
      true
  """
  def nvml_version do
    case native().nvml_version() do
      version when is_binary(version) -> {:ok, version}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get count of running compute processes on a GPU device.

  ## Examples

      iex> {:ok, count} = Nvml.device_compute_processes_count(0)
      iex> is_integer(count)
      true
  """
  def device_compute_processes_count(index) when is_integer(index) do
    case native().device_compute_processes_count(index) do
      count when is_integer(count) -> {:ok, count}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get count of running graphics processes on a GPU device.

  ## Examples

      iex> {:ok, count} = Nvml.device_graphics_processes_count(0)
      iex> is_integer(count)
      true
  """
  def device_graphics_processes_count(index) when is_integer(index) do
    case native().device_graphics_processes_count(index) do
      count when is_integer(count) -> {:ok, count}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get ECC error counts for a GPU device.

  Returns corrected and uncorrected error counts. On GPUs that don't
  support ECC, returns {0, 0}.

  ## Examples

      iex> {:ok, %{corrected: c, uncorrected: _u}} = Nvml.device_ecc_errors(0)
      iex> c >= 0
      true
  """
  def device_ecc_errors(index) when is_integer(index) do
    {corrected, uncorrected} = native().device_ecc_errors(index)
    {:ok, %{corrected: corrected, uncorrected: uncorrected}}
  end

  @doc """
  Get comprehensive information for all GPU devices in the system.

  ## Examples

      iex> {:ok, devices} = Nvml.devices()
      iex> is_list(devices)
      true
  """
  def devices do
    with {:ok, count} <- device_count() do
      devices =
        Enum.map(0..(count - 1), fn index ->
          {:ok, name} = device_name(index)
          {:ok, temp} = device_temperature(index)
          {:ok, memory} = device_memory_info(index)
          {:ok, util} = device_utilization(index)

          %{
            index: index,
            name: name,
            temperature: temp,
            memory: memory,
            utilization: util
          }
        end)

      {:ok, devices}
    end
  end

  @doc """
  Get full information for a single GPU device.

  Returns all available metrics for the device.

  ## Examples

      iex> {:ok, info} = Nvml.device_full_info(0)
      iex> Map.has_key?(info, :name)
      true
  """
  def device_full_info(index) when is_integer(index) do
    with {:ok, name} <- device_name(index),
         {:ok, uuid} <- device_uuid(index),
         {:ok, temp} <- device_temperature(index),
         {:ok, memory} <- device_memory_info(index),
         {:ok, util} <- device_utilization(index),
         {:ok, power_usage} <- device_power_usage(index),
         {:ok, power_limit} <- device_power_limit(index),
         {:ok, clocks} <- device_clock_info(index),
         {:ok, max_clocks} <- device_max_clock_info(index),
         {:ok, pcie_link} <- device_pcie_link_info(index),
         {:ok, pcie_throughput} <- device_pcie_throughput(index),
         {:ok, perf_state} <- device_performance_state(index),
         {:ok, encoder} <- device_encoder_utilization(index),
         {:ok, decoder} <- device_decoder_utilization(index),
         {:ok, compute_procs} <- device_compute_processes_count(index),
         {:ok, graphics_procs} <- device_graphics_processes_count(index),
         {:ok, ecc} <- device_ecc_errors(index) do
      fan = device_fan_speed(index)

      {:ok,
       %{
         index: index,
         name: name,
         uuid: uuid,
         temperature: temp,
         memory: memory,
         utilization: util,
         power: %{
           usage: power_usage,
           limit: power_limit
         },
         clocks: clocks,
         max_clocks: max_clocks,
         pcie: %{
           link: pcie_link,
           throughput: pcie_throughput
         },
         performance_state: perf_state,
         encoder: encoder,
         decoder: decoder,
         processes: %{
           compute: compute_procs,
           graphics: graphics_procs
         },
         ecc_errors: ecc,
         fan_speed:
           case fan do
             {:ok, speed} -> speed
             {:error, _} -> nil
           end
       }}
    end
  end
end
