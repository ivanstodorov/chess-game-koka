#!/usr/bin/python3.8

import numpy as np
import matplotlib.pyplot as plt

## Compilation time

x_labels = ["Real", "User", "System"]
x_axis = np.arange(len(x_labels))

all_with_effects = np.array([[153.79, 145.16, 7.74], [153.37, 145.14, 7.31], [152.81, 144.41, 7.51], [152.92, 144.60, 7.50]])
all_without_effects = np.array([[134.17, 126.76, 6.50], [136.18, 128.62, 6.61], [135.17, 127.75, 6.47], [135.11, 127.57, 6.64]])

repetitions = 10
bar_width = 0.35

for temp_with_effects, temp_without_effects in zip(all_with_effects, all_without_effects):
    y_with_effects = np.around(temp_with_effects / repetitions, 2)
    y_without_effects = np.around(temp_without_effects / repetitions, 2)
    
    fig, ax = plt.subplots()
    bars_with_effects = ax.bar(x_axis - bar_width / 2, y_with_effects, bar_width, label="With effects")
    bars_without_effects = ax.bar(x_axis + bar_width / 2, y_without_effects, bar_width, label="Without effects")
    ax.bar_label(bars_with_effects)
    ax.bar_label(bars_without_effects)
    plt.title("Average compilation time of the game (10 compilations)")
    ax.set_xticks(x_axis)
    ax.set_xticklabels(x_labels)
    plt.ylabel("Time (s)")
    ax.legend()
    plt.show()

## Start time

x_labels = ["Real", "User", "System"]
x_axis = np.arange(len(x_labels))

all_with_effects = np.array([[0.09, 0.06, 0.02], [0.14, 0.11, 0.04], [0.09, 0.06, 0.03], [0.14, 0.11, 0.04]])
all_without_effects = np.array([[0.09, 0.06, 0.03], [0.10, 0.07, 0.03], [0.09, 0.07, 0.03], [0.09, 0.06, 0.03]])

repetitions = 100
bar_width = 0.35

for temp_with_effects, temp_without_effects in zip(all_with_effects, all_without_effects):
    y_with_effects = np.around(temp_with_effects / repetitions * 1_000, 2)
    y_without_effects = np.around(temp_without_effects / repetitions * 1_000, 2)
        
    fig, ax = plt.subplots()
    bars_with_effects = ax.bar(x_axis - bar_width / 2, y_with_effects, bar_width, label="With effects")
    bars_without_effects = ax.bar(x_axis + bar_width / 2, y_without_effects, bar_width, label="Without effects")
    ax.bar_label(bars_with_effects)
    ax.bar_label(bars_without_effects)
    plt.title("Average start time of the game (100 simulations)")
    ax.set_xticks(x_axis)
    ax.set_xticklabels(x_labels)
    plt.ylabel("Time (ms)")
    ax.legend()
    plt.show()

## One player's turn (shortest game)

x_labels = ["Real", "User", "System"]
x_axis = np.arange(len(x_labels))

all_with_effects = np.array([[0.12, 0.10, 0.03], [0.22, 0.17, 0.06], [0.10, 0.08, 0.02], [0.24, 0.19, 0.07]])
all_without_effects = np.array([[0.17, 0.14, 0.04], [0.24, 0.19, 0.06], [0.23, 0.16, 0.08], [0.10, 0.08, 0.02]])

repetitions = 100
bar_width = 0.35

for temp_with_effects, temp_without_effects in zip(all_with_effects, all_without_effects):
    y_with_effects = np.around(temp_with_effects / repetitions / 17 * 1_000_000, 2)
    y_without_effects = np.around(temp_without_effects / repetitions / 17 * 1_000_000, 2)

    fig, ax = plt.subplots()
    bars_with_effects = ax.bar(x_axis - bar_width / 2, y_with_effects, bar_width, label="With effects")
    bars_without_effects = ax.bar(x_axis + bar_width / 2, y_without_effects, bar_width, label="Without effects")
    ax.bar_label(bars_with_effects)
    ax.bar_label(bars_without_effects)
    plt.title("Average time for executing a player's turn in the\nshortest decisive world championship game\n(100 simulations)")
    ax.set_xticks(x_axis)
    ax.set_xticklabels(x_labels)
    plt.ylabel(r"Time ($\mu$s)")
    ax.legend()
    plt.show()

## One player's turn (longest game)

x_labels = ["Real", "User", "System"]
x_axis = np.arange(len(x_labels))

all_with_effects = np.array([[0.24, 0.18, 0.08], [0.24, 0.17, 0.09], [0.22, 0.16, 0.08], [0.25, 0.18, 0.08]])
all_without_effects = np.array([[0.25, 0.19, 0.07], [0.24, 0.19, 0.07], [0.25, 0.18, 0.08], [0.24, 0.18, 0.07]])

repetitions = 100
bar_width = 0.35

for temp_with_effects, temp_without_effects in zip(all_with_effects, all_without_effects):
    y_with_effects = np.around(temp_with_effects / repetitions / 136 * 1_000_000, 2)
    y_without_effects = np.around(temp_without_effects / repetitions / 136 * 1_000_000, 2)
    
    fig, ax = plt.subplots()
    bars_with_effects = ax.bar(x_axis - bar_width / 2, y_with_effects, bar_width, label="With effects")
    bars_without_effects = ax.bar(x_axis + bar_width / 2, y_without_effects, bar_width, label="Without effects")
    ax.bar_label(bars_with_effects)
    ax.bar_label(bars_without_effects)
    plt.title("Average time for executing a player's turn in the\nlongest decisive world championship game\n(100 simulations)")
    ax.set_xticks(x_axis)
    ax.set_xticklabels(x_labels)
    plt.ylabel(r"Time ($\mu$s)")
    ax.legend()
    plt.show()

## Peak memory usage

x_labels = ["Shortest game", "Longest game"]
x_axis = np.arange(len(x_labels))

all_with_effects = np.array([[3404, 3356], [3420, 3380], [3460, 3300], [3428, 3432]])
all_without_effects = np.array([[3392, 3400], [3396, 3344], [3384, 3304], [3336, 3432]])

bar_width = 0.35

for y_with_effects, y_without_effects in zip(all_with_effects, all_without_effects):
    fig, ax = plt.subplots()
    bars_with_effects = ax.bar(x_axis - bar_width / 2, y_with_effects, bar_width, label="With effects")
    bars_without_effects = ax.bar(x_axis + bar_width / 2, y_without_effects, bar_width, label="Without effects")
    ax.bar_label(bars_with_effects)
    ax.bar_label(bars_without_effects)
    plt.title("Peak memory usage during 100 simulations of a game")
    ax.set_xticks(x_axis)
    ax.set_xticklabels(x_labels)
    plt.ylabel("Memory usage (kilobytes)")
    ax.legend(loc='lower left')
    plt.show()
