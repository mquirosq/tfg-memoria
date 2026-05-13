def load(self) -> None:
    self.features()
    model = BaselineMLP(input_dim=self._input_dim, hidden_dims=self.hidden_dims, dropout=self.dropout)
    resolved_path = get_model_weights_path(self.antibiotic, self.model_name)
    checkpoint = torch.load(resolved_path, map_location='cpu')
    if isinstance(checkpoint, dict) and 'state_dict' in checkpoint:
        state_dict = checkpoint['state_dict']
    else:
        state_dict = checkpoint

    model.load_state_dict(state_dict)
    model.eval()
    self.model = model