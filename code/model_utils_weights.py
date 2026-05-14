def get_model_weights_path(antibiotic: str, model_name: str) -> str:
    base_dir = Path(__file__).resolve().parents[1]
    pesos_dir = base_dir / 'ai_models' / model_name / 'pesos'
    candidate = pesos_dir / f"{antibiotic}.pt"
    if not candidate.exists():
        raise FileNotFoundError(f"Weights file not found: {candidate}")
    return str(candidate)