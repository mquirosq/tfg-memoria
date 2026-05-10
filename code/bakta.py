    bakta = which_any(["bakta"])
    if not bakta:
        raise RuntimeError("Bakta not found in PATH.")
    
    output_dir.mkdir(parents=True, exist_ok=True)
    cmd = [
        bakta,
        "--db", "/data/bakta_db",
        "--threads", str(threads),
        "--output", str(output_dir),
        "--force",
        contigs_path
    ]
    
    run_cmd(cmd, job_id=job_id)
    
    base = Path(contigs_path).stem
    preferred_gff3 = output_dir / f"{base}.gff3"
    if preferred_gff3.exists():
        gff_file = preferred_gff3
    else:
        gff_candidates = list(output_dir.glob("*.gff3"))
        if not gff_candidates:
            files = [p.name for p in output_dir.glob("*")]
            raise RuntimeError(f"Bakta did not generate a .gff3 file. Files: {files}")
        gff_file = gff_candidates[0]
        
    return gff_file
