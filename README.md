# Course Syllabus: Embodied AI from Scratch (EAI-336)

**Foundations, Architectures, Scaling, and Systems for Generalist Robot Policies**

The "course" is inspired by [Stanford CS 336](https://cs336.stanford.edu/) cource which has 5 high-quality experiment handouts.

## The Core Pipeline

```mermaid
flowchart LR
    M1["Physical Grounding<br/>Module 1"] --> M2["Model Architecture<br/>Module 2"]
    M2 --> M3["Offline Policy Learning<br/>Module 3"]
    M3 --> M4["Data Engineering<br/>Module 4"]
    M4 --> M5["Scaling Laws<br/>Module 5"]
    M5 --> M6["Closed-Loop Systems<br/>Module 6"]
    M6 --> M7["Online Adaptation<br/>Module 7"]
```

### Module 1: Robotic Control, Kinematics, and Simulation

Objective: Demystify the physical interface. Build first-principles intuition for forward/inverse kinematics, rigid-body contact dynamics, and coordinate frames without relying on high-level robotics middleware. In extension, some mainstream high-level utils are briefly demonstrated.

Theoretical Foundations:

- Rigid-Body Mechanics & Simulation: Equations of motion, generalized coordinates ($q, \dot{q}$), numerical integrators (Semi-implicit Euler, Runge-Kutta), collision contact impulses in MuJoCo / SAPIEN.
- $SE(3)$ Geometry & Coordinate Representations: Transformations between Base, End-Effector (EEF), and Camera frames; mathematical pitfalls of Euler angles (gimbal lock) and unit quaternions (double cover); Continuous 6D Rotation representations for gradient stability.
- Control Paradigms: Forward Kinematics (FK), Jacobian computation, Damped Least-Squares Inverse Kinematics (IK), Operational Space Control (OSC), and joint-level impedance control.

From-Scratch Implementation:

- Pure NumPy/PyTorch implementations of $SE(3)$ transformation pipelines and 6D rotation conversions.
- A standard Gymnasium-compliant step loop interfacing with MuJoCo, handling camera rendering, proprioceptive state extraction, and Cartesian delta actions.
- High-level utils demonstration.
- Deliverable: A functional simulation sandbox where a simulated Franka Emika or ALOHA arm reaches and grasps objects via a custom Cartesian controller.

### Module 2: Embodied Model Architectures & World Models

Objective: Construct the neural substrate mapping high-dimensional multimodal streams to action representations and physical state forecasts.

Theoretical Foundations:

- Multimodal Perception: ViT and SigLIP patchification, 2D spatiotemporal position embeddings, learned camera-view tokens, and proprioceptive MLPs.
- Fusion Bridges & Backbones: Linear projectors vs. Cross-Attention bottlenecks (Perceiver Resamplers) vs. unified causal concatenation; the concept of World-Action Models (WAM) that jointly forecast action intent and predict future latent world states ($\hat{s}_{t+1}$).

Action Head Parameterizations:

1. Discrete Autoregressive Heads: 256-bin uniform/quantile discretization with categorical cross-entropy.
2. Latent Variable Heads: Conditional Variational Autoencoders (CVAE) for Action Chunking (ACT).
3. Generative Continuous Heads: DiT (Diffusion Transformer) and vector-field prediction backbones.

From-Scratch Implementation:

- A bare-bones end-to-end VLA architecture implemented purely in PyTorch (no Hugging Face abstractions).
- Deliverable: Unit-tested forward pass validating tensor shapes from raw RGB-D images and proprioception to multi-action prediction chunks.

### Module 3: Offline Policy Learning: Objectives and Optimization

Objective: Master the mathematical formulations, loss landscapes, and optimization dynamics required to fit action distributions on offline demonstration datasets.

Theoretical Foundations:

- Imitation Learning as Distribution Matching: Behavior Cloning (BC) under deterministic regression vs. the mode-collapse failure mode in multimodal action trajectories.
- Denoising Diffusion Probabilistic Models (DDPM/DDIM): Forward noise schedules, Gaussian transition kernels, and residual noise estimation loss:
  $$\mathcal{L}_{\text{Diffusion}} = \mathbb{E}_{t, x_0, \epsilon} \left[ \|\epsilon - \epsilon_\theta(x_t, t, c)\|^2 \right]$$
- Optimal Transport Conditional Flow Matching (OT-CFM): Probability paths, conditional vector fields $u_t(x_1 | x_0) = x_1 - x_0$, and regression on the flow field:
  $$\mathcal{L}_{\text{CFM}} = \mathbb{E}_{t, x_0, x_1} \left[ \|v_\theta(x_t, t, c) - (x_1 - x_0)\|^2 \right]$$
- Optimization Dynamics: AdamW, Cosine learning-rate decay with warmup, gradient clipping, and the crucial role of Exponential Moving Average (EMA) on policy weights.

From-Scratch Implementation:

- The exact OT-CFM loss function and an iterative numerical ODE integrator (Euler/Midpoint) written in native PyTorch.
- Deliverable: Complete training loop fitting a continuous flow-matching policy on a bimanual manipulation dataset, tracking offline metrics: Average Displacement Error (ADE) and Final Displacement Error (FDE).

### Module 4: Embodied Data Engineering

Objective: Address the unglamorous, critical data pipelines required to ingest, clean, harmonize, and stream petabyte-scale heterogeneous robot demonstrations.

Theoretical Foundations:

- Dataset Standards: Anatomy of Open X-Embodiment (OXE/RLDS) and LeRobot (Parquet + MP4 / Zarr); chunk-based disk caching and multithreaded dataloading under high-frequency control limits.
- State & Action Harmonization: Converting heterogeneous robot embodiments into a shared canonical action space (Delta EEF pose, 6D continuous rotation, gripper state mapping).
- Statistical Normalization: Why naive Min-Max scaling causes catastrophic gradient spikes on outliers; implementing Quantile Normalization ($q_{01}, q_{99}$).
- Trajectory Cleansing: Automated pruning of human operator idling/hesitation frames, singularity filtering, and spatial data augmentations.

From-Scratch Implementation:

- An automated data processing pipeline that takes raw, unstructured episode logs, cleans them, applies quantile normalization, and packages them into high-throughput streaming tensors.
- Deliverable: A standardized, reproducible data pipeline processing raw teleoperation data into training-ready LeRobot-style formats.

### Module 5: Embodied Scaling Laws

Objective: Measure and extrapolate compute-optimal configurations for robot foundation models under strict GPU-hour budgets.

Theoretical Foundations:

- FLOPs Accounting in Robotics: Deriving exact FLOP formulations incorporating visual patch count ($H \times W / P^2$), history horizon, causal backbone layers, and diffusion/flow denoising integration steps ($N_{\text{ODE}}$).
- IsoFLOPs Profiles: Fitting empirical power laws to offline validation loss:
  $$L(N, D) = E + \frac{A}{N^\alpha} + \frac{B}{D^\beta}$$
  where $N$ is parameter count and $D$ is demonstration hours.
- Hyperparameter Transfer ($\mu$P): Zero-shot transfer of optimal learning rates and initialization scales from sub-100M parameter toy models to multi-billion parameter VLAs.
- The "Loss-to-Success Gap": Analytical exploration of why lower offline validation loss does not always guarantee a higher physical rollout success rate.

From-Scratch Implementation:

- A grid-search scaling suite querying small-scale models across compute budgets, fitting power-law surfaces via `scipy.optimize.curve_fit`.
- Deliverable: A CS336-style technical report predicting the compute-optimal parameter size and demonstration hours for a target 48 GPU-hour budget.

### Module 6: Real-Time Closed-Loop Systems

Objective: Bridge the gap between a static offline neural network and an embodied system interacting in real time with dynamic physical environments.

Theoretical Foundations:

- Asynchronous Control Architectures: Resolving the frequency mismatch between low-frequency foundation model inference (5–10 Hz) and high-frequency joint servo loops (50–100 Hz) using non-blocking queues.
- Action Chunking & Temporal Ensembling: Receding horizon execution; eliminating motion jerk via exponential moving average smoothing across overlapping trajectory predictions:
  $$a_t = \sum_{i=1}^k w_i \cdot \hat{a}_{t|t-i}$$
- Ultra-Fast Solvers & Latency Compensation: Evaluating the Pareto frontier between ODE sampling steps (1-step vs. 4-step Euler) and end-to-end control latency.
- Edge Deployment: KV-cache state preservation, weight quantization (FP8 / INT4), and memory-bandwidth management for onboard GPUs (e.g., Jetson Orin).

From-Scratch Implementation:

- A dual-threaded asynchronous inference engine: Thread 1 runs high-frequency simulation stepping; Thread 2 manages background continuous flow sampling and buffer updating.
- Deliverable: Zero-jerk, smooth closed-loop execution of complex manipulation tasks in simulation under simulated latency.

### Module 7: Online Policy Learning, Adaptation, and Alignment

Objective: Enable the policy to recover from failures, adapt to out-of-distribution states, and surpass human demonstration limits via active environment interaction.

Theoretical Foundations:

- Covariate Shift & Compounding Errors: Theoretical analysis of why $O(\epsilon T^2)$ error cascades occur when Behavior Cloning encounters out-of-distribution (OOD) states.
- Interactive Imitation & Intervention (Human-in-the-Loop): DAgger and HG-DAgger algorithms; intervention-based fine-tuning using human corrective control.
- Trajectory-Level Preference Alignment (Action-DPO): Adapting Direct Preference Optimization to continuous action spaces using autonomous rollouts:
  $$\mathcal{L}_{\text{Action-DPO}} = -\log \sigma \left( \beta \log \frac{\pi_\theta(y_w | x)}{\pi_{\text{ref}}(y_w | x)} - \beta \log \frac{\pi_\theta(y_l | x)}{\pi_{\text{ref}}(y_l | x)} \right)$$
  where $y_w$ is a successful trajectory chunk and $y_l$ is a failed attempt.
- Massively Parallel Online RL: Bootstrapping from an offline policy and fine-tuning via PPO or SAC in high-throughput GPU environments (IsaacLab, ManiSkill).

From-Scratch Implementation:

- An automated failure-recovery pipeline injecting force disturbances into the robot, collecting recovery rollouts, and fine-tuning the policy via Action-DPO or DAgger.
- Deliverable: A competitive policy evaluated on a hidden suite of randomized perturbation tests, demonstrating autonomous self-correction upon task failure.
