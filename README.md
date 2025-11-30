# Dynamics of Compound Poisson Processes: Simulation & Sensitivity

![R](https://img.shields.io/badge/Language-R-blue)
![Shiny](https://img.shields.io/badge/Framework-Shiny-blue)
![Status](https://img.shields.io/badge/Status-Complete-green)

## Project Abstract
This repository implements a stochastic simulation of a **Compound Poisson Process** where jump magnitudes are governed by an Exponential distribution. This model is a critical component in **Risk Management (Ruins Theory)** and **Operations Research (Queuing Systems)**.

The project features a complete mathematical derivation of the process density and includes a robust **R Shiny Dashboard**. The application allows for real-time visualization of sample paths, validation of asymptotic behavior (Central Limit Theorem), and sensitivity analysis of model parameters.

## Mathematical Model
We model the cumulative process $S(t)$ as the random sum of random variables:

$$S(t) = \sum_{i=1}^{N(t)} X_i$$

### System Components:
* **Arrival Process $N(t)$:** Events occur according to a Poisson process with intensity $\lambda$.
* **Magnitude Process $X_i$:** Each event carries a magnitude determined by an independent Exponential distribution with rate $\theta$.

## Theoretical Foundation
To establish the probability density function (PDF) of $S(t)$, we employ the **Law of Total Probability** by conditioning on the value of the counting process $N(t)$.

### 1. The Zero State
If $N(t)=0$, the process remains at zero. This creates a discrete mass at the origin:

$$P(S(t) = 0) = e^{-\lambda t}$$

### 2. The Active State ($N(t) > 0$)
For a fixed number of jumps $n$, the sum of $n$ Exponential($\theta$) variables follows a **Gamma Distribution** ($n, \theta$). The conditional density is:

$$f_{S|n}(x) = \frac{\theta^n x^{n-1} e^{-\theta x}}{(n-1)!}$$

### 3. General Solution
Summing over all possible values of $n$ yields the unconditional PDF, which converges to a form involving the **Modified Bessel Function ($I_1$)**:

$$f_{S(t)}(x) = e^{-(\lambda t + \theta x)} \sqrt{\frac{\lambda t \theta}{x}} I_1(2\sqrt{\lambda t \theta x}), \quad x > 0$$

## Simulation Results & Analysis

### 1. Asymptotic Convergence (CLT)
The simulation tests the behavior of $S(t)$ across logarithmic time scales ($t=10, 100, 1000, 10000$).

* **Observation:** At low $t$, the distribution is heavily right-skewed (Gamma-like). As $t \to \infty$, the distribution symmetrically aligns with a Gaussian curve.
* **Validation:** The dashboard overlays a theoretical Normal curve ($\mathcal{N}(\mu, \sigma^2)$) which fits the data perfectly at high $t$, confirming the Central Limit Theorem.

### 2. Parameter Sensitivity
By manipulating $\lambda$ and $\theta$ in real-time, we observe:

* **Inter-arrival Rate ($\lambda$):** Acts as a "smoothing" agent. Higher $\lambda$ increases the event count, accelerating convergence to Normality.
* **Jump Intensity ($\theta$):** Inverse driver of volatility. A lower $\theta$ results in a larger mean jump size ($1/\theta$), significantly expanding the tail risk of the distribution.

## Interactive Dashboard (R Shiny)
The accompanying R code deploys a reactive web application.

### Key Capabilities
* **Path Simulation:** Generates stochastic "staircase" trajectories for $S(t)$.
* **Distribution Analysis:** Dynamic histogram generation with theoretical overlays.
* **Moment Matching:** Instant comparison of Simulated Moments vs. Theoretical Moments ($\mu = \lambda t / \theta$).

## Deployment Instructions

### 1. Clone the Repository
```bash
git clone [https://github.com/yourusername/compound-poisson-sim.git](https://github.com/yourusername/compound-poisson-sim.git)
    ```
