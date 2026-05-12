def parse(self, data, file, user, complete=False):
    file_upload = FileUpload.objects.create(file=file, user=user)
    features = data.get('features', [])
    for gene in features:
        gene_name = gene.get('gene')
        gene_db_xrefs = gene.get('db_xrefs')
        gene_product = gene.get('product')
        identifiers = []
        if gene_db_xrefs:
            for xref in gene_db_xrefs:
                identifiers.append(xref)
        if gene_product: 
            identifiers.append(gene_product)
        if gene_name: 
            identifiers.append(gene_name)

        identifiers = {ident.strip() for ident in identifiers}
        gene_obj = None
        if identifiers:
            gene_obj = Gene.objects.search_identifiers(identifiers).first()
            if not gene_obj:
                gene_obj = Gene.objects.create()
            gene_obj.add_identifiers(identifiers)

        expert_field = gene.get('expert')[0] if gene.get('expert') else None
        expert_type = expert_field.get('type') if expert_field else 'unknown'
        if gene_obj:
            file_gene = FileGene.objects.create(
                file_upload=file_upload, gene=gene_obj, expert=expert_type)
            if complete:
                file_gene.start = gene.get('start')
                file_gene.stop = gene.get('stop')
                file_gene.nt = gene.get('nt')
                file_gene.aa = gene.get('aa')
                file_gene.save(update_fields=['start', 'stop', 'nt', 'aa'])
            file_upload.genes.add(gene_obj)