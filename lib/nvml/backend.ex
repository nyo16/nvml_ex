defmodule Nvml.Backend do
  @moduledoc """
  Backend module that determines whether to use real NVML NIFs or mock data.

  In dev/test mode: Tries real NIF first, falls back to mock if NVML unavailable.
  In prod mode: Always uses real NIF (fails if unavailable).
  """

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
      case Nvml.Native.init() do
        {:ok, _} -> true
        "NVML initialized successfully" -> true
        _ -> false
      end
    rescue
      _ -> false
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

  if Mix.env() == :prod do
    defp determine_native_module do
      # In prod, always use real NIF
      Nvml.Native
    end
  else
    defp determine_native_module do
      # In dev/test, fall back to mock if NVML unavailable
      if nvml_available?() do
        Nvml.Native
      else
        require Logger
        Logger.info("[Nvml] NVML not available, using mock backend")
        Nvml.NativeMock
      end
    end
  end
end
