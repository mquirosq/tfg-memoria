def predict(self, file_upload) -> float:
    presence = presence_from_list(self._columns, file_upload)

    tensor = torch.FloatTensor([list(presence)])
    with torch.no_grad():
        raw = self.model(tensor)
        prob = torch.sigmoid(raw).squeeze().item()
    return float(prob)