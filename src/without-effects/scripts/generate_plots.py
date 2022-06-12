#!/usr/bin/python3.8

import matplotlib.pyplot as plt

## Compilation time

x_axis = ["Real", "User", "System"]
y_axis = [17.047, 16.153, 0.792]

fig, ax = plt.subplots()
bars = ax.bar(x_axis, y_axis)
ax.bar_label(bars)
plt.title("Average compilation time of the game (10 compilations)")
plt.ylabel("Time (s)")

## Start time

x_axis = ["Real", "User", "System"]
y_axis = [1.0, 0.7, 0.3]

fig, ax = plt.subplots()
bars = ax.bar(x_axis, y_axis)
ax.bar_label(bars)
plt.title("Average start time of the game (100 simulations)")
plt.ylabel("Time (ms)")

## One player's turn (shortest game)

x_axis = ["Real", "User", "System"]
y_axis = [135.294, 100.0, 47.059]

fig, ax = plt.subplots()
bars = ax.bar(x_axis, y_axis)
ax.bar_label(bars)
plt.title("Average time for executing a player's turn in the\nshortest decisive world championship game\n(100 simulations)")
plt.ylabel(r"Time ($\mu$s)")

## One player's turn (longest game)

x_axis = ["Real", "User", "System"]
y_axis = [17.647, 13.235, 5.147]

fig, ax = plt.subplots()
bars = ax.bar(x_axis, y_axis)
ax.bar_label(bars)
plt.title("Average time for executing a player's turn in the\nlongest decisive world championship game\n(100 simulations)")
plt.ylabel(r"Time ($\mu$s)")

## Peak memory usage

x_axis = ["Shortest game", "Longest game"]
y_axis = [3424, 3300]

fig, ax = plt.subplots()
bars = ax.bar(x_axis, y_axis)
ax.bar_label(bars)
plt.title("Peak memory usage during 100 simulations of a game")
plt.ylabel("Memory usage (kilobytes)")
