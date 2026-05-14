def get_prediction_matrix(model_names: list[str], antibiotics: list[str], file_upload) -> dict:
    data = {}
    for antibiotic in antibiotics:
        row = {}
        for model_name in model_names:
            try:
                row[model_name] = get_prediction(model_name, antibiotic, file_upload)
            except Exception:
                row[model_name] = None
        data[antibiotic] = row

    return data
