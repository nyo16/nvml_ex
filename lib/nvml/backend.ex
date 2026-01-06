defmodule Nvml.Backend do
  @moduledoc """
  Backend module that determines whether to use real NVML NIFs or mock data.

  In dev mode: Tries real NIF first, falls back to mock if NVML unavailable.
  In prod/test mode: Always uses real NIF (fails if unavailable).
  """

  @env Mix.env()

  @doc """
  Returns the appropriate native module based on environment and NVML availability.

  Caches the result to avoid repeated initialization checks.
  """
  def native_module do
    case :persistent_term.get({__MODULE__, :native_module}, nil) do
      nil ->
        module = determine_native_module()
        :persistent_term.put({__MODULE__, :native_module}, module)
        module

      module ->
        module
    end
  end

  @doc """
  Returns true if using the mock backend, false if using real NVML.
  """
  def mock? do
    native_module() == Nvml.NativeMock
  end

  @doc """
  Returns true if NVML is available on this system.
  """
  def nvml_available? do
    try do
      Nvml.Native.init()
      true
    rescue
      _ -> false
    catch
      :error, _ -> false
    end
  end

  @doc """
  Clears the cached backend selection. Useful for testing.
  """
  def reset do
    :persistent_term.erase({__MODULE__, :native_module})
    :ok
  end

  # Private

  defp determine_native_module do
    if @env == :dev do
      if nvml_available?() do
        Nvml.Native
      else
        require Logger
        Logger.info("[Nvml] NVML not available, using mock backend for development")
        Nvml.NativeMock
      end
    else
      # In prod/test, always use real NIF
      Nvml.Native
    end
  end
end
