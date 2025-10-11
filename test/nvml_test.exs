defmodule NvmlTest do
  use ExUnit.Case
  doctest Nvml

  @moduletag :nvml

  test "initializes NVML" do
    result = Nvml.init()
    assert {:ok, _message} = result
  end

  test "gets device count" do
    Nvml.init()
    result = Nvml.device_count()
    assert {:ok, count} = result
    assert is_integer(count)
    assert count >= 0
  end

  test "gets device name" do
    Nvml.init()
    {:ok, count} = Nvml.device_count()
    if count > 0 do
      result = Nvml.device_name(0)
      assert {:ok, name} = result
      assert is_binary(name)
    end
  end

  test "gets device temperature" do
    Nvml.init()
    {:ok, count} = Nvml.device_count()
    if count > 0 do
      result = Nvml.device_temperature(0)
      assert {:ok, temp} = result
      assert is_integer(temp)
      assert temp > 0
    end
  end

  test "gets device memory info" do
    Nvml.init()
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
    Nvml.init()
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
    Nvml.init()
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
end
