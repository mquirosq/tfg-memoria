def perform_illumina_assembly(r1_path: str, r2_path: str, output_dir: Path, 
                               threads: int, memory: int, assembler: str = None, job_id: str = None):
    
    spades = assembler if assembler else which_any(["spades.py", "spades"])
    if not spades:
        raise RuntimeError("SPAdes not found in PATH.")
    
    output_dir.mkdir(parents=True, exist_ok=True)
    cmd = [spades, "--threads", str(threads), "--memory", str(memory), "-o", str(output_dir)]
    
    if r2_path:
        cmd += ["-1", r1_path, "-2", r2_path]
    elif r1_path:
        cmd += ["-s", r1_path]
    else:
        raise ValueError("For Illumina specify --r1 (and optionally --r2).")
    
    run_cmd(cmd, job_id=job_id)

    contigs = output_dir / "contigs.fasta"
    if not contigs.exists():
        raise RuntimeError("SPAdes did not generate contigs.fasta")
    
    final = output_dir / "contigs.filtered.fasta"
    append_job_log(job_id, f"Illumina assembly completed: {final}")
    return final