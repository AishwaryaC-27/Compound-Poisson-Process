# Sensitivity Analysis of Compound Poisson-Exponential Processes

## Project Overview

This project explores the **Compound Poisson Process**, specifically the case where the jump sizes follow an Exponential distribution. This stochastic process is fundamental in fields such as **Actuarial Science (Cramér–Lundberg model)**, **Queuing Theory**.

The repository contains a theoretical derivation of the process's distribution and an interactive **R Shiny application** that visualizes the process, demonstrates the Central Limit Theorem (CLT), and performs sensitivity analysis on the parameters.

## Mathematical Framework

The process is defined as:

$$S(t) = \sum_{i=1}^{N(t)} X_i$$

Where:
* **$N(t)$**: The counting process following a **Poisson distribution** with rate $\lambda$.
* **$X_i$**: The jump sizes following an **Exponential distribution** with rate $\theta$.

### Key Derivations
Using the Moment Generating Function (MGF) method, we derived the MGF of $S(t)$ as:

$$M_{S(t)}(s) = \exp\left( \frac{\lambda t s}{\theta - s} \right)$$

The resulting probability density function (PDF) for $S(t) > 0$ is identified as a **Poisson-weighted mixture of Gamma distributions**, expressible using the Modified Bessel Function of the first kind ($I_1$):

$$f_{S(t)}(x) = e^{-\lambda t - \theta x} \sqrt{\frac{\lambda t \theta}{x}} I_1(2\sqrt{\lambda t \theta x})$$

## Visualizations & Insights

### 1. Central Limit Theorem (CLT)
The simulation demonstrates that as time $t$ increases, the distribution of $S(t)$ converges from a skewed mixture distribution to a symmetric **Normal Distribution**.
* **Small $t$:** Highly skewed, significant probability mass at 0.
* **Large $t$:** Bell-shaped curve centered at $\mu = \frac{\lambda t}{\theta}$.

### 2. Sensitivity Analysis
The R Shiny app allows users to toggle $\lambda$ (inter-arrival rate) and $\theta$ (jump size rate) to observe:
* **Impact of $\lambda$:** Higher frequency leads to faster convergence to normality and higher variance.
* **Impact of $\theta$:** Smaller $\theta$ implies larger jump sizes, leading to "heavier" tails and greater volatility.

## R Shiny Application

The project includes an interactive dashboard to visualize these concepts dynamically.

### Features
* **Interactive Sliders:** Control Inter-arrival rate ($\lambda$) and Jump rate ($\theta$).
* **Time Selector:** Visualize the process at $t=10, 100, 1000, 10000$.
* **Dynamic Plotting:** Overlays the theoretical Normal approximation curve on top of the simulated histogram.
* **Real-time Statistics:** Calculates and compares simulated vs. theoretical Mean and Variance.

### How to Run Locally

1.  **Clone the repository:**
    ```bash
    git clone the repository
    ```

2.  **Open R/RStudio** and install required packages:
    ```r
    install.packages(c("shiny", "ggplot2"))
    ```

3.  **Run the App:**
    ```r
    library(shiny)
    runApp("rshinystoch.R")
    ```
