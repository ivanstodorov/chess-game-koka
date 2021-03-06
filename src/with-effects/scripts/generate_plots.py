#!/usr/bin/python3.8

import numpy as np
import matplotlib.pyplot as plt

## Compilation time

x_axis = ["Real", "User", "System"]
y_all_compilation = np.array([[154.59, 146.46, 7.24]])

repetitions = 10

for y_temp in y_all_compilation:
    y_axis = np.around(y_temp / repetitions, 2)

    fig, ax = plt.subplots()
    bars = ax.bar(x_axis, y_axis)
    ax.bar_label(bars)
    plt.title("Average compilation time of the game (10 compilations)")
    plt.ylabel("Time (s)")
    plt.show()

## Start time

x_axis = ["Real", "User", "System"]
y_all_start = np.array([[0.10, 0.07, 0.04]])

repetitions = 100

for y_temp in y_all_start:
    y_axis = np.around(y_temp / repetitions * 1_000, 2)

    fig, ax = plt.subplots()
    bars = ax.bar(x_axis, y_axis)
    ax.bar_label(bars)
    plt.title("Average start time of the game (100 simulations)")
    plt.ylabel("Time (ms)")

## One player's turn (shortest game)

x_axis = ["Real", "User", "System"]
y_all_short = np.array([[0.22, 0.16, 0.07]])

repetitions = 100

for y_temp in y_all_short:
    y_axis = np.around(y_temp / repetitions / 17 * 1_000_000, 2)

    fig, ax = plt.subplots()
    bars = ax.bar(x_axis, y_axis)
    ax.bar_label(bars)
    plt.title("Average time for executing a player's turn in the\nshortest decisive, non-forfeited world championship game\n(100 simulations)")
    plt.ylabel(r"Time ($\mu$s)")

## One player's turn (longest game)

x_axis = ["Real", "User", "System"]
y_all_long = np.array([[0.23, 0.17, 0.07]])

repetitions = 100

for y_temp in y_all_long:
    y_axis = np.around(y_temp / repetitions / 136 * 1_000_000, 2)

    fig, ax = plt.subplots()
    bars = ax.bar(x_axis, y_axis)
    ax.bar_label(bars)
    plt.title("Average time for executing a player's turn in the\nlongest decisive world championship game\n(100 simulations)")
    plt.ylabel(r"Time ($\mu$s)")

## One player's turn comparison

x_labels = ["Real", "User", "System"]
x_axis = np.arange(len(x_labels))

repetitions = 100
bar_width = 0.35

for y_temp_short, y_temp_long in zip(y_all_short, y_all_long):
    y_short = np.around(y_temp_short / repetitions / 17 * 1_000_000, 2)
    y_long = np.around(y_temp_long / repetitions / 136 * 1_000_000, 2)
    
    fig, ax = plt.subplots()
    bars_short = ax.bar(x_axis - bar_width / 2, y_short, bar_width, label="Shortest game")
    bars_long = ax.bar(x_axis + bar_width / 2, y_long, bar_width, label="Longest game")
    ax.bar_label(bars_short)
    ax.bar_label(bars_long)
    plt.title("Comparison of average time for executing a player's turn\n(100 simulations)")
    ax.set_xticks(x_axis)
    ax.set_xticklabels(x_labels)
    plt.ylabel(r"Time ($\mu$s)")
    ax.legend()
    plt.show()

## Peak memory usage

x_axis = ["Shortest game", "Longest game"]
y_all_memory = np.array([[3412, 3316]])

repetitions = 100

for y_axis in y_all_memory:
    fig, ax = plt.subplots()
    bars = ax.bar(x_axis, y_axis)
    ax.bar_label(bars)
    plt.title("Peak memory usage during 100 simulations of a game")
    plt.ylabel("Memory usage (kilobytes)")
