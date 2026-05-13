def get_model_adapter_class(name: str):
    key = name.lower() if name else ''
    if key not in MODEL_REGISTRY:
        raise ValueError(f"Model '{name}' not found in registry.")
    return MODEL_REGISTRY[key]