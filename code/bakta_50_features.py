def features(self) -> list[str]:
    if self._columns is None:
        self._columns = get_columns_from_pickle(self.model_name, self.column_file_name)
        self._columns = self._process_column_names(self._columns)

    if self._input_dim is None:
        self._input_dim = len(self._columns)
    return self._columns

def _process_column_names(self, names: Iterable[str]) -> list[str]:
    names = [n for n in names if not str(n).startswith("a_")]
    out = [n if str(n).startswith("UniRef:UniRef50_") else f"UniRef:UniRef50_{n}" for n in names]
    return out