# FPGA VGA Test Pattern Generator

[cite_start]A hardware test pattern generator based on FPGA technology, designed for diagnosing computer monitors and assessing image quality[cite: 25, 26]. [cite_start]The device is built using Verilog and generates a stable VGA video signal for resolutions up to 1920x1080 (Full HD) at a 60 Hz refresh rate[cite: 27, 28]. [cite_start]It is entirely controlled via a wireless infrared remote, eliminating the need for physical access to the board during testing[cite: 30].

[cite_start]This project was developed as an engineering thesis at the Silesian University of Technology[cite: 1, 2].

## 🌟 Key Features

* [cite_start]**Multiple Test Patterns:** Includes solid colors, grayscale/color gradients, geometric grids, and a moving screensaver to detect dead pixels, uneven backlighting, and aspect ratio issues[cite: 26, 29].
* [cite_start]**Dynamic Resolution Switching:** Supports changing output resolutions on the fly without reprogramming the FPGA[cite: 180].
* [cite_start]**Wireless IR Control:** Uses the standard NEC infrared protocol for seamless switching between patterns, colors, and resolutions[cite: 19].

## 🛠️ Hardware Requirements

To run this project, you will need the following hardware:

* [cite_start]**FPGA Development Board:** Terasic DE0-CV (Intel Cyclone V 5CEBA4F23C7N)[cite: 16, 27, 202].
* [cite_start]**IR Receiver:** VS1838B IR receiver module[cite: 204].
* [cite_start]**Remote Control:** Generic 21-key IR remote control operating on the NEC protocol[cite: 203].
* [cite_start]**Display:** A monitor with a VGA input (or active VGA-to-HDMI/DP adapter) and a standard VGA cable[cite: 184, 341].

## 🖥️ Supported Resolutions

[cite_start]The system uses an onboard 50 MHz oscillator and an internal PLL to generate the required pixel clocks for various display modes[cite: 270, 272]. 

* [cite_start]800 x 600 @ 60Hz [cite: 280, 324]
* [cite_start]1280 x 720 @ 60Hz (HD) [cite: 280, 324]
* [cite_start]1366 x 768 @ 60Hz [cite: 280, 324]
* [cite_start]1280 x 960 @ 60Hz [cite: 280, 324]
* [cite_start]1920 x 1080 @ 60Hz (Full HD) [cite: 280, 324]

## 🎨 Available Test Patterns

1. [cite_start]**Solid Colors:** Black, Red, Green, Blue, Yellow, Magenta, Cyan, and White[cite: 227].
2. [cite_start]**Grayscale Gradient:** Smooth transition from black to white (256 shades)[cite: 230].
3. [cite_start]**Color Gradient:** Smooth horizontal color transitions[cite: 244].
4. [cite_start]**Grid:** A geometric grid with white lines drawn every 64 pixels and a red border framing the active screen area[cite: 248, 249].
5. [cite_start]**Screensaver:** A moving 64x64 custom image fetched from internal ROM memory[cite: 257].

## 🏗️ Architecture Overview

[cite_start]The project is structured into modular Verilog files, operating across two primary clock domains (50 MHz system clock and the PLL-generated pixel clock)[cite: 268, 271]:

* [cite_start]`ir_decoder_nec.v`: Finite State Machine (FSM) decoding the IR signals[cite: 284].
* [cite_start]`module_control.v`: Multiplexes the video signals and parses decoded IR commands[cite: 281].
* [cite_start]`vga_controller.v`: Generates standard H-Sync, V-Sync, and blanking intervals[cite: 288, 289].
* [cite_start]`clock_selector.v` & `display_clock.v`: Manage the PLL to output the correct pixel clock for the chosen resolution[cite: 271, 274].
* [cite_start]`Pattern Generators`: Individual modules (`solid_color_display.v`, `grid.v`, etc.) outputting real-time RGB values[cite: 217, 405].

## ⚙️ Development & Synthesis

* [cite_start]**Software:** Intel Quartus Prime 23.1std SC Lite Edition[cite: 206].
* [cite_start]**Language:** Verilog HDL[cite: 209].




---
[cite_start]*Author: Michał Łagosz* [cite: 4]
