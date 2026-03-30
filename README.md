# FPGA VGA Test Pattern Generator

A hardware test pattern generator based on FPGA technology, designed for diagnosing computer monitors and assessing image quality.The device is built using Verilog and generates a stable VGA video signal for resolutions up to 1920x1080 (Full HD) at a 60 Hz refresh rate. It is entirely controlled via a wireless infrared remote, eliminating the need for physical access to the board during testing.

This project was developed as an engineering thesis at the Silesian University of Technology.

## 🌟 Key Features

* **Multiple Test Patterns:** Includes solid colors, grayscale/color gradients, geometric grids, and a moving screensaver to detect dead pixels, uneven backlighting, and aspect ratio issues[cite: 26, 29].
* ]**Dynamic Resolution Switching:** Supports changing output resolutions on the fly without reprogramming the FPGA.
* **Wireless IR Control:** Uses the standard NEC infrared protocol for seamless switching between patterns, colors, and resolutions.

## 🛠️ Hardware Requirements

To run this project, you will need the following hardware:

* **FPGA Development Board:** Terasic DE0-CV (Intel Cyclone V 5CEBA4F23C7N).
* **IR Receiver:** VS1838B IR receiver module.
* **Remote Control:** Generic 21-key IR remote control operating on the NEC protocol.
* **Display:** A monitor with a VGA input (or active VGA-to-HDMI/DP adapter) and a standard VGA cable.

## 🖥️ Supported Resolutions

The system uses an onboard 50 MHz oscillator and an internal PLL to generate the required pixel clocks for various display modes. 

* 800 x 600 @ 60Hz 
* 1280 x 720 @ 60Hz (HD) 
* 1366 x 768 @ 60Hz 
* 1280 x 960 @ 60Hz 
* 1920 x 1080 @ 60Hz (Full HD) 

## 🎨 Available Test Patterns

1. **Solid Colors:** Black, Red, Green, Blue, Yellow, Magenta, Cyan, and White.
2. **Grayscale Gradient:** Smooth transition from black to white (256 shades).
3. **Color Gradient:** Smooth horizontal color transitions.
4. **Grid:** A geometric grid with white lines drawn every 64 pixels and a red border framing the active screen area.
5. **Screensaver:** A moving 64x64 custom image fetched from internal ROM memory.

## 🏗️ Architecture Overview

The project is structured into modular Verilog files, operating across two primary clock domains (50 MHz system clock and the PLL-generated pixel clock):

* `ir_decoder_nec.v`: Finite State Machine (FSM) decoding the IR signals.
* `module_control.v`: Multiplexes the video signals and parses decoded IR commands.
* `vga_controller.v`: Generates standard H-Sync, V-Sync, and blanking intervals.
* `clock_selector.v` & `display_clock.v`: Manage the PLL to output the correct pixel clock for the chosen resolution.
* `Pattern Generators`: Individual modules (`solid_color_display.v`, `grid.v`, etc.) outputting real-time RGB values.

## ⚙️ Development & Synthesis

* **Software:** Intel Quartus Prime 23.1std SC Lite Edition.
* **Language:** Verilog HDL.




---
*Author: Michał Łagosz* 
