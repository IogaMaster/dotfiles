# lib/hardware-detection.nix
# NixOS-native hardware detection utilities for parsing facter output and system state
# Provides functions to extract hardware specs from facter.json and runtime queries
{ lib }:
let
  inherit (lib)
    attrByPath
    hasAttrByPath
    optional
    optionalAttrs
    ;
in
rec {
  # Extract CPU information from facter data
  extractCPU =
    facter:
    let
      processors = attrByPath [ "hardware" "processor" ] [ ] facter;
      cpu = lib.lists.findFirst (p: p != null) null processors;
    in
    optionalAttrs (cpu != null) {
      model = cpu.version or "Unknown";
      manufacturer = cpu.manufacturer or "Unknown";
      clockMax = cpu.clock_max or null;
      clockExt = cpu.clock_ext or null;
      cores = (lib.strings.match ".*([0-9]+)-core.*" (cpu.version or "")) != null;
    };

  # Extract GPU/Display information from facter data
  extractGPU =
    facter:
    let
      devices = attrByPath [ "hardware" "display" ] [ ] facter;
    in
    if lib.length devices > 0 then
      {
        hasDisplay = true;
        displayCount = lib.length devices;
        devices = lib.map (d: {
          vendor = d.vendor or "Unknown";
          model = d.model or "Unknown";
          driver = d.driver or null;
        }) devices;
      }
    else
      {
        hasDisplay = false;
        displayCount = 0;
        devices = [ ];
      };

  # Extract memory information from facter data
  extractMemory =
    facter:
    let
      memory = attrByPath [ "hardware" "memory" ] [ ] facter;
      totalMemory = lib.lists.foldl' (acc: m: acc + (m.size or 0)) 0 memory;
    in
    {
      count = lib.length memory;
      totalSize = totalMemory;
      modules = lib.map (m: {
        size = m.size or "Unknown";
        speed = m.speed or null;
        type = m.type or "Unknown";
      }) memory;
    };

  # Extract storage device information from facter data
  extractStorage =
    facter:
    let
      devices = attrByPath [ "hardware" "disk" ] [ ] facter;
      nvmeDevices = lib.filter (d: lib.hasPrefix "nvme" d.name) devices;
    in
    {
      totalDevices = lib.length devices;
      nvmeCount = lib.length nvmeDevices;
      devices = lib.map (d: {
        name = d.name or "Unknown";
        size = d.size or null;
        model = d.model or "Unknown";
        rotational = d.rota or false;
        transport = d.tran or "Unknown";
      }) devices;
      nvmeDevices = lib.map (d: {
        inherit (d) name;
        size = d.size or null;
        model = d.model or "Unknown";
      }) nvmeDevices;
    };

  # Extract network device information from facter data
  extractNetwork =
    facter:
    let
      devices = attrByPath [ "hardware" "network" ] [ ] facter;
    in
    {
      count = lib.length devices;
      devices = lib.map (d: {
        vendor = d.vendor or "Unknown";
        model = d.model or "Unknown";
        driver = d.driver or null;
      }) devices;
    };

  # Detect if system is ASUS ROG based on facter data
  isASUSROG =
    facter:
    let
      system = attrByPath [ "hardware" "system" ] { } facter;
      manufacturer = system.manufacturer or "";
      product = system.product or "";
    in
    (lib.hasPrefix "ASUS" manufacturer) || (lib.hasInfix "ROG" product);

  # Detect if system has battery (laptop)
  isLaptop =
    facter:
    let
      powerSupply = attrByPath [ "hardware" "power_supply" ] [ ] facter;
    in
    lib.any (ps: ps.type == "Battery") powerSupply;

  # Detect hybrid GPU configuration (Intel iGPU + NVIDIA dGPU)
  detectHybridGPU =
    facter:
    let
      devices = attrByPath [ "hardware" "display" ] [ ] facter;
      intelGPU = lib.any (d: lib.hasInfix "Intel" (d.vendor or "")) devices;
      nvidiaGPU = lib.any (d: lib.hasInfix "NVIDIA" (d.vendor or "")) devices;
    in
    intelGPU && nvidiaGPU;

  # Complete hardware summary extraction
  summarizeHardware =
    facter:
    let
      system = attrByPath [ "hardware" "system" ] { } facter;
    in
    {
      systemInfo = {
        manufacturer = system.manufacturer or "Unknown";
        product = system.product or "Unknown";
        version = system.version or "Unknown";
      };
      cpu = extractCPU facter;
      gpu = extractGPU facter;
      memory = extractMemory facter;
      storage = extractStorage facter;
      network = extractNetwork facter;
      isASUSROG = isASUSROG facter;
      isLaptop = isLaptop facter;
      hasHybridGPU = detectHybridGPU facter;
      virtualization = attrByPath [ "virtualisation" ] "none" facter;
    };
}
