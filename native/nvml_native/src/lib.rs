use nvml_wrapper::enum_wrappers::device::Clock;
use nvml_wrapper::Nvml;
use rustler::{Error, NifResult};

// Initialize NVML
#[rustler::nif]
fn init() -> NifResult<String> {
    match Nvml::init() {
        Ok(_) => Ok("NVML initialized successfully".to_string()),
        Err(e) => Err(Error::Term(Box::new(format!(
            "Failed to initialize NVML: {}",
            e
        )))),
    }
}

// Get device count
#[rustler::nif]
fn device_count() -> NifResult<u32> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let count = nvml
        .device_count()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device count: {}", e))))?;
    Ok(count)
}

// Get device name by index
#[rustler::nif]
fn device_name(index: u32) -> NifResult<String> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let name = device
        .name()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device name: {}", e))))?;
    Ok(name)
}

// Get device temperature
#[rustler::nif]
fn device_temperature(index: u32) -> NifResult<u32> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let temp = device
        .temperature(nvml_wrapper::enum_wrappers::device::TemperatureSensor::Gpu)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get temperature: {}", e))))?;
    Ok(temp)
}

// Get device memory info
#[rustler::nif]
fn device_memory_info(index: u32) -> NifResult<(u64, u64, u64)> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let memory = device
        .memory_info()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get memory info: {}", e))))?;
    Ok((memory.total, memory.free, memory.used))
}

// Get device utilization rates
#[rustler::nif]
fn device_utilization(index: u32) -> NifResult<(u32, u32)> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let utilization = device
        .utilization_rates()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get utilization: {}", e))))?;
    Ok((utilization.gpu, utilization.memory))
}

// Get device power usage in milliwatts
#[rustler::nif]
fn device_power_usage(index: u32) -> NifResult<u32> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let power = device
        .power_usage()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get power usage: {}", e))))?;
    Ok(power)
}

// Get device power limit in milliwatts
#[rustler::nif]
fn device_power_limit(index: u32) -> NifResult<u32> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let limit = device
        .power_management_limit()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get power limit: {}", e))))?;
    Ok(limit)
}

// Get device clock info (graphics, sm, memory) in MHz
#[rustler::nif]
fn device_clock_info(index: u32) -> NifResult<(u32, u32, u32)> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let graphics = device
        .clock_info(Clock::Graphics)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get graphics clock: {}", e))))?;
    let sm = device
        .clock_info(Clock::SM)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get SM clock: {}", e))))?;
    let memory = device
        .clock_info(Clock::Memory)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get memory clock: {}", e))))?;
    Ok((graphics, sm, memory))
}

// Get device max clock info (graphics, sm, memory) in MHz
#[rustler::nif]
fn device_max_clock_info(index: u32) -> NifResult<(u32, u32, u32)> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let graphics = device
        .max_clock_info(Clock::Graphics)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get max graphics clock: {}", e))))?;
    let sm = device
        .max_clock_info(Clock::SM)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get max SM clock: {}", e))))?;
    let memory = device
        .max_clock_info(Clock::Memory)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get max memory clock: {}", e))))?;
    Ok((graphics, sm, memory))
}

// Get PCIe link info (generation, width)
#[rustler::nif]
fn device_pcie_link_info(index: u32) -> NifResult<(u32, u32)> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let gen = device
        .current_pcie_link_gen()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get PCIe gen: {}", e))))?;
    let width = device
        .current_pcie_link_width()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get PCIe width: {}", e))))?;
    Ok((gen, width))
}

// Get PCIe throughput (tx, rx) in KB/s
#[rustler::nif]
fn device_pcie_throughput(index: u32) -> NifResult<(u32, u32)> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let tx = device
        .pcie_throughput(nvml_wrapper::enum_wrappers::device::PcieUtilCounter::Send)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get PCIe TX: {}", e))))?;
    let rx = device
        .pcie_throughput(nvml_wrapper::enum_wrappers::device::PcieUtilCounter::Receive)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get PCIe RX: {}", e))))?;
    Ok((tx, rx))
}

// Get fan speed percentage (0-100)
#[rustler::nif]
fn device_fan_speed(index: u32) -> NifResult<u32> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let speed = device
        .fan_speed(0)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get fan speed: {}", e))))?;
    Ok(speed)
}

// Get performance state (P-state 0-15)
#[rustler::nif]
fn device_performance_state(index: u32) -> NifResult<u32> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let state = device
        .performance_state()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get performance state: {}", e))))?;
    Ok(state as u32)
}

// Get encoder utilization (utilization percentage, sampling period in us)
#[rustler::nif]
fn device_encoder_utilization(index: u32) -> NifResult<(u32, u32)> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let util = device.encoder_utilization().map_err(|e| {
        Error::Term(Box::new(format!(
            "Failed to get encoder utilization: {}",
            e
        )))
    })?;
    Ok((util.utilization, util.sampling_period))
}

// Get decoder utilization (utilization percentage, sampling period in us)
#[rustler::nif]
fn device_decoder_utilization(index: u32) -> NifResult<(u32, u32)> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let util = device.decoder_utilization().map_err(|e| {
        Error::Term(Box::new(format!(
            "Failed to get decoder utilization: {}",
            e
        )))
    })?;
    Ok((util.utilization, util.sampling_period))
}

// Get device UUID
#[rustler::nif]
fn device_uuid(index: u32) -> NifResult<String> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let uuid = device
        .uuid()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get UUID: {}", e))))?;
    Ok(uuid)
}

// Get NVIDIA driver version
#[rustler::nif]
fn driver_version() -> NifResult<String> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let version = nvml
        .sys_driver_version()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get driver version: {}", e))))?;
    Ok(version)
}

// Get NVML version
#[rustler::nif]
fn nvml_version() -> NifResult<String> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let version = nvml
        .sys_nvml_version()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get NVML version: {}", e))))?;
    Ok(version)
}

// Get running compute processes count
#[rustler::nif]
fn device_compute_processes_count(index: u32) -> NifResult<u32> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let processes = device
        .running_compute_processes()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get compute processes: {}", e))))?;
    Ok(processes.len() as u32)
}

// Get running graphics processes count
#[rustler::nif]
fn device_graphics_processes_count(index: u32) -> NifResult<u32> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let processes = device
        .running_graphics_processes()
        .map_err(|e| Error::Term(Box::new(format!("Failed to get graphics processes: {}", e))))?;
    Ok(processes.len() as u32)
}

// Get total ECC errors (corrected, uncorrected) - returns 0,0 if not supported
#[rustler::nif]
fn device_ecc_errors(index: u32) -> NifResult<(u64, u64)> {
    let nvml = Nvml::init()
        .map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml
        .device_by_index(index)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;

    use nvml_wrapper::enum_wrappers::device::{EccCounter, MemoryError};

    let corrected = device
        .total_ecc_errors(MemoryError::Corrected, EccCounter::Aggregate)
        .unwrap_or(0);
    let uncorrected = device
        .total_ecc_errors(MemoryError::Uncorrected, EccCounter::Aggregate)
        .unwrap_or(0);

    Ok((corrected, uncorrected))
}

rustler::init!("Elixir.Nvml.Native");
