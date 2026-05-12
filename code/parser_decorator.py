@register_parser('bakta_json')
class BaktaJsonParser(BaseParser):
    
    def parse(self, data, file, user=None, options=None):
        # Lógica de parsing específica para el formato JSON generado por Bakta
        return file_upload