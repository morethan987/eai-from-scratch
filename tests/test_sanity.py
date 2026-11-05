def test_environment_sanity():
    """Test python env and dependencies"""
    import mujoco
    import torch

    assert torch.__version__ is not None
    assert mujoco.__version__ is not None
