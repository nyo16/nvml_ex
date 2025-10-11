use nvml_wrapper::Nvml;
use rustler::{NifResult, Error};

// Initialize NVML
#[rustler::nif]
fn init() -> NifResult<String> {
    match Nvml::init() {
        Ok(_) => Ok("NVML initialized successfully".to_string()),
        Err(e) => Err(Error::Term(Box::new(format!("Failed to initialize NVML: {}", e)))),
    }
}

// Get device count
#[rustler::nif]
fn device_count() -> NifResult<u32> {
    let nvml = Nvml::init().map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let count = nvml.device_count().map_err(|e| Error::Term(Box::new(format!("Failed to get device count: {}", e))))?;
    Ok(count)
}

// Get device name by index
#[rustler::nif]
fn device_name(index: u32) -> NifResult<String> {
    let nvml = Nvml::init().map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml.device_by_index(index).map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let name = device.name().map_err(|e| Error::Term(Box::new(format!("Failed to get device name: {}", e))))?;
    Ok(name)
}

// Get device temperature
#[rustler::nif]
fn device_temperature(index: u32) -> NifResult<u32> {
    let nvml = Nvml::init().map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml.device_by_index(index).map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let temp = device.temperature(nvml_wrapper::enum_wrappers::device::TemperatureSensor::Gpu)
        .map_err(|e| Error::Term(Box::new(format!("Failed to get temperature: {}", e))))?;
    Ok(temp)
}

// Get device memory info
#[rustler::nif]
fn device_memory_info(index: u32) -> NifResult<(u64, u64, u64)> {
    let nvml = Nvml::init().map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml.device_by_index(index).map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let memory = device.memory_info().map_err(|e| Error::Term(Box::new(format!("Failed to get memory info: {}", e))))?;
    Ok((memory.total, memory.free, memory.used))
}

// Get device utilization rates
#[rustler::nif]
fn device_utilization(index: u32) -> NifResult<(u32, u32)> {
    let nvml = Nvml::init().map_err(|e| Error::Term(Box::new(format!("Failed to initialize NVML: {}", e))))?;
    let device = nvml.device_by_index(index).map_err(|e| Error::Term(Box::new(format!("Failed to get device: {}", e))))?;
    let utilization = device.utilization_rates().map_err(|e| Error::Term(Box::new(format!("Failed to get utilization: {}", e))))?;
    Ok((utilization.gpu, utilization.memory))
}

rustler::init!("Elixir.Nvml.Native");
