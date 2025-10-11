# Nvml

Elixir bindings for NVIDIA Management Library (NVML) using Rustler and the [nvml-wrapper](https://github.com/rust-nvml/nvml-wrapper) Rust crate.

This library provides a high-level Elixir API for monitoring and managing NVIDIA GPU devices.

## Features

- Get GPU device count
- Query device name
- Monitor GPU temperature
- Check memory usage (total, free, used)
- Get GPU and memory utilization rates
- Query all devices at once

## Requirements

- NVIDIA GPU with driver installed
- NVIDIA CUDA toolkit (for NVML library)
- Rust toolchain (for building the NIF)

## Installation

Add `nvml` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nvml, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
# Initialize NVML
{:ok, _message} = Nvml.init()

# Get number of GPU devices
{:ok, count} = Nvml.device_count()

# Get device name
{:ok, name} = Nvml.device_name(0)

# Get device temperature (in Celsius)
{:ok, temp} = Nvml.device_temperature(0)

# Get memory information
{:ok, %{total: total, free: free, used: used}} = Nvml.device_memory_info(0)

# Get utilization rates (0-100%)
{:ok, %{gpu: gpu_util, memory: mem_util}} = Nvml.device_utilization(0)

# Get all device information at once
{:ok, devices} = Nvml.devices()
```

## Example Output

```elixir
iex> Nvml.init()
{:ok, "NVML initialized successfully"}

iex> Nvml.device_count()
{:ok, 1}

iex> Nvml.device_name(0)
{:ok, "NVIDIA GeForce RTX 3080"}

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
```

## Testing

To run tests (requires NVIDIA GPU):

```bash
mix test
```

## License

[Your License Here]

