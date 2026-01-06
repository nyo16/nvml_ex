# Nvml

[![Hex.pm](https://img.shields.io/hexpm/v/nvml.svg)](https://hex.pm/packages/nvml)
[![CI](https://github.com/nyo16/nvml_ex/actions/workflows/ci.yml/badge.svg)](https://github.com/nyo16/nvml_ex/actions/workflows/ci.yml)

Elixir bindings for NVIDIA Management Library (NVML) using Rustler and the [nvml-wrapper](https://github.com/rust-nvml/nvml-wrapper) Rust crate.

This library provides a high-level Elixir API for monitoring and managing NVIDIA GPU devices. Precompiled binaries are available, so no Rust toolchain is required.

## Features

- **Device Info**: Count, name, UUID
- **Temperature**: GPU temperature monitoring
- **Memory**: Total, free, used memory
- **Utilization**: GPU and memory utilization rates
- **Power**: Usage and limits (milliwatts)
- **Clocks**: Current and max clock speeds (graphics, SM, memory)
- **PCIe**: Link generation, width, throughput
- **Fan & Performance**: Fan speed, P-state
- **Video**: Encoder/decoder utilization
- **Processes**: Compute and graphics process counts
- **ECC**: Error correction counts
- **System**: Driver and NVML versions

## Requirements

- NVIDIA GPU with driver installed
- Linux x86_64 (precompiled binaries available)

For local development without precompiled binaries:
- Rust toolchain
- Set `NVML_BUILD=true` environment variable

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

# Get power usage
{:ok, power_mw} = Nvml.device_power_usage(0)

# Get all device information at once
{:ok, devices} = Nvml.devices()

# Get comprehensive device info (all metrics in one call)
{:ok, info} = Nvml.device_full_info(0)
```

## Example Output

```elixir
iex> Nvml.init()
{:ok, "NVML initialized successfully"}

iex> Nvml.device_count()
{:ok, 2}

iex> Nvml.device_name(0)
{:ok, "NVIDIA H100 NVL"}

iex> Nvml.device_full_info(0)
{:ok, %{
  index: 0,
  name: "NVIDIA H100 NVL",
  uuid: "GPU-12345678-1234-1234-1234-123456789abc",
  temperature: 42,
  memory: %{total: 96636764160, free: 95497953280, used: 1138810880},
  utilization: %{gpu: 0, memory: 0},
  power: %{usage: 72000, limit: 400000},
  clocks: %{graphics: 1980, sm: 1980, memory: 2619},
  max_clocks: %{graphics: 1980, sm: 1980, memory: 2619},
  pcie: %{generation: 5, width: 16, tx_throughput: 0, rx_throughput: 0},
  encoder: %{utilization: 0, sampling_period: 167000},
  decoder: %{utilization: 0, sampling_period: 167000},
  performance_state: 0,
  processes: %{compute: 0, graphics: 0},
  ecc_errors: %{corrected: 0, uncorrected: 0},
  fan_speed: nil
}}
```

## Development

### Building from Source

```bash
# Clone the repo
git clone https://github.com/nyo16/nvml_ex.git
cd nvml_ex

# Install dependencies
mix deps.get

# Compile with Rust (requires Rust toolchain)
NVML_BUILD=true mix compile

# Run tests
NVML_BUILD=true mix test
```

### Mock Backend

For development without an NVIDIA GPU, the library includes a mock backend with H100 NVL fixture data:

```elixir
# Check if using mock backend
Nvml.mock?()  # => true/false

# Check if NVML is available
Nvml.available?()  # => true/false
```

## License

Apache-2.0

