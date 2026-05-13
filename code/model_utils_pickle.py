def get_columns_from_pickle(model_name: str, column_file_name: str) -> list:
    base_dir = Path(__file__).resolve().parents[1]
    pkl_path = base_dir / 'ai_models' / model_name / column_file_name
    with open(pkl_path, 'rb') as f:
        columns = pickle.load(f)
    return columns