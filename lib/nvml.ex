defmodule Nvml do
  @moduledoc """
  Elixir wrapper for NVIDIA Management Library (NVML).

  Provides functions to monitor and manage NVIDIA GPU devices.
  """

  alias Nvml.Native

  @doc """
  Initialize NVML library.

  ## Examples

      iex> Nvml.init()
      {:ok, "NVML initialized successfully"}
  """
  def init do
    case Native.init() do
      result when is_binary(result) -> {:ok, result}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get the number of NVIDIA GPU devices in the system.

  ## Examples

      iex> Nvml.device_count()
      {:ok, 2}
  """
  def device_count do
    case Native.device_count() do
      count when is_integer(count) -> {:ok, count}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get the name of a GPU device by its index.

  ## Examples

      iex> Nvml.device_name(0)
      {:ok, "NVIDIA GeForce RTX 3080"}
  """
  def device_name(index) when is_integer(index) do
    case Native.device_name(index) do
      name when is_binary(name) -> {:ok, name}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get the temperature of a GPU device in Celsius.

  ## Examples

      iex> Nvml.device_temperature(0)
      {:ok, 45}
  """
  def device_temperature(index) when is_integer(index) do
    case Native.device_temperature(index) do
      temp when is_integer(temp) -> {:ok, temp}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get memory information for a GPU device.

  Returns a tuple with {total, free, used} memory in bytes.

  ## Examples

      iex> Nvml.device_memory_info(0)
      {:ok, %{total: 10737418240, free: 8589934592, used: 2147483648}}
  """
  def device_memory_info(index) when is_integer(index) do
    case Native.device_memory_info(index) do
      {total, free, used} ->
        {:ok, %{total: total, free: free, used: used}}
      {:error, _} = error -> error
    end
  end

  @doc """
  Get utilization rates for a GPU device.

  Returns GPU and memory utilization as percentages (0-100).

  ## Examples

      iex> Nvml.device_utilization(0)
      {:ok, %{gpu: 75, memory: 50}}
  """
  def device_utilization(index) when is_integer(index) do
    case Native.device_utilization(index) do
      {gpu, memory} ->
        {:ok, %{gpu: gpu, memory: memory}}
    end
  end

  @doc """
  Get information for all GPU devices in the system.

  ## Examples

      iex> Nvml.devices()
      {:ok, [
        %{
          index: 0,
          name: "NVIDIA GeForce RTX 3080",
          temperature: 45,
          memory: %{total: 10737418240, free: 8589934592, used: 2147483648},
          utilization: %{gpu: 75, memory: 50}
        }
      ]}
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
end
