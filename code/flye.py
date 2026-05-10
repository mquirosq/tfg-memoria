    if mode == "flye":
        cmd = ["flye", "--nano-raw", reads_path, "--out-dir", str(output_dir), "--threads", str(threads)]
        run_cmd(cmd, job_id=job_id)
        contigs = output_dir / "assembly.fasta"