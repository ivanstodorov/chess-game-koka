#!/usr/bin/python3.8

import numpy as np
import matplotlib.pyplot as plt

## Compilation time

x_labels = ["Real", "User", "System"]
x_axis = np.arange(len(x_labels))

all_with_effects = np.array([[154.59, 146.46, 7.24]])
all_without_effects = np.array([[137.91, 130.60, 6.47]])

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

all_with_effects = np.array([[0.10, 0.07, 0.04]])
all_without_effects = np.array([[0.09, 0.08, 0.02]])

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

shortest_with_effects = np.array([[0.22, 0.16, 0.07]])
shortest_without_effects = np.array([[0.22, 0.18, 0.05]])

repetitions = 100
bar_width = 0.35

for temp_with_effects, temp_without_effects in zip(shortest_with_effects, shortest_without_effects):
    y_with_effects = np.around(temp_with_effects / repetitions / 17 * 1_000_000, 2)
    y_without_effects = np.around(temp_without_effects / repetitions / 17 * 1_000_000, 2)

    fig, ax = plt.subplots()
    bars_with_effects = ax.bar(x_axis - bar_width / 2, y_with_effects, bar_width, label="With effects")
    bars_without_effects = ax.bar(x_axis + bar_width / 2, y_without_effects, bar_width, label="Without effects")
    ax.bar_label(bars_with_effects)
    ax.bar_label(bars_without_effects)
    plt.title("Average time for executing a player's turn in the\nshortest decisive, non-forfeited world championship game\n(100 simulations)")
    ax.set_xticks(x_axis)
    ax.set_xticklabels(x_labels)
    plt.ylabel(r"Time ($\mu$s)")
    ax.legend()
    plt.show()

## One player's turn (longest game)

x_labels = ["Real", "User", "System"]
x_axis = np.arange(len(x_labels))

longest_with_effects = np.array([[0.23, 0.17, 0.07]])
longest_without_effects = np.array([[0.24, 0.16, 0.08]])

repetitions = 100
bar_width = 0.35

for temp_with_effects, temp_without_effects in zip(longest_with_effects, longest_without_effects):
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

## One player's turn (shortest game vs longest game)

repetitions = 100
bar_width = 0.35

for temp_shortest, temp_longest in zip(shortest_with_effects, longest_with_effects):
    y_shortest = np.around(temp_shortest / repetitions / 17 * 1_000_000, 2)
    y_longest = np.around(temp_longest / repetitions / 136 * 1_000_000, 2)
    
    fig, ax = plt.subplots()
    bars_shortest = ax.bar(x_axis - bar_width / 2, y_shortest, bar_width, label="Shortest game")
    bars_longest = ax.bar(x_axis + bar_width / 2, y_longest, bar_width, label="Longest game")
    ax.bar_label(bars_shortest)
    ax.bar_label(bars_longest)
    plt.title("Average time for executing a player's turn \nusing custom effects\n(100 simulations)")
    ax.set_xticks(x_axis)
    ax.set_xticklabels(x_labels)
    plt.ylabel(r"Time ($\mu$s)")
    ax.legend()
    plt.show()

for temp_shortest, temp_longest in zip(shortest_without_effects, longest_without_effects):
    y_shortest = np.around(temp_shortest / repetitions / 17 * 1_000_000, 2)
    y_longest = np.around(temp_longest / repetitions / 136 * 1_000_000, 2)
    
    fig, ax = plt.subplots()
    bars_shortest = ax.bar(x_axis - bar_width / 2, y_shortest, bar_width, label="Shortest game")
    bars_longest = ax.bar(x_axis + bar_width / 2, y_longest, bar_width, label="Longest game")
    ax.bar_label(bars_shortest)
    ax.bar_label(bars_longest)
    plt.title("Average time for executing a player's turn\nwithout using custom effects\n(100 simulations)")
    ax.set_xticks(x_axis)
    ax.set_xticklabels(x_labels)
    plt.ylabel(r"Time ($\mu$s)")
    ax.legend()
    plt.show()

## Peak memory usage

x_labels = ["Shortest game", "Longest game"]
x_axis = np.arange(len(x_labels))

all_with_effects = np.array([[3412, 3316]])
all_without_effects = np.array([[3428, 3300]])

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
