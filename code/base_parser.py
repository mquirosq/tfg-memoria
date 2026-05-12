class BaseParser():
    def parse(self, data, file, user=None, options=None):
        """Parse data and persist results.
        `options` is a dict for parser-specific flags (e.g. {'complete_version': True}).
        Must return `FileUpload`.
        """
        raise NotImplementedError