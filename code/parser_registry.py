PARSERS = {}

def register_parser(name):
    def decorator(cls):
        PARSERS[name] = cls()
        return cls
    return decorator

def get_parser(name):
    return PARSERS.get(name)