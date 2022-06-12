#!/usr/bin/python3.8

import numpy as np
import matplotlib.pyplot as plt

## Compilation time

x_labels = ["Real", "User", "System"]
x_axis = np.arange(len(x_labels))

y_with_effects = [17.047, 16.153, 0.792]
y_without_effects = [17.047, 16.153, 0.792]

bar_width = 0.35

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

y_with_effects = [1.0, 0.7, 0.3]
y_without_effects = [1.0, 0.7, 0.3]

bar_width = 0.35

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

y_with_effects = [135.294, 100.0, 47.059]
y_without_effects = [135.294, 100.0, 47.059]

bar_width = 0.35

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

x_label = ["Real", "User", "System"]
x_axis = np.arange(len(x_label))

y_with_effects = [17.647, 13.235, 5.147]
y_without_effects = [17.647, 13.235, 5.147]

bar_width = 0.35

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

y_with_effects = [3424, 3300]
y_without_effects = [3424, 3300]

bar_width = 0.35

fig, ax = plt.subplots()
bars_with_effects = ax.bar(x_axis - bar_width / 2, y_with_effects, bar_width, label="With effects")
bars_without_effects = ax.bar(x_axis + bar_width / 2, y_without_effects, bar_width, label="Without effects")
ax.bar_label(bars_with_effects)
ax.bar_label(bars_without_effects)
plt.title("Peak memory usage during 100 simulations of a game")
ax.set_xticks(x_axis)
ax.set_xticklabels(x_labels)
plt.ylabel("Memory usage (kilobytes)")
ax.legend()
plt.show()
