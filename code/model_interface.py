class ModelInterface:
    
    def features(self, file_upload) -> list:
        raise NotImplementedError()

    def load(self) -> None:
        raise NotImplementedError()

    def predict(self, file_upload) -> float:
        raise NotImplementedError()