def parse_file(parser, data, file, user=None, options=None):
    parser = get_parser(parser)
    if not parser:
        raise RuntimeError(f'No parser registered for parser: {parser}')
    return parser.parse(data, file, user=user, options=options)
