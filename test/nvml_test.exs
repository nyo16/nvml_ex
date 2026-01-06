defmodule NvmlTest do
  use ExUnit.Case
  doctest Nvml

  @moduletag :nvml

  test "initializes NVML" do
    result = Nvml.init()
    assert {:ok, _message} = result
  end

  test "gets device count" do
    result = Nvml.device_count()
    assert {:ok, count} = result
    assert is_integer(count)
    assert count >= 0
  end

  test "gets device name" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_name(0)
      assert {:ok, name} = result
      assert is_binary(name)
    end
  end

  test "gets device temperature" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_temperature(0)
      assert {:ok, temp} = result
      assert is_integer(temp)
      assert temp > 0
    end
  end

  test "gets device memory info" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_memory_info(0)
      assert {:ok, %{total: total, free: free, used: used}} = result
      assert is_integer(total)
      assert is_integer(free)
      assert is_integer(used)
      assert total > 0
    end
  end

  test "gets device utilization" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_utilization(0)
      assert {:ok, %{gpu: gpu, memory: memory}} = result
      assert is_integer(gpu)
      assert is_integer(memory)
      assert gpu >= 0 and gpu <= 100
      assert memory >= 0 and memory <= 100
    end
  end

  test "gets all devices info" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.devices()
      assert {:ok, devices} = result
      assert is_list(devices)
      assert length(devices) == count

      for device <- devices do
        assert Map.has_key?(device, :index)
        assert Map.has_key?(device, :name)
        assert Map.has_key?(device, :temperature)
        assert Map.has_key?(device, :memory)
        assert Map.has_key?(device, :utilization)
      end
    end
  end

  # New tests for added functionality

  test "gets device power usage" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_power_usage(0)
      assert {:ok, power} = result
      assert is_integer(power)
      assert power >= 0
    end
  end

  test "gets device power limit" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_power_limit(0)
      assert {:ok, limit} = result
      assert is_integer(limit)
      assert limit > 0
    end
  end

  test "gets device clock info" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_clock_info(0)
      assert {:ok, %{graphics: g, sm: s, memory: m}} = result
      assert is_integer(g) and g >= 0
      assert is_integer(s) and s >= 0
      assert is_integer(m) and m >= 0
    end
  end

  test "gets device max clock info" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_max_clock_info(0)
      assert {:ok, %{graphics: g, sm: s, memory: m}} = result
      assert is_integer(g) and g > 0
      assert is_integer(s) and s > 0
      assert is_integer(m) and m > 0
    end
  end

  test "gets device PCIe link info" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_pcie_link_info(0)
      assert {:ok, %{generation: gen, width: width}} = result
      assert is_integer(gen) and gen > 0
      assert is_integer(width) and width > 0
    end
  end

  test "gets device PCIe throughput" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_pcie_throughput(0)
      assert {:ok, %{tx: tx, rx: rx}} = result
      assert is_integer(tx) and tx >= 0
      assert is_integer(rx) and rx >= 0
    end
  end

  test "gets device performance state" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_performance_state(0)
      assert {:ok, state} = result
      assert is_integer(state)
      assert state >= 0 and state <= 15
    end
  end

  test "gets device encoder utilization" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_encoder_utilization(0)
      assert {:ok, %{utilization: util, sampling_period: period}} = result
      assert is_integer(util) and util >= 0
      assert is_integer(period) and period > 0
    end
  end

  test "gets device decoder utilization" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_decoder_utilization(0)
      assert {:ok, %{utilization: util, sampling_period: period}} = result
      assert is_integer(util) and util >= 0
      assert is_integer(period) and period > 0
    end
  end

  test "gets device UUID" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_uuid(0)
      assert {:ok, uuid} = result
      assert is_binary(uuid)
      assert String.starts_with?(uuid, "GPU-")
    end
  end

  test "gets driver version" do
    result = Nvml.driver_version()
    assert {:ok, version} = result
    assert is_binary(version)
  end

  test "gets NVML version" do
    result = Nvml.nvml_version()
    assert {:ok, version} = result
    assert is_binary(version)
  end

  test "gets device compute processes count" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_compute_processes_count(0)
      assert {:ok, procs} = result
      assert is_integer(procs) and procs >= 0
    end
  end

  test "gets device graphics processes count" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_graphics_processes_count(0)
      assert {:ok, procs} = result
      assert is_integer(procs) and procs >= 0
    end
  end

  test "gets device ECC errors" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_ecc_errors(0)
      assert {:ok, %{corrected: c, uncorrected: u}} = result
      assert is_integer(c) and c >= 0
      assert is_integer(u) and u >= 0
    end
  end

  test "gets device full info" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_full_info(0)
      assert {:ok, info} = result
      assert Map.has_key?(info, :name)
      assert Map.has_key?(info, :uuid)
      assert Map.has_key?(info, :temperature)
      assert Map.has_key?(info, :memory)
      assert Map.has_key?(info, :utilization)
      assert Map.has_key?(info, :power)
      assert Map.has_key?(info, :clocks)
      assert Map.has_key?(info, :max_clocks)
      assert Map.has_key?(info, :pcie)
      assert Map.has_key?(info, :performance_state)
      assert Map.has_key?(info, :encoder)
      assert Map.has_key?(info, :decoder)
      assert Map.has_key?(info, :processes)
      assert Map.has_key?(info, :ecc_errors)
    end
  end

  test "fan speed returns ok or error" do
    {:ok, count} = Nvml.device_count()

    if count > 0 do
      result = Nvml.device_fan_speed(0)
      # Fan speed may not be supported on all GPUs (e.g., data center GPUs)
      assert match?({:ok, _}, result) or match?({:error, _}, result)
    end
  end

  test "mock? returns boolean" do
    result = Nvml.mock?()
    assert is_boolean(result)
  end

  test "available? returns boolean" do
    result = Nvml.available?()
    assert is_boolean(result)
  end
end
