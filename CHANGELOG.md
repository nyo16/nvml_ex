# Changelog

All notable changes to this project will be documented in this file.

## [0.2.6] - 2025-01-06

### Added
- Precompiled NIF support via `rustler_precompiled` - no Rust toolchain needed for users
- GitHub Actions CI workflow for automated testing
- GitHub Actions release workflow for building precompiled NIFs
- Release and checksum generation scripts

### Changed
- `rustler` is now an optional dependency (only needed for local development)

### Fixed
- Mock backend now properly falls back in test environment for CI without GPU
- Fixed `nvml_available?/0` to correctly check return values

## [0.2.0] - 2025-01-05

### Added
- Comprehensive NVML metrics support:
  - Power: `device_power_usage/1`, `device_power_limit/1`
  - Clocks: `device_clock_info/1`, `device_max_clock_info/1`
  - PCIe: `device_pcie_link_info/1`, `device_pcie_throughput/1`
  - Processes: `device_compute_processes_count/1`, `device_graphics_processes_count/1`
  - Video: `device_encoder_utilization/1`, `device_decoder_utilization/1`
  - Device info: `device_uuid/1`, `device_fan_speed/1`, `device_performance_state/1`
  - ECC: `device_ecc_errors/1`
  - System: `driver_version/0`, `nvml_version/0`
  - Helper: `device_full_info/1` (all metrics in one call)
- Mock backend (`Nvml.NativeMock`) with H100 NVL fixture data for development
- Backend module with automatic runtime fallback (real NIF → mock if unavailable)
- `mock?/0` and `available?/0` helper functions

### Changed
- Updated `nvml-wrapper` to use main branch from GitHub

## [0.1.0] - 2025-01-04

### Added
- Initial release
- Rustler NIF bindings for NVML
- Basic functions: `init/0`, `device_count/0`, `device_name/1`, `device_temperature/1`, `device_memory_info/1`, `device_utilization/1`
- `devices/0` helper to get info for all GPUs
