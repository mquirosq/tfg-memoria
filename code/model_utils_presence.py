def presence_from_list(model_features, file_upload):
    # If file_upload is None or doesn't have genes, return all zeros
    present_features = set()
    genes = getattr(file_upload, 'genes', None)
    if genes is None:
        return [0] * len(list(model_features))

    # Iterate genes and gather identifier lists
    gene_iter = genes.all()

    for gene in gene_iter:
        ids = gene.identifiers_list() or []

        for gid in ids:
            present_features.add(str(gid).strip().lower())

    # Normalize
    model_features_norm = [str(f).strip().lower() for f in model_features]

    presence_vector = [1 if feat in present_features else 0 for feat in model_features_norm]

    return presence_vector
